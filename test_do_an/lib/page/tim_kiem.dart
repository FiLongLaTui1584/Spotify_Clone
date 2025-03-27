import 'package:flutter/material.dart';
import '../component/tim_kiem_gan_day.dart';
import '/component/custom_music_bar.dart';
import '/component/custom_drawer_nav.dart';
import 'package:test_do_an/helper/user_session.dart'; // Import UserSession
import 'package:test_do_an/helper/database_helper.dart'; // Import DatabaseHelper
import 'package:test_do_an/helper/audio_player_manager.dart'; // Import AudioPlayerManager
import 'dart:io'; // Import để dùng File

class TimKiem extends StatefulWidget {
  @override
  _TimKiemState createState() => _TimKiemState();
}

class _TimKiemState extends State<TimKiem> with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // Sử dụng instance Singleton của AudioPlayerManager
  final AudioPlayerManager _audioManager = AudioPlayerManager();

  @override
  bool get wantKeepAlive => true; // Giữ trạng thái của widget

  @override
  Widget build(BuildContext context) {
    super.build(context); // Gọi super.build để AutomaticKeepAliveClientMixin hoạt động

    // Lấy thông tin từ UserSession
    String userName = UserSession.currentUser?['name'] ??
        'Người dùng'; // Tên mặc định nếu null
    String? avatarPath = UserSession.currentUser?['avatar']; // Đường dẫn avatar

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
            margin: EdgeInsets.only(left: 15), // Đẩy avatar sang phải
            child: CircleAvatar(
              radius: 25,
              backgroundImage: avatarPath != null && avatarPath.isNotEmpty
                  ? FileImage(File(avatarPath)) // Avatar từ đường dẫn cục bộ
                  : AssetImage('assets/images/avatar.png')
                      as ImageProvider, // Avatar mặc định
            ),
          ),
        ),
        title: Text(
          'Tìm kiếm',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Arial',
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildSearchBar(),
            const SizedBox(height: 20),
            _buildTrendingSongs(),
            const SizedBox(height: 20),
            _buildSongCategories(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: CustomMusicBar(),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(_createFadeRoute());
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.black),
              const SizedBox(width: 10),
              const Text(
                'Bạn muốn nghe gì?',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Hiệu ứng chuyển fade in
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

  Widget _buildTrendingSongs() {
    // Danh sách lượt nghe giả giảm dần (cập nhật cho 5 bài hát)
    final List<String> fakePlays = [
      '1,947,313,698', // Lớn nhất
      '1,229,115,451',
      '524,533,269',
      '324,123,456',
      '124,987,654',   // Nhỏ nhất
    ];

    return Padding(
      padding: const EdgeInsets.only(
        left: 15.0,
        right: 15.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Những bài hát xu hướng',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: DatabaseHelper.instance.getRandomSongs(), // Sử dụng getRandomSongs để lấy 5 bài ngẫu nhiên
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
              return Column(
                children: songs.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, dynamic> song = entry.value;
                  return _buildSongItem(
                    {
                      'rank': '${index + 1}',
                      'image': song['avatar'] ?? 'assets/images/random.png',
                      'title': song['title'],
                      'plays': fakePlays[index], // Gán lượt nghe giả theo thứ tự giảm dần
                    },
                    song['id'], // Truyền id của bài hát
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSongItem(Map<String, String> song, int songId) {
    return GestureDetector(
      onTap: () async {
        // Phát bài hát khi nhấn, truyền id của bài hát
        await _audioManager.playSongById(songId);
        setState(() {}); // Cập nhật UI nếu cần
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Text(song['rank']!,
                style: const TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(width: 10),
            Image.asset(song['image']!, width: 50, height: 50),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(song['title']!,
                      style: const TextStyle(color: Colors.white, fontSize: 16)),
                  Text(song['plays']!,
                      style: const TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              ),
            ),
            Icon(Icons.more_vert, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildSongCategories() {
    final List<Map<String, dynamic>> categories = [
      {
        'title': 'Hip-hop',
        'image': 'assets/images/random.png',
        'color': Colors.brown
      },
      {
        'title': 'V-Pop',
        'image': 'assets/images/random.png',
        'color': Colors.blueGrey
      },
      {
        'title': 'K-Pop',
        'image': 'assets/images/random.png',
        'color': Colors.purple
      },
      {
        'title': 'US-UK',
        'image': 'assets/images/random.png',
        'color': Colors.grey
      },
      {
        'title': 'Rock',
        'image': 'assets/images/random.png',
        'color': Colors.red
      },
      {
        'title': 'Jazz',
        'image': 'assets/images/random.png',
        'color': Colors.orange
      },
      {
        'title': 'EDM',
        'image': 'assets/images/random.png',
        'color': Colors.teal
      },
      {
        'title': 'Classical',
        'image': 'assets/images/random.png',
        'color': Colors.indigo
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Các chủ đề bài hát',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15),
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true, // Để tránh lỗi cuộn vô hạn
            physics:
                const NeverScrollableScrollPhysics(), // Không cuộn riêng lẻ
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 cột
              crossAxisSpacing: 15, // Khoảng cách giữa các ô ngang
              mainAxisSpacing: 15, // Khoảng cách giữa các ô dọc
              childAspectRatio: 2, // Điều chỉnh tỷ lệ ngang/dọc
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return _buildCategoryItem(categories[index]);
            },
          ),
          SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }

  Widget _buildCategoryItem(Map<String, dynamic> category) {
    return Container(
      decoration: BoxDecoration(
        color: category['color'],
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            category['title'],
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Transform.rotate(
            angle: 0.5236, // 30 độ = 0.5236 radian
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(5), // Điều chỉnh độ bo tròn tại đây
              child: Image.asset(
                category['image'],
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}