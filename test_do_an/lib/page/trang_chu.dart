import 'package:flutter/material.dart';
import '/component/custom_music_bar.dart';
import '/component/custom_drawer_nav.dart';
import 'package:test_do_an/helper/user_session.dart'; // Import UserSession
import 'dart:io'; // Import để dùng File

class TrangChu extends StatefulWidget {
  @override
  _TrangChuState createState() => _TrangChuState();
}

class _TrangChuState extends State<TrangChu> {
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
        backgroundColor: Color.fromRGBO(18, 18, 18, 1), // Màu nền AppBar
        leading: GestureDetector(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Container(
            margin: EdgeInsets.only(left: 15), // Đẩy ảnh sang phải 10px
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
          'Xin chào, $userName!', // Hiển thị tên thật
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
      child: GridView.builder(
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2.8,
        ),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 8,
        itemBuilder: (context, index) {
          return _buildGridItem(
              'Ai cũng phải bắt đầu từ đâu đó', 'assets/images/random.png');
        },
      ),
    );
  }

  Widget _build_3_album() {
    List<Map<String, String>> artistAlbums = [
      {
        'title': 'Tuyển tập của HIEUTHUHAI',
        'imagePath': 'assets/images/random.png'
      },
      {
        'title': 'Tuyển tập của JungKook',
        'imagePath': 'assets/images/random.png'
      },
      {'title': 'Tuyển tập của Obito', 'imagePath': 'assets/images/random.png'},
      {'title': 'Tuyển tập của MCK', 'imagePath': 'assets/images/random.png'},
    ];

    List<Map<String, String>> recentAlbums = List.from(artistAlbums);
    List<Map<String, String>> popularAlbums = List.from(artistAlbums);

    return Column(
      children: [
        _buildSectionAlbums('Nghệ sĩ bạn thích', artistAlbums),
        _buildSectionAlbums('Gần đây', recentAlbums),
        _buildSectionAlbums('Được đánh giá nhất', popularAlbums),
      ],
    );
  }

////////////////////////////////////////////////////////////////////////////////////

//Item thẻ
  Widget _buildGridItem(String title, String imagePath) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF292929),
        borderRadius: BorderRadius.circular(5),
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
    );
  }

//Hàng Album
  Widget _buildSectionAlbums(String title, List<Map<String, String>> albums) {
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: albums
                  .map((album) =>
                      _buildAlbumCard(album['title']!, album['imagePath']!))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

//Item Album
  Widget _buildAlbumCard(String title, String imagePath) {
    return Padding(
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
              colors: [Colors.black.withOpacity(0.6), Colors.transparent],
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
    );
  }
}
