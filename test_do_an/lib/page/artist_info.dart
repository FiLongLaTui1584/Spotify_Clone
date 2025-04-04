import 'package:flutter/material.dart';
import 'package:test_do_an/helper/audio_player_manager.dart';
import 'package:test_do_an/helper/database_helper.dart';
import 'package:test_do_an/helper/user_session.dart';
import 'package:test_do_an/page/artist_album.dart';

class ArtistInfoPage extends StatefulWidget {
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
  _ArtistInfoPageState createState() => _ArtistInfoPageState();
}

class _ArtistInfoPageState extends State<ArtistInfoPage> {
  bool _isFollowing = false;
  final AudioPlayerManager _audioManager = AudioPlayerManager();

  // Danh sách lượt nghe giả
  final List<String> fakePlays = [
    '2,947,313,698', // Lớn nhất
    '1,829,115,451',
    '1,524,533,269',
    '924,123,456',
    '624,987,654',
    '324,456,789',
    '224,123,654',
    '124,789,321',
    '94,567,890',
    '54,321,987', // Nhỏ nhất
  ];

  @override
  void initState() {
    super.initState();
    _checkIfFollowing();
  }

  Future<void> _checkIfFollowing() async {
    int? userId = UserSession.currentUser?['id'];
    if (userId == null) return;

    bool isFollowing = await DatabaseHelper.instance.isFollowingArtist(
      userId,
      widget.artistId,
    );
    setState(() {
      _isFollowing = isFollowing;
    });
  }

  Future<void> _toggleFollow() async {
    int? userId = UserSession.currentUser?['id'];
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng đăng nhập để theo dõi nghệ sĩ')),
      );
      return;
    }

    if (_isFollowing) {
      await DatabaseHelper.instance.unfollowArtist(userId, widget.artistId);
      setState(() {
        _isFollowing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã bỏ theo dõi ${widget.artistName}')),
      );
    } else {
      await DatabaseHelper.instance.followArtist(userId, widget.artistId);
      setState(() {
        _isFollowing = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã theo dõi ${widget.artistName}')),
      );
    }
  }

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
                  _buildSectionTitle('Có sự tham gia của ${widget.artistName}'),
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
          widget.artistAvatar,
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
                  widget.artistName,
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
          child: IconButton(
            icon: Icon(Icons.play_arrow, color: Colors.black, size: 35),
            onPressed: () async {
              List<Map<String, dynamic>> songs = await DatabaseHelper.instance
                  .getSongsByArtist(widget.artistId);
              if (songs.isNotEmpty) {
                await _audioManager.playSongById(songs.first['id']);
                setState(() {}); // Cập nhật UI nếu cần
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Không có bài hát nào để phát')),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  /// Nút "Theo dõi" hoặc "Đang theo dõi"
  Widget _buildFollowButton() {
    return ElevatedButton(
      onPressed: _toggleFollow,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            _isFollowing ? Color.fromRGBO(18, 18, 18, 1) : Colors.white,
        side: _isFollowing ? BorderSide(color: Colors.white, width: 1) : null,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        minimumSize: Size(80, 30),
      ),
      child: Text(
        _isFollowing ? 'Đang theo dõi' : 'Theo dõi',
        style: TextStyle(
          color: _isFollowing ? Colors.white : Colors.black,
          fontSize: 10,
        ),
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
      future: DatabaseHelper.instance.getSongsByArtist(widget.artistId),
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
            // Gán lượt nghe giả theo chỉ số, nếu vượt quá độ dài fakePlays thì lặp lại
            String fakePlay = fakePlays[index % fakePlays.length];
            return _buildListTile(
              index,
              song['avatar'] ?? 'assets/images/random.png',
              song['title'],
              fakePlay, // Sử dụng lượt nghe giả
              song['id'],
            );
          },
        );
      },
    );
  }

  /// Tạo một ListTile có số thứ tự
  Widget _buildListTile(
      int index, String? image, String? title, String? subtitle, int songId) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: () async {
        // Phát bài hát khi nhấn, truyền id của bài hát
        try {
          await _audioManager.playSongById(songId);
          setState(() {}); // Cập nhật UI nếu cần
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi khi phát bài hát: $e')),
          );
        }
      },
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
      future: DatabaseHelper.instance.getArtistAlbums(widget.artistId),
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
                      builder: (context) => Artist_Album_Detail_Page(
                        artistId: widget.artistId,
                        artistName: widget.artistName,
                        artistAvatar: widget.artistAvatar,
                        albumName: album['name'],
                        albumAvatar:
                            album['avatar'] ?? 'assets/images/random.png',
                      ),
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
