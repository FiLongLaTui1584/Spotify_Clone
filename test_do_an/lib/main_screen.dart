import 'package:flutter/material.dart';
import 'package:test_do_an/helper/audio_player_manager.dart'; // Import AudioPlayerManager
import 'page/thu_vien.dart';
import 'page/trang_chu.dart';
import 'page/tim_kiem.dart';
import 'page/account.dart';
import 'component/custom_bottom_nav.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  final AudioPlayerManager _audioManager = AudioPlayerManager(); // Khởi tạo AudioPlayerManager

  @override
  void initState() {
    super.initState();
    _audioManager.init(); // Khởi tạo AudioPlayerManager một lần duy nhất
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(), // Ngăn vuốt ngang
        children: [TrangChu(), TimKiem(), ThuVien(), AccountPage()],
      ),
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _audioManager.dispose(); // Giải phóng AudioPlayerManager khi MainScreen bị hủy
    super.dispose();
  }
}