import 'package:flutter/material.dart';
import 'package:test_do_an/helper/user_session.dart';
import 'package:test_do_an/page/settings_page.dart';
import 'package:test_do_an/component/edit_profile.dart';
import '/component/custom_music_bar.dart';
import '/component/custom_drawer_nav.dart';
import 'dart:io'; // Import để dùng File
import 'package:test_do_an/helper/database_helper.dart'; // Import DatabaseHelper

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int followedArtistsCount = 0; // Biến để lưu số lượng nghệ sĩ đang theo dõi

  @override
  void initState() {
    super.initState();
    _loadFollowedArtistsCount();
  }

  Future<void> _loadFollowedArtistsCount() async {
    int? userId = UserSession.currentUser?['id'];
    if (userId != null) {
      int count = await DatabaseHelper.instance.getFollowedArtistsCount(userId);
      setState(() {
        followedArtistsCount = count;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromRGBO(18, 18, 18, 1),
      drawer: NavigationWidget(),
      body: Column(
        children: [
          _buildSetting(),
          _buildHeader(),
          const SizedBox(height: 20),
          _buildEditAndShareButtons(),
          const SizedBox(height: 20),
          _buildActivity(),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomMusicBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildSetting() {
    return Padding(
      padding: const EdgeInsets.only(top: 60, right: 15),
      child: Align(
        alignment: Alignment.centerRight,
        child: IconButton(
          icon: Icon(Icons.settings, color: Colors.white, size: 28),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    String userName =
        UserSession.currentUser?['name'] ?? 'Người dùng'; // Lấy tên từ database
    String? avatarPath =
        UserSession.currentUser?['avatar']; // Lấy avatar từ database

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: avatarPath != null && avatarPath.isNotEmpty
                ? FileImage(File(avatarPath)) // Sử dụng File từ dart:io
                : AssetImage('assets/images/avatar.png') as ImageProvider,
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName, // Hiển thị tên thật
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Đang theo dõi $followedArtistsCount', // Hiển thị số lượng thực tế
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditAndShareButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.white),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => EditProfilePage(
                  onProfileUpdated: () {
                    setState(() {}); // Cập nhật giao diện sau khi chỉnh sửa
                  },
                ),
              );
            },
            child: Text('Chỉnh sửa', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildActivity() {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Column(
        children: [
          Text(
            'Không có hoạt động gần đây.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Hãy khám phá thêm nhạc mới ngay',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
