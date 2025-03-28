import 'package:flutter/material.dart';
import 'package:test_do_an/page/new_content_page.dart';
import 'package:test_do_an/page/recent_page.dart';
import 'package:test_do_an/helper/user_session.dart'; // Import UserSession
import 'dart:io'; // Import để dùng File

class NavigationWidget extends StatefulWidget {
  const NavigationWidget({super.key});

  @override
  _NavigationWidgetState createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
  @override
  Widget build(BuildContext context) {
    // Lấy thông tin từ UserSession
    String userName = UserSession.currentUser?['name'] ??
        'Người dùng'; // Tên mặc định nếu null
    String? avatarPath = UserSession.currentUser?['avatar']; // Đường dẫn avatar

    return Drawer(
      width: 270,
      child: Container(
        color: Color.fromRGBO(31, 31, 31, 1),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(31, 31, 31, 1),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: avatarPath != null && avatarPath.isNotEmpty
                        ? FileImage(
                            File(avatarPath)) // Avatar từ đường dẫn cục bộ
                        : AssetImage('assets/images/avatar.png')
                            as ImageProvider, // Avatar mặc định
                  ),
                  SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            ListTile(
              leading: Image.asset(
                'assets/images/new_icon.png',
                width: 40,
                height: 40,
              ),
              title: Text(
                'Nội dung mới',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewContentPage(),
                  ),
                );
              },
            ),
            SizedBox(height: 18),
            ListTile(
              leading: Image.asset(
                'assets/images/recent_icon.png',
                width: 40,
                height: 40,
              ),
              title: Text(
                'Gần đây',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecentPage(),
                  ),
                );
              },
            ),
            SizedBox(height: 18),
            ListTile(
              leading: Icon(
                Icons.exit_to_app, // Icon Đăng xuất
                color: Colors.white,
                size: 40,
              ),
              title: Text(
                'Đăng xuất',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onTap: () {
                _showLogoutDialog(context); // Hiển thị dialog xác nhận
              },
            ),
          ],
        ),
      ),
    );
  }

  // Hàm hiển thị dialog xác nhận đăng xuất
  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Không đóng dialog khi nhấn ngoài
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              Color.fromRGBO(31, 31, 31, 1), // Màu nền giống Drawer
          title: Text(
            'Xác nhận đăng xuất',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Bạn có chắc muốn đăng xuất?',
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Cách đều hai nút ra hai bên
              children: [
                TextButton(
                  child: Text(
                    'Hủy',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Đóng dialog, không làm gì
                  },
                ),
                TextButton(
                  child: Text(
                    'Đăng xuất',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    UserSession.currentUser = null; // Xóa thông tin người dùng
                    Navigator.of(context).pop(); // Đóng dialog
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login', // Quay về màn hình đăng nhập
                      (route) => false, // Xóa hết stack điều hướng
                    );
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
