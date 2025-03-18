import 'package:flutter/material.dart';
import 'package:test_do_an/component/add_song_to_playlist.dart';

class PlaylistOptionsBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(height: 25),
          Text(
            "Danh sách phát #1",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          Divider(color: Colors.grey),
          ListTile(
            leading: Icon(Icons.add_circle_outline, color: Colors.white),
            title: Text("Thêm vào danh sách phát này",
                style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context); // Đóng bottom sheet hiện tại
              showAddSongBottomSheet(context); // Mở bottom sheet mới
            },
          ),
          ListTile(
            leading: Icon(Icons.edit, color: Colors.white),
            title: Text("Sửa", style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.remove_circle_outline, color: Colors.red),
            title:
                Text("Xóa playlist", style: TextStyle(color: Colors.redAccent)),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  void showAddSongBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color.fromRGBO(18, 18, 18, 1),
      isScrollControlled: true, // Hiển thị toàn màn hình
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9, // Chiếm 90% màn hình
        child: AddSongToPlaylistBottomSheet(),
      ),
    );
  }
}
