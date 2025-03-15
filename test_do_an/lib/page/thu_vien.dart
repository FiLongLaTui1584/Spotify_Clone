import 'package:flutter/material.dart';
import '/component/custom_music_bar.dart';
import '/component/custom_drawer_nav.dart';

class ThuVien extends StatefulWidget {
  @override
  _ThuVienState createState() => _ThuVienState();
}

class _ThuVienState extends State<ThuVien> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromRGBO(18, 18, 18, 1),
      drawer: NavigationWidget(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildCategoryButtons(),
          _buildArtistList(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: CustomMusicBar(),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 70, bottom: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _scaffoldKey.currentState?.openDrawer(),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/images/avatar.png'),
            ),
          ),
          const SizedBox(width: 20),
          const Text(
            'Thư viện',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          Icon(Icons.search, color: Colors.white),
          const SizedBox(width: 15),
          Icon(Icons.add, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildCategoryButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          _buildCategoryButton('Nghệ sĩ', true),
          const SizedBox(width: 10),
          _buildCategoryButton('Danh sách phát', false),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String title, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      decoration: BoxDecoration(
        color: isSelected ? Color.fromRGBO(31, 214, 98, 1) : Colors.grey[800],
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

  Widget _buildArtistList() {
    final List<Map<String, String>> artists = [
      {'name': 'Alan Walker', 'image': 'assets/images/random.png'},
      {'name': 'AMEE', 'image': 'assets/images/random.png'},
      {'name': 'ANH TRAI "SAY HI"', 'image': 'assets/images/random.png'},
      {'name': 'Bích Phương', 'image': 'assets/images/random.png'},
      {'name': 'BIGBANG', 'image': 'assets/images/random.png'},
      {'name': 'Bruno Mars', 'image': 'assets/images/random.png'},
      {'name': 'Changg', 'image': 'assets/images/random.png'},
      {'name': 'Joji', 'image': 'assets/images/random.png'},
      {'name': 'Alan Walker', 'image': 'assets/images/random.png'},
      {'name': 'AMEE', 'image': 'assets/images/random.png'},
      {'name': 'ANH TRAI "SAY HI"', 'image': 'assets/images/random.png'},
      {'name': 'Bích Phương', 'image': 'assets/images/random.png'},
      {'name': 'BIGBANG', 'image': 'assets/images/random.png'},
      {'name': 'Bruno Mars', 'image': 'assets/images/random.png'},
      {'name': 'Changg', 'image': 'assets/images/random.png'},
      {'name': 'Joji', 'image': 'assets/images/random.png'},
    ];

    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        itemCount: artists.length,
        itemBuilder: (context, index) {
          return _buildArtistItem(artists[index]);
        },
      ),
    );
  }

  Widget _buildArtistItem(Map<String, String> artist) {
    return Padding(
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
    );
  }
}
