import 'package:flutter/material.dart';

class RecentPage extends StatefulWidget {
  @override
  _RecentPageState createState() => _RecentPageState();
}

class _RecentPageState extends State<RecentPage> {
  int selectedFilter = 0; // 0: Bài hát, 1: Nghệ sĩ, 2: Album

  final List<String> filters = ["Bài hát", "Nghệ sĩ", "Album"];

  final Map<String, List<Map<String, String>>> recentItems = {
    "Hôm qua": [
      {
        "title": "NOLOVENOLIFE",
        "type": "Bài hát",
        "image": "assets/images/random.png"
      },
      {
        "title": "The Spectre",
        "type": "Bài hát",
        "image": "assets/images/random.png"
      },
      {
        "title": "Alan Walker",
        "type": "Nghệ sĩ",
        "image": "assets/images/random.png"
      },
      {
        "title": "This Is Alan Walker",
        "type": "Album",
        "image": "assets/images/random.png"
      },
    ],
    "Hôm kia": [
      {
        "title": "Faded",
        "type": "Bài hát",
        "image": "assets/images/random.png"
      },
      {
        "title": "The Spectre",
        "type": "Bài hát",
        "image": "assets/images/random.png"
      },
      {
        "title": "Bruno Mars",
        "type": "Nghệ sĩ",
        "image": "assets/images/random.png"
      },
      {
        "title": "This Is Alan Walker",
        "type": "Album",
        "image": "assets/images/random.png"
      },
    ],
    "ngày 20 thg 2, 2025": [
      {
        "title": "Blinding Lights",
        "type": "Bài hát",
        "image": "assets/images/random.png"
      },
    ],
    "ngày 15 thg 2, 2025": [
      {
        "title": "NOLOVENOLIFE",
        "type": "Bài hát",
        "image": "assets/images/random.png"
      },
      {
        "title": "The Spectre",
        "type": "Bài hát",
        "image": "assets/images/random.png"
      },
      {
        "title": "Alan Walker",
        "type": "Nghệ sĩ",
        "image": "assets/images/random.png"
      },
      {
        "title": "This Is Alan Walker",
        "type": "Album",
        "image": "assets/images/random.png"
      },
    ],
    "ngày 10 thg 2, 2025": [
      {
        "title": "Faded",
        "type": "Bài hát",
        "image": "assets/images/random.png"
      },
      {
        "title": "The Spectre",
        "type": "Bài hát",
        "image": "assets/images/random.png"
      },
      {
        "title": "Bruno Mars",
        "type": "Nghệ sĩ",
        "image": "assets/images/random.png"
      },
      {
        "title": "This Is Alan Walker",
        "type": "Album",
        "image": "assets/images/random.png"
      },
    ],
    "ngày 5 thg 2, 2025": [
      {
        "title": "Blinding Lights",
        "type": "Bài hát",
        "image": "assets/images/random.png"
      },
    ]
  };

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
        title: Text("Gần đây",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(filters.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ChoiceChip(
                    label: Text(filters[index]),
                    selected: selectedFilter == index,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedFilter = index;
                      });
                    },
                    selectedColor: Colors.green,
                    backgroundColor: Colors.grey[900],
                    labelStyle: TextStyle(
                      color:
                          selectedFilter == index ? Colors.black : Colors.grey,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20), // Điều chỉnh độ bo tròn
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: recentItems.keys.map((date) {
                  return _buildDateSection(date, recentItems[date]!);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSection(String date, List<Map<String, String>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(date,
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Column(
          children: items.where((item) => _filterItem(item)).map((item) {
            return _buildRecentItem(item);
          }).toList(),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildRecentItem(Map<String, String> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              item["image"]!,
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
                  item["title"]!,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  item["type"]!,
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
    );
  }

  bool _filterItem(Map<String, String> item) {
    if (selectedFilter == 0) return item["type"] == "Bài hát";
    if (selectedFilter == 1) return item["type"] == "Nghệ sĩ";
    if (selectedFilter == 2) return item["type"] == "Album";
    return true;
  }
}
