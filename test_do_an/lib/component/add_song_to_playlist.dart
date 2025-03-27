import 'package:flutter/material.dart';
import 'package:test_do_an/helper/database_helper.dart';

class AddSongToPlaylistBottomSheet extends StatefulWidget {
  final int albumId;

  const AddSongToPlaylistBottomSheet({required this.albumId});

  @override
  _AddSongToPlaylistBottomSheetState createState() =>
      _AddSongToPlaylistBottomSheetState();
}

class _AddSongToPlaylistBottomSheetState
    extends State<AddSongToPlaylistBottomSheet> {
  List<Map<String, dynamic>> allSongs = [];
  List<Map<String, dynamic>> filteredSongs = [];
  List<int> songsInAlbum = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSongs();
    _searchController.addListener(_filterSongs);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSongs() async {
    songsInAlbum =
        (await DatabaseHelper.instance.getSongsInAlbum(widget.albumId))
            .map((song) => song['id'] as int)
            .toList();

    List<Map<String, dynamic>> songs =
        await DatabaseHelper.instance.getAllSongs();

    allSongs =
        songs.where((song) => !songsInAlbum.contains(song['id'])).toList();
    filteredSongs = List.from(allSongs);

    setState(() {});
  }

  void _filterSongs() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredSongs = allSongs.where((song) {
        return song['title'].toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _addSongToAlbum(int songId) async {
    await DatabaseHelper.instance.addSongToAlbum(widget.albumId, songId);
    setState(() {
      songsInAlbum.add(songId);
      filteredSongs.removeWhere((song) => song['id'] == songId);
      allSongs.removeWhere((song) => song['id'] == songId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã thêm bài hát vào playlist')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 40),
            ],
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Icon(Icons.search, color: Colors.white),
                ),
                hintText: "Tìm kiếm",
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
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
                  if (filteredSongs.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "Không tìm thấy bài hát",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ...filteredSongs.map((song) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          song['avatar'] ?? 'assets/images/random.png',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        song['title'],
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        song['artist'],
                        style: TextStyle(color: Colors.grey),
                      ),
                      trailing: Icon(
                        Icons.add_circle_outline,
                        color: Colors.white,
                      ),
                      onTap: () => _addSongToAlbum(song['id']),
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
