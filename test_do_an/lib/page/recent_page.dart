import 'package:flutter/material.dart';
import 'package:test_do_an/helper/audio_player_manager.dart';
import 'package:test_do_an/helper/database_helper.dart';
import 'dart:math'; // Để chọn ngẫu nhiên thời gian

class RecentPage extends StatefulWidget {
  @override
  _RecentPageState createState() => _RecentPageState();
}

class _RecentPageState extends State<RecentPage> {
  final AudioPlayerManager _audioManager = AudioPlayerManager();
  Map<String, List<Map<String, dynamic>>> recentItems = {};
  bool _isLoading = false;

  // Danh sách thời gian giả
  final List<Map<String, dynamic>> fakeTimes = [
    {'text': 'Hôm nay', 'days': 0},
    {'text': '1 ngày trước', 'days': 1},
    {'text': '2 ngày trước', 'days': 2},
    {'text': '3 ngày trước', 'days': 3},
    {'text': '4 ngày trước', 'days': 4},
    {'text': '5 ngày trước', 'days': 5},
    {'text': '6 ngày trước', 'days': 6},
    {'text': '7 ngày trước', 'days': 7},
  ];

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    setState(() {
      _isLoading = true;
    });
    try {
      // Lấy tất cả bài hát từ cơ sở dữ liệu
      final fetchedSongs = await DatabaseHelper.instance.getAllSongs();

      // Xáo trộn danh sách bài hát
      fetchedSongs.shuffle();

      // Gán thời gian phát hành giả
      List<Map<String, dynamic>> songsWithTime = fetchedSongs.map((song) {
        final randomTime = fakeTimes[Random().nextInt(fakeTimes.length)];
        return {
          ...song,
          'time': randomTime['text'],
          'days': randomTime['days'], // Để sắp xếp
        };
      }).toList();

      // Nhóm các bài hát theo ngày
      Map<String, List<Map<String, dynamic>>> groupedSongs = {};
      for (var song in songsWithTime) {
        String date = song['time'];
        if (!groupedSongs.containsKey(date)) {
          groupedSongs[date] = [];
        }
        groupedSongs[date]!.add(song);
      }

      // Sắp xếp các ngày (gần đây nhất lên đầu)
      final sortedKeys = groupedSongs.keys.toList()
        ..sort((a, b) {
          int daysA = fakeTimes.firstWhere((time) => time['text'] == a)['days'];
          int daysB = fakeTimes.firstWhere((time) => time['text'] == b)['days'];
          return daysA.compareTo(daysB);
        });

      Map<String, List<Map<String, dynamic>>> sortedGroupedSongs = {};
      for (var key in sortedKeys) {
        sortedGroupedSongs[key] = groupedSongs[key]!;
      }

      setState(() {
        recentItems = sortedGroupedSongs;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải bài hát: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
        title: Text(
          "Gần đây",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : recentItems.isEmpty
                ? Center(
                    child: Text(
                      'Không có bài hát nào',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : ListView(
                    children: recentItems.keys.map((date) {
                      return _buildDateSection(date, recentItems[date]!);
                    }).toList(),
                  ),
      ),
    );
  }

  Widget _buildDateSection(String date, List<Map<String, dynamic>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          date,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Column(
          children: items.map((item) {
            return _buildRecentItem(item);
          }).toList(),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildRecentItem(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () async {
        try {
          await _audioManager.playSongById(item['id']);
          setState(() {}); // Cập nhật UI nếu cần
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi khi phát bài hát: $e')),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                item['avatar'] ?? 'assets/images/random.png',
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title']!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "Bài hát",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
