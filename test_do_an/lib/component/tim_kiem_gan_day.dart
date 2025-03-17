import 'package:flutter/material.dart';

class TimKiemGanDay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> recentSearches = [
      {'name': 'MONO', 'type': 'Nghệ sĩ', 'image': 'assets/images/random.png'},
      {'name': 'ISAAC', 'type': 'Nghệ sĩ', 'image': 'assets/images/random.png'},
      {
        'name': 'Bầu trời mới',
        'type': 'Bài hát - Da LAB, Minh Tốc & Lam',
        'image': 'assets/images/random.png'
      },
      {'name': 'VŨ.', 'type': 'Nghệ sĩ', 'image': 'assets/images/random.png'},
      {
        'name': 'Ngủ một mình (tình rất tình)',
        'type': 'Bài hát - HIEUTHUHAI, Negav, Kewtie',
        'image': 'assets/images/random.png'
      },
      {'name': 'MONO', 'type': 'Nghệ sĩ', 'image': 'assets/images/random.png'},
      {'name': 'ISAAC', 'type': 'Nghệ sĩ', 'image': 'assets/images/random.png'},
      {
        'name': 'Bầu trời mới',
        'type': 'Bài hát - Da LAB, Minh Tốc & Lam',
        'image': 'assets/images/random.png'
      },
      {'name': 'VŨ.', 'type': 'Nghệ sĩ', 'image': 'assets/images/random.png'},
      {
        'name': 'Ngủ một mình (tình rất tình)',
        'type': 'Bài hát - HIEUTHUHAI, Negav, Kewtie',
        'image': 'assets/images/random.png'
      },
    ];

    return Scaffold(
      backgroundColor: Color.fromRGBO(18, 18, 18, 1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60), // Khoảng cách với phía trên
          _buildSearchBar(context),
          const Padding(
            padding: const EdgeInsets.only(
              left: 15.0,
              right: 15.0,
              top: 20.0,
              bottom: 10.0,
            ),
            child: Text(
              'Nội dung tìm kiếm gần đây',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Danh sách tìm kiếm gần đây
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: recentSearches.length,
              itemBuilder: (context, index) {
                final item = recentSearches[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15), // Thêm dòng này
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(item['image']!),
                  ),
                  title: Text(item['name']!,
                      style: TextStyle(color: Colors.white)),
                  subtitle:
                      Text(item['type']!, style: TextStyle(color: Colors.grey)),
                  trailing: IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      // Xử lý xóa mục tìm kiếm (nếu cần)
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 5),
          // Nút xóa toàn bộ lịch sử
          Center(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () {
                // Xử lý xóa toàn bộ lịch sử tìm kiếm
              },
              child: const Text('Xóa nội dung tìm kiếm gần đây',
                  style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 200),
        ],
      ),
    );
  }

  // Hàm SearchBar
  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 10),
                  const Icon(Icons.search, color: Colors.grey, size: 20),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Bạn muốn nghe gì?',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Text(
              'Hủy',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  // Hiệu ứng chuyển cảnh mờ dần (Fade)
  Route _createFadeRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => TimKiemGanDay(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}
