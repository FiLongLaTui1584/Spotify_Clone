import 'package:flutter/material.dart';
import 'package:test_do_an/component/create_playlist_sheet.dart';
import 'package:test_do_an/page/artist_info.dart';
import 'package:test_do_an/page/playlist_detail.dart';
import '/component/custom_music_bar.dart';
import '/component/custom_drawer_nav.dart';
import 'package:test_do_an/helper/user_session.dart'; // Import UserSession
import 'dart:io'; // Import để dùng File
import 'package:test_do_an/helper/database_helper.dart'; // Import DatabaseHelper

class ThuVien extends StatefulWidget {
  @override
  _ThuVienState createState() => _ThuVienState();
}

class _ThuVienState extends State<ThuVien> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isGridView = false;
  bool isPlaylistSelected = true; // Mặc định chọn "Danh sách phát"

  @override
  Widget build(BuildContext context) {
    // Lấy thông tin từ UserSession
    String userName = UserSession.currentUser?['name'] ?? 'Người dùng';
    String? avatarPath = UserSession.currentUser?['avatar'];
    int? userId = UserSession.currentUser?['id'];

    if (userId == null) {
      return Scaffold(
        backgroundColor: Color.fromRGBO(18, 18, 18, 1),
        body: Center(
          child: Text(
            'Không tìm thấy thông tin người dùng. Vui lòng đăng nhập lại.',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromRGBO(18, 18, 18, 1),
      drawer: NavigationWidget(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(userName, avatarPath),
          _buildCategoryButtons(),
          SizedBox(height: 20),
          isPlaylistSelected
              ? _buildAlbumList(userId)
              : _buildArtistList(userId),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: CustomMusicBar(),
      ),
    );
  }

  Widget _buildHeader(String userName, String? avatarPath) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 0, top: 56, bottom: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _scaffoldKey.currentState?.openDrawer(),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: avatarPath != null && avatarPath.isNotEmpty
                  ? FileImage(File(avatarPath))
                  : AssetImage('assets/images/avatar.png') as ImageProvider,
            ),
          ),
          const SizedBox(width: 15),
          Text(
            'Thư viện',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: false,
                backgroundColor: Colors.transparent,
                builder: (context) => CreatePlaylistSheet(),
              ).then((_) {
                setState(() {}); // Làm mới danh sách album
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isPlaylistSelected = false;
              });
            },
            child: _buildCategoryButton('Nghệ sĩ', !isPlaylistSelected),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              setState(() {
                isPlaylistSelected = true;
              });
            },
            child: _buildCategoryButton('Danh sách phát', isPlaylistSelected),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              setState(() {
                isGridView = !isGridView;
              });
            },
            child: Icon(
              isGridView ? Icons.list : Icons.grid_view,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String title, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      decoration: BoxDecoration(
        color: isSelected ? Colors.green : Colors.grey[800],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
      ),
    );
  }

  // Danh sách album bài hát
  Widget _buildAlbumList(int userId) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseHelper.instance.getUserAlbums(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Expanded(
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          print('Lỗi trong FutureBuilder: ${snapshot.error}');
          return Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Lỗi khi tải danh sách album: ${snapshot.error}',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {}); // Làm mới FutureBuilder
                    },
                    child: Text('Thử lại'),
                  ),
                ],
              ),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Expanded(
            child: Center(
              child: Text(
                'Bạn chưa có album nào',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          );
        }

        final albums = snapshot.data!;
        print('Danh sách album hiển thị: $albums');

        return Expanded(
          child: isGridView
              ? GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: albums.length,
                  itemBuilder: (context, index) {
                    return _buildGridAlbumItem(albums[index], context);
                  },
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  itemCount: albums.length,
                  itemBuilder: (context, index) {
                    return _buildListAlbumItem(albums[index], context);
                  },
                ),
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> _getUserAlbums(int userId) async {
    final db = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> albums = await db.query(
      'albums',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    // Sắp xếp để album "Yêu thích" (isDefault = 1) lên đầu
    albums.sort((a, b) {
      if (a['isDefault'] == 1) return -1;
      if (b['isDefault'] == 1) return 1;
      return a['name'].compareTo(b['name']);
    });

    return albums.map((album) {
      return {
        'id': album['id'],
        'name': album['name'],
        'image': 'assets/images/song_icon.png', // Hình ảnh mặc định
        'isDefault': album['isDefault'],
      };
    }).toList();
  }

  Widget _buildListAlbumItem(Map<String, dynamic> album, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaylistDetailPage(
              albumId: album['id'],
              albumName: album['name'],
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              child: Image.asset(
                album['image'],
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 15),
            Text(
              album['name'],
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Spacer(),
            Text(
              'Album',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridAlbumItem(Map<String, dynamic> album, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaylistDetailPage(
              albumId: album['id'],
              albumName: album['name'],
            ),
          ),
        );
      },
      child: Column(
        children: [
          ClipRRect(
            child: Image.asset(
              album['image'],
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            album['name'],
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            'Album',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }

  // Danh sách nghệ sĩ
  Widget _buildArtistList(int userId) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseHelper.instance.getFollowedArtists(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Expanded(
            child: Center(
              child: Text(
                'Lỗi khi tải danh sách nghệ sĩ: ${snapshot.error}',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Expanded(
            child: Center(
              child: Text(
                'Bạn chưa follow nghệ sĩ nào',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          );
        }

        final artists = snapshot.data!;

        return Expanded(
          child: isGridView
              ? GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: artists.length,
                  itemBuilder: (context, index) {
                    return _buildArtistGridItem({
                      'id': artists[index]['id'].toString(),
                      'name': artists[index]['name'],
                      'image': artists[index]['avatar'] ??
                          'assets/images/random.png',
                    });
                  },
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  itemCount: artists.length,
                  itemBuilder: (context, index) {
                    return _buildArtistItem({
                      'id': artists[index]['id'].toString(),
                      'name': artists[index]['name'],
                      'image': artists[index]['avatar'] ??
                          'assets/images/random.png',
                    });
                  },
                ),
        );
      },
    );
  }

  Widget _buildArtistItem(Map<String, String> artist) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArtistInfoPage(
              artistId: int.parse(artist['id']!),
              artistName: artist['name']!,
              artistAvatar: artist['image']!,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage(artist['image']!),
            ),
            const SizedBox(width: 15),
            Text(
              artist['name']!,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Spacer(),
            Text(
              'Nghệ sĩ',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArtistGridItem(Map<String, String> artist) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArtistInfoPage(
              artistId: int.parse(artist['id']!),
              artistName: artist['name']!,
              artistAvatar: artist['image']!,
            ),
          ),
        );
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage(artist['image']!),
          ),
          const SizedBox(height: 8),
          Text(
            artist['name']!,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            'Nghệ sĩ',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }
}
