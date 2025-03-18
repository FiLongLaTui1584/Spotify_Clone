import 'package:flutter/material.dart';

class NewContentPage extends StatelessWidget {
  final List<Map<String, String>> songs = [
    {
      "title": "Ngày Này, Người Con Gái Này (Vow version)",
      "artist": "Võ Cát Tường",
      "time": "2 ngày trước",
      "image": "assets/images/random.png",
    },
    {
      "title": "Tái Sinh (Author version)",
      "artist": "Tăng Duy Tân",
      "time": "4 ngày trước",
      "image": "assets/images/random.png",
    },
    {
      "title": "Cảm Ơn Vì Tất Cả (Lofi Version)",
      "artist": "Anh Quân Idol, Freak D",
      "time": "4 ngày trước",
      "image": "assets/images/random.png",
    },
    {
      "title": "Ngày Này, Người Con Gái Này (Vow version)",
      "artist": "Võ Cát Tường",
      "time": "5 ngày trước",
      "image": "assets/images/random.png",
    },
    {
      "title": "Ngày Này, Người Con Gái Này (Vow version)",
      "artist": "Võ Cát Tường",
      "time": "2 ngày trước",
      "image": "assets/images/random.png",
    },
    {
      "title": "Tái Sinh (Author version)",
      "artist": "Tăng Duy Tân",
      "time": "4 ngày trước",
      "image": "assets/images/random.png",
    },
    {
      "title": "Cảm Ơn Vì Tất Cả (Lofi Version)",
      "artist": "Anh Quân Idol, Freak D",
      "time": "4 ngày trước",
      "image": "assets/images/random.png",
    },
    {
      "title": "Ngày Này, Người Con Gái Này (Vow version)",
      "artist": "Võ Cát Tường",
      "time": "5 ngày trước",
      "image": "assets/images/random.png",
    },
    {
      "title": "Ngày Này, Người Con Gái Này (Vow version)",
      "artist": "Võ Cát Tường",
      "time": "2 ngày trước",
      "image": "assets/images/random.png",
    },
    {
      "title": "Tái Sinh (Author version)",
      "artist": "Tăng Duy Tân",
      "time": "4 ngày trước",
      "image": "assets/images/random.png",
    },
    {
      "title": "Cảm Ơn Vì Tất Cả (Lofi Version)",
      "artist": "Anh Quân Idol, Freak D",
      "time": "4 ngày trước",
      "image": "assets/images/random.png",
    },
    {
      "title": "Ngày Này, Người Con Gái Này (Vow version)",
      "artist": "Võ Cát Tường",
      "time": "5 ngày trước",
      "image": "assets/images/random.png",
    },
  ];

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
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Có gì mới",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(
              "Nội dung phát hành mới nhất từ nghệ sĩ bạn theo dõi.",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            SizedBox(height: 16),
            Text(
              "Mới",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Expanded(
              child: ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  final song = songs[index];
                  return _buildSongItem(song);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSongItem(Map<String, String> song) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              song["image"]!,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song["time"]!,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  song["title"]!,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  song["artist"]!,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.play_circle_fill, color: Colors.white, size: 30),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
