import 'package:flutter/material.dart';
import '../component/tim_kiem_gan_day.dart';
import '/component/custom_music_bar.dart';
import '/component/custom_drawer_nav.dart';
import 'package:test_do_an/helper/user_session.dart'; // Import UserSession
import 'dart:io'; // Import để dùng File

class TimKiem extends StatefulWidget {
  @override
  _TimKiemState createState() => _TimKiemState();
}

class _TimKiemState extends State<TimKiem> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
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
            _buildSeeAllButton(),
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
    final List<Map<String, String>> songs = [
      {
        'rank': '1',
        'image': 'assets/images/random.png',
        'title': 'Die With A Smile - Lady Gaga, Bruno Mars',
        'plays': '1.947.313.698'
      },
      {
        'rank': '2',
        'image': 'assets/images/random.png',
        'title': 'APT. - ROSÉ, Bruno Mars',
        'plays': '1.229.115.451'
      },
      {
        'rank': '3',
        'image': 'assets/images/random.png',
        'title': 'CHĂM HOA - MONO',
        'plays': '24.533.269'
      },
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
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Column(
            children: songs.map((song) => _buildSongItem(song)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSongItem(Map<String, String> song) {
    return Padding(
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
    );
  }

  Widget _buildSeeAllButton() {
    return Center(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        onPressed: () {},
        child: const Text('Xem tất cả', style: TextStyle(color: Colors.white)),
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
