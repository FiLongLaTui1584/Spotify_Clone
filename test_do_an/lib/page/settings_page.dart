import 'package:flutter/material.dart';
import 'package:test_do_an/page/firstPage.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(18, 18, 18, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(18, 18, 18, 1),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Cài đặt",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _buildListItem("Chỉnh sửa thông tin tài khoản"),
                _buildListItem("Cài đặt mật khẩu"),
                _buildListItem("Hoạt động gần đây"),
                _buildListItem("Quyền riêng tư"),
                _buildListItem("Điều khoản và sử dụng"),
                _buildListItem("Giới thiệu"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 320.0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IntroWidget(),
                  ),
                );
              },
              child: Text(
                "Đăng xuất",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(String title) {
    return Column(
      children: [
        ListTile(
          title: Text(title, style: TextStyle(color: Colors.white)),
          trailing:
              Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          onTap: () {
            // Xử lý khi bấm vào mục
          },
        )
      ],
    );
  }
}
