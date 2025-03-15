import 'package:flutter/material.dart';
import '/component/custom_bottom_nav.dart';
import '/component/custom_music_bar.dart';
import '/component/custom_drawer_nav.dart';
import '/page/trang_chu.dart';
import '/page/tim_kiem.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // Thêm key
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    TrangChu(),
    TimKiem(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Gán key vào Scaffold
      backgroundColor: const Color.fromRGBO(18, 18, 18, 1),
      drawer: NavigationWidget(),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomMusicBar(),
          ),
          CustomBottomNav(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
          ),
        ],
      ),
    );
  }
}
