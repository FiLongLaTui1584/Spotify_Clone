import 'package:flutter/material.dart';
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
}
