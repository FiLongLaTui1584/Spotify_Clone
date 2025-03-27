import 'package:flutter/material.dart';
import 'package:test_do_an/helper/database_helper.dart'; // Import DatabaseHelper
import 'package:test_do_an/helper/audio_player_manager.dart'; // Import AudioPlayerManager

class TimKiemGanDay extends StatefulWidget {
  @override
  _TimKiemGanDayState createState() => _TimKiemGanDayState();
}

class _TimKiemGanDayState extends State<TimKiemGanDay> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  final AudioPlayerManager _audioManager = AudioPlayerManager();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() async {
    String keyword = _searchController.text.trim();
    if (keyword.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    // Tìm kiếm bài hát theo từ khóa
    List<Map<String, dynamic>> results =
        await DatabaseHelper.instance.searchSongsByTitle(keyword);
    setState(() {
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(18, 18, 18, 1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60), // Khoảng cách với phía trên
          _buildSearchBar(context),
          Padding(
            padding: const EdgeInsets.only(
              left: 15.0,
              right: 15.0,
              top: 20.0,
              bottom: 10.0,
            ),
            child: Text(
              _searchController.text.isEmpty
                  ? 'Nội dung gần đây'
                  : 'Kết quả tìm kiếm',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Hiển thị danh sách
          Expanded(
            child: _searchController.text.isEmpty
                ? FutureBuilder<List<Map<String, dynamic>>>(
                    future: DatabaseHelper.instance.getRandomSongs(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Lỗi khi tải bài hát: ${snapshot.error}',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(
                            'Không có bài hát nào',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      final songs = snapshot.data!;
                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: songs.length,
                        itemBuilder: (context, index) {
                          final song = songs[index];
                          return ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 15),
                            leading: CircleAvatar(
                              backgroundImage: song['avatar'] != null
                                  ? AssetImage(song['avatar'])
                                  : AssetImage('assets/images/random.png')
                                      as ImageProvider,
                            ),
                            title: Text(
                              song['title'],
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              'Bài hát - ${song['artist']}',
                              style: TextStyle(color: Colors.grey),
                            ),
                            onTap: () async {
                              // Phát bài hát khi nhấn
                              await _audioManager.playSongById(song['id']);
                              setState(() {}); // Cập nhật UI nếu cần
                            },
                          );
                        },
                      );
                    },
                  )
                : _searchResults.isEmpty
                    ? Center(
                        child: Text(
                          'Không tìm thấy bài hát nào',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final song = _searchResults[index];
                          return ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 15),
                            leading: CircleAvatar(
                              backgroundImage: song['avatar'] != null
                                  ? AssetImage(song['avatar'])
                                  : AssetImage('assets/images/random.png')
                                      as ImageProvider,
                            ),
                            title: Text(
                              song['title'],
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              'Bài hát - ${song['artist']}',
                              style: TextStyle(color: Colors.grey),
                            ),
                            onTap: () async {
                              // Phát bài hát khi nhấn
                              await _audioManager.playSongById(song['id']);
                              setState(() {}); // Cập nhật UI nếu cần
                            },
                          );
                        },
                      ),
          ),
          const SizedBox(height: 200),
        ],
      ),
    );
  }

  // Hàm SearchBar
  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 10),
                  const Icon(Icons.search, color: Colors.grey, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Bạn muốn nghe gì?',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Text(
              'Hủy',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  // Hiệu ứng chuyển cảnh mờ dần (Fade)
  Route _createFadeRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => TimKiemGanDay(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}