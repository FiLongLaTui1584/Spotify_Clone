import 'package:flutter/material.dart';
import 'package:test_do_an/helper/database_helper.dart';
import 'package:test_do_an/page/artist_album.dart';

class ArtistInfoPage extends StatelessWidget {
  final int artistId;
  final String artistName;
  final String artistAvatar;

  const ArtistInfoPage({
    Key? key,
    required this.artistId,
    required this.artistName,
    required this.artistAvatar,
  }) : super(key: key);

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
                  SizedBox(height: 15),
                  _buildSectionTitle('Có sự tham gia của $artistName'),
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
        Image.asset(
          artistAvatar,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 400,
        ),
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
                  artistName,
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
            Text(
              '26,1 Tr người nghe hàng tháng',
              style: TextStyle(color: Colors.grey),
            ),
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
      child: Text(
        'Đang theo dõi',
        style: TextStyle(color: Colors.white, fontSize: 10),
      ),
    );
  }

  /// Tiêu đề của từng section
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// Danh sách bài hát phổ biến
  Widget _buildSongList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseHelper.instance.getSongsByArtist(artistId),
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
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: songs.length,
          itemBuilder: (context, index) {
            final song = songs[index];
            return _buildListTile(
              index,
              song['avatar'] ?? 'assets/images/random.png',
              song['title'],
              '2,120,730,968', // Lượt nghe giả
            );
          },
        );
      },
    );
  }

  /// Tạo một ListTile có số thứ tự
  Widget _buildListTile(int index, String? image, String? title, String? subtitle) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${index + 1}',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(width: 15),
          Image.asset(
            image!,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ],
      ),
      title: Text(
        title!,
        style: TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        subtitle!,
        style: TextStyle(color: Colors.grey),
      ),
      trailing: Icon(Icons.more_horiz, color: Colors.white),
    );
  }

  /// Danh sách album từ artist_albums
  Widget _buildFeaturedPlaylists(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseHelper.instance.getArtistAlbums(artistId),
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
                      Image.asset(
                        album['avatar'] ?? 'assets/images/random.png',
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 5),
                      Text(
                        album['name']!,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}