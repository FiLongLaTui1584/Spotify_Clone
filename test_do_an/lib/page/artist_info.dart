import 'package:flutter/material.dart';
import 'package:test_do_an/page/artist_album.dart';

class ArtistInfoPage extends StatelessWidget {
  final List<Map<String, dynamic>> popularSongs = [
    {
      'title': 'Faded',
      'plays': '2.120.730.968',
      'image': 'assets/images/random.png'
    },
    {
      'title': 'On My Way',
      'plays': '758.453.007',
      'image': 'assets/images/random.png'
    },
    {
      'title': 'Faded',
      'plays': '2.120.730.968',
      'image': 'assets/images/random.png'
    },
    {
      'title': 'On My Way',
      'plays': '758.453.007',
      'image': 'assets/images/random.png'
    },
    {
      'title': 'On My Way',
      'plays': '758.453.007',
      'image': 'assets/images/random.png'
    },
  ];

  final List<Map<String, dynamic>> albums = [
    {
      'title': 'Forever Young',
      'description': 'Phát hành mới nhất - Đĩa đơn',
      'image': 'assets/images/random.png'
    },
    {
      'title': 'Different World',
      'description': '2018 - Album',
      'image': 'assets/images/random.png'
    },
    {
      'title': 'Forever Young',
      'description': 'Phát hành mới nhất - Đĩa đơn',
      'image': 'assets/images/random.png'
    },
    {
      'title': 'Different World',
      'description': '2018 - Album',
      'image': 'assets/images/random.png'
    },
    {
      'title': 'Forever Young',
      'description': 'Phát hành mới nhất - Đĩa đơn',
      'image': 'assets/images/random.png'
    },
  ];

  final List<Map<String, dynamic>> featuredPlaylists = [
    {
      'title': 'This is Alan Walker',
      'description': 'Các bài nhạc tiêu biểu...',
      'image': 'assets/images/random.png'
    },
    {
      'title': 'Alan Walker Radio',
      'description': 'Với Ava Max, Marshmello...',
      'image': 'assets/images/random.png'
    },
    {
      'title': 'This is Alan Walker',
      'description': 'Các bài nhạc tiêu biểu...',
      'image': 'assets/images/random.png'
    },
    {
      'title': 'Alan Walker Radio',
      'description': 'Với Ava Max, Marshmello...',
      'image': 'assets/images/random.png'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(18, 18, 18, 1),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildArtistInfo(),
                  SizedBox(height: 35),
                  _buildSectionTitle('Phổ biến'),
                  _buildSongList(),
                  _buildSeeAllButton(),
                  SizedBox(height: 5),
                  _buildSectionTitle('Album bài hát'),
                  _buildAlbumList(),
                  _buildSeeAllButton(),
                  SizedBox(height: 15),
                  _buildSectionTitle('Có sự tham gia của Alan Walker'),
                  SizedBox(height: 10),
                  _buildFeaturedPlaylists(context),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Header chứa ảnh và nút back
  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        Image.asset('assets/images/random.png',
            fit: BoxFit.cover, width: double.infinity, height: 400),
        Positioned(
          top: 40,
          left: 10,
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
    );
  }

  /// Thông tin nghệ sĩ
  Widget _buildArtistInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Alan Walker',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 15),
                _buildFollowButton(),
              ],
            ),
            Text('26,1 Tr người nghe hàng tháng',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
        CircleAvatar(
          backgroundColor: Colors.green,
          radius: 25,
          child: Icon(Icons.play_arrow, color: Colors.black, size: 35),
        ),
      ],
    );
  }

  /// Nút "Đang theo dõi"
  Widget _buildFollowButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(18, 18, 18, 1),
        side: BorderSide(color: Colors.white, width: 1),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        minimumSize: Size(80, 30),
      ),
      child: Text('Đang theo dõi',
          style: TextStyle(color: Colors.white, fontSize: 10)),
    );
  }

  /// Tiêu đề của từng section
  Widget _buildSectionTitle(String title) {
    return Text(title,
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold));
  }

  /// Danh sách bài hát phổ biến
  Widget _buildSongList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: popularSongs.length,
      itemBuilder: (context, index) {
        final song = popularSongs[index];
        return _buildListTile(
            index, song['image'], song['title'], song['plays']);
      },
    );
  }

  /// Danh sách album
  Widget _buildAlbumList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: albums.length,
      itemBuilder: (context, index) {
        final album = albums[index];
        return _buildListTile(
            index, album['image'], album['title'], album['description']);
      },
    );
  }

  /// Tạo một ListTile có số thứ tự
  Widget _buildListTile(
      int index, String? image, String? title, String? subtitle) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${index + 1}',
              style: TextStyle(color: Colors.white, fontSize: 16)),
          SizedBox(width: 15),
          Image.asset(image!, width: 50, height: 50, fit: BoxFit.cover),
        ],
      ),
      title: Text(title!, style: TextStyle(color: Colors.white)),
      subtitle: Text(subtitle!, style: TextStyle(color: Colors.grey)),
      trailing: Icon(Icons.more_horiz, color: Colors.white),
    );
  }

  /// Nút "Xem tất cả"
  Widget _buildSeeAllButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromRGBO(18, 18, 18, 1),
          side: BorderSide(color: Colors.white, width: 1),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        ),
        child: Text('Xem tất cả',
            style: TextStyle(color: Colors.white, fontSize: 13)),
      ),
    );
  }

  /// Danh sách playlist có sự tham gia của Alan Walker
  Widget _buildFeaturedPlaylists(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: featuredPlaylists.map((playlist) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Artist_Album_Detail_Page(),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.only(right: 20),
              width: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(playlist['image']!,
                      width: 150, height: 150, fit: BoxFit.cover),
                  SizedBox(height: 5),
                  Text(playlist['title']!,
                      style: TextStyle(color: Colors.white)),
                  Text(playlist['description']!,
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
