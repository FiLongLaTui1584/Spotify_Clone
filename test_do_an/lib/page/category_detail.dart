import 'package:flutter/material.dart';
import 'package:test_do_an/helper/audio_player_manager.dart';
import 'package:test_do_an/helper/database_helper.dart';
import 'package:test_do_an/helper/user_session.dart';
import 'dart:math'; // Để tạo số lượt nghe giả

class CategoryDetailPage extends StatefulWidget {
  final String categoryName;
  final String categoryAvatar;

  const CategoryDetailPage({
    Key? key,
    required this.categoryName,
    required this.categoryAvatar,
  }) : super(key: key);

  @override
  _CategoryDetailPageState createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  final AudioPlayerManager _audioManager = AudioPlayerManager();
  List<Map<String, dynamic>> songs = [];
  bool _isLoading = false;
  Map<int, bool> _isFavoriteMap = {}; // Trạng thái yêu thích của bài hát
  List<String> _fakePlayCounts = []; // Danh sách lượt nghe giả

  @override
  void initState() {
    super.initState();
    _loadRandomSongs();
  }

  Future<void> _loadRandomSongs() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final fetchedSongs = await DatabaseHelper.instance
          .getRandomSongs(limit: 10); // Lấy 10 bài ngẫu nhiên
      setState(() {
        songs = fetchedSongs;

        // Tạo lượt nghe giả ngẫu nhiên cho từng bài hát
        _fakePlayCounts = List.generate(
          songs.length,
          (index) => _generateFakePlayCount(),
        );
      });

      // Kiểm tra trạng thái yêu thích cho từng bài hát
      int? userId = UserSession.currentUser?['id'];
      if (userId != null) {
        for (var song in songs) {
          bool isFavorite = await DatabaseHelper.instance
              .isSongInFavoriteAlbum(userId, song['id']);
          _isFavoriteMap[song['id']] = isFavorite;
        }
      }
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

  // Hàm tạo số lượt nghe giả ngẫu nhiên
  String _generateFakePlayCount() {
    int playCount =
        Random().nextInt(9900000) + 100000; // 100,000 đến 10,000,000
    return playCount.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  Future<void> _toggleFavorite(int songId) async {
    int? userId = UserSession.currentUser?['id'];
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Vui lòng đăng nhập để thêm bài hát vào yêu thích')),
      );
      return;
    }

    try {
      bool isFavorite = _isFavoriteMap[songId] ?? false;
      if (isFavorite) {
        await DatabaseHelper.instance
            .removeSongFromFavoriteAlbum(userId, songId);
        setState(() {
          _isFavoriteMap[songId] = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã xóa bài hát khỏi danh sách yêu thích')),
        );
      } else {
        await DatabaseHelper.instance.addSongToFavoriteAlbum(userId, songId);
        setState(() {
          _isFavoriteMap[songId] = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã thêm bài hát vào danh sách yêu thích')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi cập nhật danh sách yêu thích: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(18, 18, 18, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 320,
                      width: 320,
                      decoration: BoxDecoration(color: Colors.grey[800]),
                      child: Image.asset(
                        widget.categoryAvatar,
                        fit: BoxFit.cover,
                      ),
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
                            widget.categoryName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Thể loại nhạc',
                            style: TextStyle(color: Colors.grey),
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
                            if (songs.isNotEmpty) {
                              try {
                                await _audioManager
                                    .playSongById(songs.first['id']);
                                setState(() {});
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Lỗi khi phát bài hát: $e')),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('Không có bài hát nào để phát')),
                              );
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
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  songs.isEmpty
                      ? Center(
                          child: Text(
                            'Không có bài hát nào',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: songs.length,
                          itemBuilder: (context, index) {
                            final song = songs[index];
                            final isFavorite =
                                _isFavoriteMap[song['id']] ?? false;
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 5, right: 0, top: 8, bottom: 8),
                              child: Row(
                                children: [
                                  Text(
                                    "${index + 1}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  SizedBox(width: 15),
                                  Image.asset(
                                    song['avatar'] ??
                                        'assets/images/random.png',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        try {
                                          await _audioManager
                                              .playSongById(song['id']);
                                          setState(() {});
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Lỗi khi phát bài hát: $e')),
                                          );
                                        }
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            song['title'],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                          Text(
                                            _fakePlayCounts[index],
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      isFavorite
                                          ? Icons.remove_circle_outline
                                          : Icons.add_circle_outline,
                                      color: Colors.white,
                                    ),
                                    onPressed: () async {
                                      await _toggleFavorite(song['id']);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
    );
  }
}
