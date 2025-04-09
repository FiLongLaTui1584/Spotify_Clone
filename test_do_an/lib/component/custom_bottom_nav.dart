import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNav({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(18, 18, 18, 1),
      padding: const EdgeInsets.only(
        left: 0.0,
        right: 0.0,
        top: 9.0,
        bottom: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildNavItem('Trang chủ', 0, 'assets/images/home_icon_2.png',
              'assets/images/home_icon_1.png'),
          _buildNavItem('Tìm kiếm', 1, 'assets/images/search_icon_2.png',
              'assets/images/search_icon_1.png'),
          _buildNavItem('Thư viện', 2, 'assets/images/lib_icon_2.png',
              'assets/images/lib_icon_1.png'),
          _buildNavItem('Cá nhân', 3, 'assets/images/acc_icon_2.png',
              'assets/images/acc_icon_1.png'),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      String title, int index, String imagePath, String selectedImagePath) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            isSelected ? selectedImagePath : imagePath,
            width: 20,
            height: 20,
          ),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white60,
              fontSize: 10,
              fontFamily: 'Arial',
            ),
          ),
        ],
      ),
    );
  }
}
