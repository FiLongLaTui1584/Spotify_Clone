import 'package:flutter/material.dart';
import 'package:test_do_an/page/playlist_detail.dart';

class CreatePlaylistNameSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();

    return Container(
      height:
          MediaQuery.of(context).size.height * 0.9, // Chiều cao 80% màn hình
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color.fromRGBO(53, 53, 53, 1), // Màu nền
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Nút đóng
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          SizedBox(height: 200),

          // Tiêu đề
          Text(
            "Đặt tên cho danh sách phát của bạn",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 20),

          // Ô nhập tên playlist
          TextField(
            controller: _controller,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              hintText: "Nhập tên danh sách phát",
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
            ),
          ),

          SizedBox(height: 20),

          // Nút "Tạo"
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Đóng Bottom Sheet
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlaylistDetailPage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                "Tạo",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
