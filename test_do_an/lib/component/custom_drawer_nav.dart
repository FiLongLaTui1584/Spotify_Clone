import 'package:flutter/material.dart';
import 'package:test_do_an/page/new_content_page.dart';
import 'package:test_do_an/page/recent_page.dart';

class NavigationWidget extends StatefulWidget {
  const NavigationWidget({super.key});
  @override
  _NavigationWidgetState createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 370,
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
                    backgroundImage: AssetImage('assets/images/avatar.png'),
                  ),
                  SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      Text(
                        'Xem hồ sơ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
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
                'assets/images/add_icon.png',
                width: 40,
                height: 40,
              ),
              title: Text(
                'Thêm tài khoản',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onTap: () {
                // Handle the tap
              },
            ),
            SizedBox(height: 18),
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
          ],
        ),
      ),
    );
  }
}
