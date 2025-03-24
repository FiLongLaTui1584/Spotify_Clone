import 'package:flutter/material.dart';
import '/component/custom_music_bar.dart';
import '/component/custom_drawer_nav.dart';
import 'package:test_do_an/helper/user_session.dart';
import 'dart:io';

class TrangChu extends StatefulWidget {
  @override
  _TrangChuState createState() => _TrangChuState();
}

class _TrangChuState extends State<TrangChu> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
    // Danh sách 8 bài hát mẫu với tiêu đề và hình ảnh khác nhau
    List<Map<String, String>> songs = [
      {
        'title': 'NOLOVENOLIFE',
        'image': 'assets/song_avatars/NOLOVENOLIFE-HIEUTHUHAI.png'
      },
      {
        'title': 'We dont talk any more',
        'image': 'assets/song_avatars/We Dont Talk Anymore - Charlie Puth.png'
      },
      {
        'title': 'APT',
        'image': 'assets/song_avatars/APT - ROSÉ, Bruno Mars.png'
      },
      {
        'title': 'Chúng ta của hiện tại',
        'image': 'assets/song_avatars/Chúng ta của hiện tại - Sơn Tùng MTP.png'
      },
      {
        'title': 'Chúng ta của tương lai',
        'image': 'assets/song_avatars/Chúng ta của tương lai - Sơn Tùng MTP.png'
      },
      {
        'title': 'Die With A Smile',
        'image': 'assets/song_avatars/Die With A Smile - Brunor Mars.png'
      },
      {
        'title': 'Hẹn gặp em dưới ánh trăng',
        'image':
            'assets/song_avatars/Hẹn gặp em dưới ánh trăng - HIEUTHUHAI.png'
      },
      {
        'title': 'Ngủ một mình',
        'image': 'assets/song_avatars/Ngủ một mình - HIEUTHUHAI.png'
      },
    ];

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
        itemCount: songs.length, // 8 bài hát
        itemBuilder: (context, index) {
          return _buildGridItem(songs[index]['title']!, songs[index]['image']!);
        },
      ),
    );
  }

  Widget _build_3_album() {
    // Danh sách cho "Nghệ sĩ bạn thích"
    List<Map<String, String>> favoriteArtists = [
      {
        'title': 'Tuyển tập của HIEUTHUHAI',
        'imagePath': 'assets/album_avatars/HIEUTHUHAI - album - P2.png'
      },
      {
        'title': 'Tuyển tập của JungKook',
        'imagePath': 'assets/album_avatars/Jungkook - album - P2.png'
      },
      {
        'title': 'Tuyển tập của Obito',
        'imagePath': 'assets/album_avatars/Obito - album - P2.png'
      },
      {
        'title': 'Tuyển tập của MCK',
        'imagePath': 'assets/album_avatars/MCK - album - P2.png'
      },
    ];

    // Danh sách cho "Gần đây"
    List<Map<String, String>> recentSongs = [
      {
        'title': 'Tuyển tập của MCK',
        'imagePath': 'assets/album_avatars/MCK - album - P2.png'
      },
      {
        'title': 'Tuyển tập của Obito',
        'imagePath': 'assets/album_avatars/Obito - album - P2.png'
      },
      {
        'title': 'Tuyển tập của JungKook',
        'imagePath': 'assets/album_avatars/Jungkook - album - P2.png'
      },
      {
        'title': 'Tuyển tập của HIEUTHUHAI',
        'imagePath': 'assets/album_avatars/HIEUTHUHAI - album - P2.png'
      },
    ];

    // Danh sách cho "Được đánh giá nhất"
    List<Map<String, String>> topRated = [
      {
        'title': 'Top 1',
        'imagePath': 'assets/album_avatars/Sơn Tùng MTP - album.png'
      },
      {
        'title': 'Top 2',
        'imagePath': 'assets/album_avatars/Charlie Puth - album.png'
      },
      {
        'title': 'Top 3',
        'imagePath': 'assets/album_avatars/Bruno Mars - album.png'
      },
      {
        'title': 'Top 4',
        'imagePath': 'assets/album_avatars/HIEUTHUHAI - album.png'
      },
    ];

    return Column(
      children: [
        _buildSectionAlbums('Nghệ sĩ bạn thích', favoriteArtists),
        _buildSectionAlbums('Gần đây', recentSongs),
        _buildSectionAlbums('Được đánh giá nhất', topRated),
      ],
    );
  }

  //Item thẻ
  Widget _buildGridItem(String title, String imagePath) {
    return Container(
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
              topLeft: Radius.circular(10), // Bo tròn góc trái trên
              bottomLeft: Radius.circular(10), // Bo tròn góc trái dưới
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
    );
  }
}
