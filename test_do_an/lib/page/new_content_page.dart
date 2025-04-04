import 'package:flutter/material.dart';
import 'package:test_do_an/helper/audio_player_manager.dart';
import 'package:test_do_an/helper/database_helper.dart';
import 'package:test_do_an/helper/user_session.dart';
import 'dart:math'; // Để chọn ngẫu nhiên thời gian

class NewContentPage extends StatefulWidget {
  @override
  _NewContentPageState createState() => _NewContentPageState();
}

class _NewContentPageState extends State<NewContentPage> {
  final AudioPlayerManager _audioManager = AudioPlayerManager();
  List<Map<String, dynamic>> songs = [];
  bool _isLoading = false;
  Map<int, bool> _isFavoriteMap = {}; // Lưu trạng thái yêu thích của từng bài hát

  // Danh sách thời gian phát hành giả
  final List<Map<String, dynamic>> fakeTimes = [
    {'text': 'Hôm nay', 'days': 0},
    {'text': '1 ngày trước', 'days': 1},
    {'text': '2 ngày trước', 'days': 2},
    {'text': '3 ngày trước', 'days': 3},
    {'text': '4 ngày trước', 'days': 4},
    {'text': '5 ngày trước', 'days': 5},
    {'text': '6 ngày trước', 'days': 6},
    {'text': '7 ngày trước', 'days': 7},
  ];

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
      // Lấy tất cả bài hát từ cơ sở dữ liệu
      final fetchedSongs = await DatabaseHelper.instance.getAllSongs();

      // Gán thời gian phát hành giả và sắp xếp
      List<Map<String, dynamic>> songsWithTime = fetchedSongs.map((song) {
        // Chọn ngẫu nhiên một thời gian từ fakeTimes
        final randomTime = fakeTimes[Random().nextInt(fakeTimes.length)];
        return {
          ...song,
          'time': randomTime['text'],
          'days': randomTime['days'], // Để sắp xếp
        };
      }).toList();

      // Sắp xếp theo số ngày (gần đây nhất lên đầu)
      songsWithTime.sort((a, b) => a['days'].compareTo(b['days']));

      setState(() {
        songs = songsWithTime;
      });

      // Kiểm tra trạng thái yêu thích cho từng bài hát
      int? userId = UserSession.currentUser?['id'];
      if (userId != null) {
        for (var song in songs) {
          bool isFavorite = await DatabaseHelper.instance.isSongInFavoriteAlbum(userId, song['id']);
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

  Future<void> _toggleFavorite(int songId) async {
    int? userId = UserSession.currentUser?['id'];
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng đăng nhập để thêm bài hát vào yêu thích')),
      );
      return;
    }

    try {
      bool isFavorite = _isFavoriteMap[songId] ?? false;
      if (isFavorite) {
        // Xóa khỏi danh sách yêu thích
        await DatabaseHelper.instance.removeSongFromFavoriteAlbum(userId, songId);
        setState(() {
          _isFavoriteMap[songId] = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã xóa bài hát khỏi danh sách yêu thích')),
        );
      } else {
        // Thêm vào danh sách yêu thích
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
        backgroundColor: Color.fromRGBO(18, 18, 18, 1),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Có gì mới",
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Nội dung phát hành mới nhất từ nghệ sĩ bạn theo dõi.",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            SizedBox(height: 16),
            Text(
              "Mới",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : songs.isEmpty
                      ? Center(
                          child: Text(
                            'Không có bài hát nào',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : ListView.builder(
                          itemCount: songs.length,
                          itemBuilder: (context, index) {
                            final song = songs[index];
                            return _buildSongItem(song);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSongItem(Map<String, dynamic> song) {
    final isFavorite = _isFavoriteMap[song['id']] ?? false;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              song['avatar'] ?? 'assets/images/random.png',
              width: 60,
              height: 60,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song['time']!,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  song['title']!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  song['artist']!,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              isFavorite ? Icons.remove_circle_outline : Icons.add_circle_outline,
              color: Colors.white,
            ),
            onPressed: () async {
              await _toggleFavorite(song['id']);
            },
          ),
          IconButton(
            icon: Icon(Icons.play_circle_fill, color: Colors.white, size: 30),
            onPressed: () async {
              try {
                await _audioManager.playSongById(song['id']);
                setState(() {}); // Cập nhật UI nếu cần
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Lỗi khi phát bài hát: $e')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}