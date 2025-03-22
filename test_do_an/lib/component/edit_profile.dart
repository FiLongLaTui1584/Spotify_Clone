import 'package:flutter/material.dart';
import 'package:test_do_an/helper/database_helper.dart';
import 'package:test_do_an/helper/user_session.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfilePage extends StatefulWidget {
  final VoidCallback onProfileUpdated;

  EditProfilePage({required this.onProfileUpdated});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  File? _avatarImage;
  String? _currentAvatar;

  @override
  void initState() {
    super.initState();
    _nameController.text = UserSession.currentUser?['name'] ?? '';
    _currentAvatar = UserSession.currentUser?['avatar'];
  }

  // Chọn ảnh từ thư viện
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _avatarImage = File(pickedFile.path);
      });
    }
  }

  // Lưu thông tin chỉnh sửa
  void _saveProfile() async {
    String newName = _nameController.text.trim();
    if (newName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tên không được để trống')),
      );
      return;
    }

    int userId = UserSession.currentUser!['id'];
    String? newAvatar = _avatarImage?.path ?? _currentAvatar;

    int result = await _dbHelper.updateUser(userId, newName, newAvatar);
    if (result > 0) {
      UserSession.currentUser = {
        ...UserSession.currentUser!,
        'name': newName,
        'avatar': newAvatar,
      };
      widget.onProfileUpdated();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cập nhật hồ sơ thành công')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cập nhật hồ sơ thất bại')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(18, 18, 18, 1),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Hủy", style: TextStyle(color: Colors.white)),
                      ),
                      Text(
                        "Chỉnh sửa hồ sơ",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: _saveProfile,
                        child: Text("Lưu", style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _avatarImage != null
                          ? FileImage(_avatarImage!)
                          : _currentAvatar != null && _currentAvatar!.isNotEmpty
                              ? FileImage(File(_currentAvatar!))
                              : AssetImage('assets/images/avatar.png') as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage, // Chỉ mở thư viện ảnh khi nhấn vào icon
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 15,
                          child: Icon(Icons.edit, color: Colors.black, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Tên", style: TextStyle(color: Colors.grey)),
                      TextField(
                        controller: _nameController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}