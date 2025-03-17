import 'package:flutter/material.dart';

class PlaylistDetailPage extends StatelessWidget {
  final List<Map<String, dynamic>> songs = [
    {
      'title': 'Faded',
      'artist': 'Alan Walker',
      'image': 'assets/images/random.png',
      'plays': '2.120.730.968'
    },
    {
      'title': 'On My Way',
      'artist': 'Alan Walker',
      'image': 'assets/images/random.png',
      'plays': '758.453.007'
    },
    {
      'title': 'Alone',
      'artist': 'Alan Walker',
      'image': 'assets/images/random.png',
      'plays': '806.207.704'
    },
    {
      'title': 'Better Off',
      'artist': 'Jeremy Zucker',
      'image': 'assets/images/random.png',
      'plays': '133.812.470'
    },
    {
      'title': 'Issues',
      'artist': 'Julia Michaels',
      'image': 'assets/images/random.png',
      'plays': '1.272.771.194'
    },
    {
      'title': 'Faded',
      'artist': 'Alan Walker',
      'image': 'assets/images/random.png',
      'plays': '2.120.730.968'
    },
    {
      'title': 'On My Way',
      'artist': 'Alan Walker',
      'image': 'assets/images/random.png',
      'plays': '758.453.007'
    },
    {
      'title': 'Alone',
      'artist': 'Alan Walker',
      'image': 'assets/images/random.png',
      'plays': '806.207.704'
    },
    {
      'title': 'Better Off',
      'artist': 'Jeremy Zucker',
      'image': 'assets/images/random.png',
      'plays': '133.812.470'
    },
    {
      'title': 'Issues',
      'artist': 'Julia Michaels',
      'image': 'assets/images/random.png',
      'plays': '1.272.771.194'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(18, 18, 18, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 320,
                width: 320,
                decoration: BoxDecoration(color: Colors.grey[800]),
                child: Image.asset(
                  'assets/images/song_icon.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Danh sách phát thứ 1 của tôi",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundImage:
                              AssetImage('assets/images/avatar.png'),
                        ),
                        SizedBox(width: 8),
                        Text("FiLongLàTui",
                            style: TextStyle(color: Colors.grey)),
                        SizedBox(width: 10),
                        Icon(Icons.more_horiz, color: Colors.white),
                      ],
                    ),
                  ],
                ),
                Container(
                  width: 60, // Đảm bảo hình vuông
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle, // Đảm bảo hình tròn
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.play_arrow,
                      color: Colors.black,
                      size: 35,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Text(
              "Danh sách bài hát",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true, // Đảm bảo không chiếm toàn bộ không gian
              physics:
                  NeverScrollableScrollPhysics(), // Vô hiệu hóa cuộn của ListView
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 5, right: 15, top: 8, bottom: 8),
                  child: Row(
                    children: [
                      Text(
                        "${index + 1}",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(width: 15),
                      Image.asset(song['image'],
                          width: 50, height: 50, fit: BoxFit.cover),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(song['title'],
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15)),
                            Text(song['plays'],
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 13)),
                          ],
                        ),
                      ),
                      Icon(Icons.more_horiz, color: Colors.white),
                    ],
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
