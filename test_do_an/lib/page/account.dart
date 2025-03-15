import 'package:flutter/material.dart';
import '/component/custom_music_bar.dart';
import '/component/custom_drawer_nav.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
          onPressed: () {},
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15.0,
        right: 15.0,
        top: 0.0,
        bottom: 0.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage('assets/images/avatar.png'),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FiLongLàTui',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '0 người theo dõi - Đang theo dõi 37',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditAndShareButtons() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 15.0,
        top: 0.0,
        bottom: 0.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.white),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: () {},
            child: Text('Chỉnh sửa', style: TextStyle(color: Colors.white)),
          )
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
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
