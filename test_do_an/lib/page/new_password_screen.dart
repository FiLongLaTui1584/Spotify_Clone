import 'package:flutter/material.dart';
import 'package:test_do_an/helper/database_helper.dart';
import 'package:test_do_an/page/sign_in.dart'; // Thêm import màn hình SignIn

class NewPasswordScreen extends StatefulWidget {
  final String email;

  NewPasswordScreen({required this.email});

  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final dbHelper = DatabaseHelper.instance;

  Future<void> _updatePassword() async {
    if (_formKey.currentState!.validate()) {
      String newPassword = _newPasswordController.text.trim();
      String confirmPassword = _confirmPasswordController.text.trim();

      if (newPassword != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Mật khẩu không khớp')),
        );
        return;
      }

      final user = await dbHelper.getUserByEmail(widget.email);
      if (user != null) {
        await dbHelper.updateUser(
          user['id'],
          user['name'],
          user['avatar'],
        ); // Giữ nguyên name và avatar
        await dbHelper.database.then((db) => db.update(
              'users',
              {'password': newPassword},
              where: 'username = ?',
              whereArgs: [widget.email],
            ));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cập nhật mật khẩu thành công')),
        );
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFF121212), // Màu nền giống SignIn
      body: Stack(
        children: [
          // Nút "Hủy"
          Positioned(
            top: size.height * 0.05,
            left: 16,
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => SignIn()),
                );
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close, // Biểu tượng dấu X
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: size.height * 0.1),
                      _buildLogo(size.width),
                      SizedBox(height: size.height * 0.03),
                      _buildTitle(),
                      SizedBox(height: size.height * 0.05),
                      _buildNewPasswordField(size.width),
                      SizedBox(height: size.height * 0.01),
                      _buildConfirmPasswordField(size.width),
                      SizedBox(height: size.height * 0.02),
                      _buildUpdatePasswordButton(size.width),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(double width) => Container(
        width: 70,
        height: 70,
        child: Center(
            child: Image.asset('assets/images/logo.png', fit: BoxFit.fill)),
      );

  Widget _buildTitle() => Text(
        'Tạo mật khẩu mới',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Arial',
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      );

  Widget _buildNewPasswordField(double width) => FractionallySizedBox(
        widthFactor: 0.9,
        child: Container(
          height: width * 0.12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Colors.white, width: 1.5),
            color: Color(0xFF2A2A2A),
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: width * 0.05),
                child: SizedBox(
                  width: 25,
                  height: 25,
                  child: Image.asset('assets/images/password_icon.png',
                      fit: BoxFit.fill),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: _newPasswordController,
                  decoration: InputDecoration(
                    hintText: 'Mật khẩu mới',
                    hintStyle: TextStyle(
                        color: Colors.grey, fontFamily: 'Arial', fontSize: 15),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  ),
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'Arial', fontSize: 15),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu mới';
                    }
                    /*if (value.length < 6) {
                      return 'Mật khẩu phải có ít nhất 6 ký tự';
                    }*/
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildConfirmPasswordField(double width) => FractionallySizedBox(
        widthFactor: 0.9,
        child: Container(
          height: width * 0.12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Colors.white, width: 1.5),
            color: Color(0xFF2A2A2A),
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: width * 0.05),
                child: SizedBox(
                  width: 25,
                  height: 25,
                  child: Image.asset('assets/images/password_icon.png',
                      fit: BoxFit.fill),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    hintText: 'Nhập lại mật khẩu mới',
                    hintStyle: TextStyle(
                        color: Colors.grey, fontFamily: 'Arial', fontSize: 15),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  ),
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'Arial', fontSize: 15),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập lại mật khẩu';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildUpdatePasswordButton(double width) => FractionallySizedBox(
        widthFactor: 0.9,
        child: GestureDetector(
          onTap: _updatePassword,
          child: Container(
            height: width * 0.12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Color(0xFF1FD662), // Màu nút giống SignIn
            ),
            child: Center(
              child: Text(
                'Tạo mật khẩu mới',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Arial',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
}
