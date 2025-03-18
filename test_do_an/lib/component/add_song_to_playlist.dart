import 'package:flutter/material.dart';

class AddSongToPlaylistBottomSheet extends StatelessWidget {
  final List<Map<String, String>> suggestedSongs = [
    {
      'title': 'Dù Cho Mai Về Sau',
      'artist': 'buituonglinh',
      'image': 'assets/images/random.png'
    },
    {
      'title': 'Slow Dancing In The Dark',
      'artist': 'Joji',
      'image': 'assets/images/random.png'
    },
    {
      'title': 'Glimpse Of Us',
      'artist': 'Joji',
      'image': 'assets/images/random.png'
    },
    {
      'title': 'Lover is a day',
      'artist': 'Cuco',
      'image': 'assets/images/random.png'
    },
    {
      'title': 'My Time',
      'artist': 'bo en',
      'image': 'assets/images/random.png'
    },
    {
      'title': 'I’d Rather Pretend',
      'artist': 'Bryant Barnes',
      'image': 'assets/images/random.png'
    },
    {
      'title': 'No Surprise',
      'artist': 'Radiohead',
      'image': 'assets/images/random.png'
    },
    {
      'title': 'Chezile',
      'artist': 'Beanie',
      'image': 'assets/images/random.png'
    },
    {
      'title': 'demons',
      'artist': 'Beanie',
      'image': 'assets/images/random.png'
    },
    {
      'title': 'Dù Cho Mai Về Sau',
      'artist': 'buituonglinh',
      'image': 'assets/images/random.png'
    },
    {
      'title': 'Slow Dancing In The Dark',
      'artist': 'Joji',
      'image': 'assets/images/random.png'
    },
    {
      'title': 'Glimpse Of Us',
      'artist': 'Joji',
      'image': 'assets/images/random.png'
    },
    {
      'title': 'Lover is a day',
      'artist': 'Cuco',
      'image': 'assets/images/random.png'
    },
    {
      'title': 'My Time',
      'artist': 'bo en',
      'image': 'assets/images/random.png'
    },
    {
      'title': 'I’d Rather Pretend',
      'artist': 'Bryant Barnes',
      'image': 'assets/images/random.png'
    },
    {
      'title': 'No Surprise',
      'artist': 'Radiohead',
      'image': 'assets/images/random.png'
    },
    {
      'title': 'Chezile',
      'artist': 'Beanie',
      'image': 'assets/images/random.png'
    },
    {
      'title': 'demons',
      'artist': 'Beanie',
      'image': 'assets/images/random.png'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Thanh tiêu đề
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              Text(
                "Thêm vào danh sách phát này",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 40), // Giữ khoảng cách cân bằng
            ],
          ),
          SizedBox(height: 10),
          // Ô tìm kiếm
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 12), // Căn giữa icon theo chiều dọc
                  child: Icon(Icons.search, color: Colors.white),
                ),
                hintText: "Tìm kiếm",
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                    vertical: 12), // Căn giữa nội dung văn bản
              ),
            ),
          ),

          SizedBox(height: 20),
          // Danh sách bài hát đề xuất
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 0), // Thêm padding cho cả ListView
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      "Bài hát đề xuất",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...suggestedSongs.map((song) {
                    return ListTile(
                      contentPadding: EdgeInsets
                          .zero, // Loại bỏ padding mặc định của ListTile
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          song['image']!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        song['title']!,
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        song['artist']!,
                        style: TextStyle(color: Colors.grey),
                      ),
                      trailing:
                          Icon(Icons.add_circle_outline, color: Colors.white),
                      onTap: () {
                        // Xử lý thêm bài hát vào playlist tại đây
                      },
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
