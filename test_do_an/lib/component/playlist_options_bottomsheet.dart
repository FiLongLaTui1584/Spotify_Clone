import 'package:flutter/material.dart';
import 'package:test_do_an/component/add_song_to_playlist.dart';
import 'package:test_do_an/helper/database_helper.dart';

class PlaylistOptionsBottomSheet extends StatelessWidget {
  final int albumId;
  final String albumName;
  final bool isDefault;

  const PlaylistOptionsBottomSheet({
    required this.albumId,
    required this.albumName,
    required this.isDefault,
  });

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
            albumName,
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
            title: Text(
              "Thêm vào danh sách phát này",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pop(context);
              showAddSongBottomSheet(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.remove_circle_outline,
              color: isDefault ? Colors.grey : Colors.red,
            ),
            title: Text(
              "Xóa playlist",
              style: TextStyle(
                color: isDefault ? Colors.grey : Colors.redAccent,
              ),
            ),
            subtitle: isDefault
                ? Text(
                    'Album "Yêu thích" không thể xóa',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  )
                : null,
            onTap: isDefault
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Không thể xóa album "Yêu thích"'),
                      ),
                    );
                  }
                : () async {
                    try {
                      await DatabaseHelper.instance.deleteAlbum(albumId);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Đã xóa playlist $albumName')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Lỗi: $e')),
                      );
                    }
                  },
          ),
        ],
      ),
    );
  }

  void showAddSongBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color.fromRGBO(18, 18, 18, 1),
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        child: AddSongToPlaylistBottomSheet(albumId: albumId),
      ),
    );
  }
}
