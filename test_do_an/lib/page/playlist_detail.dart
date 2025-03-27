import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import để dùng HapticFeedback
import 'package:test_do_an/component/playlist_options_bottomsheet.dart';
import 'package:test_do_an/helper/database_helper.dart';
import 'package:test_do_an/helper/audio_player_manager.dart';
import 'package:test_do_an/helper/user_session.dart';
import 'dart:io'; // Import để dùng File

class PlaylistDetailPage extends StatefulWidget {
  final int albumId;
  final String albumName;

  const PlaylistDetailPage({
    required this.albumId,
    required this.albumName,
  });

  @override
  _PlaylistDetailPageState createState() => _PlaylistDetailPageState();
}

class _PlaylistDetailPageState extends State<PlaylistDetailPage> {
  String? albumImage;
  bool isDefault = false;

  @override
  void initState() {
    super.initState();
    _loadAlbumDetails();
    _loadAlbumImage();
  }

  Future<void> _loadAlbumDetails() async {
    Map<String, dynamic>? album =
        await DatabaseHelper.instance.getAlbumById(widget.albumId);
    if (album != null) {
      setState(() {
        isDefault = album['isDefault'] == 1;
      });
    }
  }

  Future<void> _loadAlbumImage() async {
    String image = await _getAlbumImage(widget.albumId);
    setState(() {
      albumImage = image;
    });
  }

  Future<List<Map<String, dynamic>>> _getSongsInAlbum(int albumId) async {
    final db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> albumSongs = await db.query(
      'album_songs',
      where: 'albumId = ?',
      whereArgs: [albumId],
    );

    List<Map<String, dynamic>> songs = [];
    for (var albumSong in albumSongs) {
      Map<String, dynamic>? song =
          await DatabaseHelper.instance.getSongById(albumSong['songId']);
      if (song != null) {
        songs.add(song);
      }
    }
    return songs;
  }

  Future<String> _getAlbumImage(int albumId) async {
    List<Map<String, dynamic>> songs = await _getSongsInAlbum(albumId);
    if (songs.isNotEmpty) {
      return songs.first['avatar'] ?? 'assets/images/song_icon.png';
    }
    return 'assets/images/song_icon.png';
  }

  void showPlaylistOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color.fromRGBO(18, 18, 18, 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => PlaylistOptionsBottomSheet(
        albumId: widget.albumId,
        albumName: widget.albumName,
        isDefault: isDefault,
      ),
    ).then((_) {
      // Làm mới giao diện sau khi thêm/xóa bài hát
      setState(() {});
    });
  }

  ImageProvider _getAvatarImage(String? avatarPath) {
    if (avatarPath == null || avatarPath.isEmpty) {
      return AssetImage('assets/images/avatar.png');
    }
    if (avatarPath.startsWith('assets/')) {
      return AssetImage(avatarPath);
    }
    if (File(avatarPath).existsSync()) {
      return FileImage(File(avatarPath));
    }
    return AssetImage('assets/images/avatar.png');
  }

  @override
  Widget build(BuildContext context) {
    String userName = UserSession.currentUser?['name'] ?? 'Người dùng';
    String? avatarPath = UserSession.currentUser?['avatar'];

    return Scaffold(
      backgroundColor: Color.fromRGBO(18, 18, 18, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 320,
                width: 320,
                decoration: BoxDecoration(color: Colors.grey[800]),
                child: albumImage != null
                    ? Image.asset(
                        albumImage!,
                        fit: BoxFit.cover,
                      )
                    : Center(child: CircularProgressIndicator()),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.albumName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundImage: _getAvatarImage(avatarPath),
                        ),
                        SizedBox(width: 8),
                        Text(
                          userName,
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(width: 10),
                        IconButton(
                          icon: Icon(Icons.more_horiz, color: Colors.white),
                          onPressed: () =>
                              showPlaylistOptionsBottomSheet(context),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.play_arrow,
                      color: Colors.black,
                      size: 35,
                    ),
                    onPressed: () async {
                      List<Map<String, dynamic>> songs =
                          await _getSongsInAlbum(widget.albumId);
                      if (songs.isNotEmpty) {
                        await AudioPlayerManager()
                            .playSongById(songs.first['id']);
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Text(
              "Danh sách bài hát",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _getSongsInAlbum(widget.albumId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Lỗi khi tải danh sách bài hát: ${snapshot.error}',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'Chưa có bài hát nào trong album này',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  );
                }

                final songs = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    return GestureDetector(
                      onTap: () async {
                        HapticFeedback.lightImpact();
                        await AudioPlayerManager().playSongById(song['id']);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 5, right: 15, top: 8, bottom: 8),
                        child: Row(
                          children: [
                            Text(
                              "${index + 1}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            SizedBox(width: 15),
                            Image.asset(
                              song['avatar'] ?? 'assets/images/random.png',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    song['title'],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                  Text(
                                    song['artist'],
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.more_horiz, color: Colors.white),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor:
                                      Color.fromRGBO(18, 18, 18, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20)),
                                  ),
                                  builder: (context) => Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: Icon(
                                              Icons.remove_circle_outline,
                                              color: Colors.red),
                                          title: Text(
                                            "Xóa khỏi playlist",
                                            style: TextStyle(
                                                color: Colors.redAccent),
                                          ),
                                          onTap: () async {
                                            await DatabaseHelper.instance
                                                .removeSongFromAlbum(
                                                    widget.albumId, song['id']);
                                            Navigator.pop(context);
                                            setState(() {});
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
