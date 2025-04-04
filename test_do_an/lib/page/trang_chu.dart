import 'package:flutter/material.dart';
import 'package:test_do_an/page/artist_album.dart';
import '/component/custom_music_bar.dart';
import '/component/custom_drawer_nav.dart';
import 'package:test_do_an/helper/user_session.dart';
import 'package:test_do_an/helper/database_helper.dart';
import 'package:test_do_an/helper/audio_player_manager.dart';
import 'dart:io';

class TrangChu extends StatefulWidget {
  @override
  _TrangChuState createState() => _TrangChuState();
}

class _TrangChuState extends State<TrangChu> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AudioPlayerManager _audioManager = AudioPlayerManager();
  List<Map<String, dynamic>> songs = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final fetchedSongs =
          await DatabaseHelper.instance.getRandomSongs(limit: 8);
      setState(() {
        songs = fetchedSongs;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải bài hát: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String userName = UserSession.currentUser?['name'] ?? 'Người dùng';
    String? avatarPath = UserSession.currentUser?['avatar'];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromRGBO(18, 18, 18, 1),
      drawer: NavigationWidget(),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(18, 18, 18, 1),
        leading: GestureDetector(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Container(
            margin: EdgeInsets.only(left: 15),
            child: CircleAvatar(
              radius: 25,
              backgroundImage: avatarPath != null && avatarPath.isNotEmpty
                  ? FileImage(File(avatarPath))
                  : AssetImage('assets/images/avatar.png') as ImageProvider,
            ),
          ),
        ),
        title: Text(
          'Xin chào, $userName!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Arial',
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            _buildSection(),
            _build_3_album(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: CustomMusicBar(),
      ),
    );
  }

  Widget _buildSection() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15.0,
        right: 15.0,
        top: 0.0,
        bottom: 20.0,
      ),
      child: _isLoading
          ? Center(child: CircularProgressIndicator())
          : songs.isEmpty
              ? Center(
                  child: Text(
                    'Không có bài hát nào',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 2.8,
                  ),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    return _buildGridItem(
                        song['title'],
                        song['avatar'] ?? 'assets/images/random.png',
                        song['id']);
                  },
                ),
    );
  }

  Widget _build_3_album() {
    return Column(
      children: [
        _buildSectionAlbums('Nghệ sĩ bạn thích',
            DatabaseHelper.instance.getRandomArtistAlbums()),
        _buildSectionAlbums(
            'Gần đây', DatabaseHelper.instance.getRandomArtistAlbums()),
        _buildSectionAlbums('Được đánh giá nhất',
            DatabaseHelper.instance.getRandomArtistAlbums()),
      ],
    );
  }

  // Item thẻ
  Widget _buildGridItem(String title, String imagePath, int songId) {
    return GestureDetector(
      onTap: () async {
        try {
          await _audioManager.playSongById(songId);
          setState(() {});
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi khi phát bài hát: $e')),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF292929),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.only(
          left: 0,
          right: 10,
          top: 0,
          bottom: 0,
        ),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              child: Image.asset(
                imagePath,
                width: 70,
                height: 80,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hàng Album
  Widget _buildSectionAlbums(
      String title, Future<List<Map<String, dynamic>>> albumsFuture) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: albumsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Lỗi khi tải album: ${snapshot.error}',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    'Không có album nào',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              final albums = snapshot.data!;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: albums.map((album) {
                    return _buildAlbumCard(
                      album['name'],
                      album['avatar'] ?? 'assets/images/random.png',
                      album['artistId'],
                      album['artistName'],
                      album['artistAvatar'],
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Item Album
  Widget _buildAlbumCard(String title, String imagePath, int artistId,
      String artistName, String? artistAvatar) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Artist_Album_Detail_Page(
              artistId: artistId,
              artistName: artistName,
              artistAvatar: artistAvatar ?? 'assets/images/random.png',
              albumName: title,
              albumAvatar: imagePath,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.4), Colors.transparent],
              ),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
