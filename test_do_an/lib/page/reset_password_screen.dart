import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:test_do_an/helper/database_helper.dart';
import 'dart:math';
import 'verify_code_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final dbHelper = DatabaseHelper.instance;

  String _generateRandomCode() {
    Random random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  Future<void> _sendVerificationCode(String email) async {
    try {
      final user = await dbHelper.getUserByEmail(email);
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email không tồn tại')),
        );
        return;
      }

      String code = _generateRandomCode();
      String username = 'giapt9876@gmail.com';
      String password = 'katj yzgp ebyt  umzt';

      final smtpServer = gmail(username, password);

      final message = Message()
        ..from = Address(username, 'Spotifree')
        ..recipients.add(email)
        ..subject = 'Mã xác nhận khôi phục mật khẩu'
        ..text =
            'Mã xác nhận của bạn là: $code\nMã này có hiệu lực trong 1 phút.';

      await send(message, smtpServer);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mã xác nhận đã được gửi qua email')),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              VerifyCodeScreen(email: email, verificationCode: code),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi gửi mã: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      body: Stack(
        children: [
          // Nút quay về
          Positioned(
            top: size.height * 0.05,
            left: 16,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.pop(context); // Quay lại màn hình trước
              },
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
                      _buildEmailaEmailField(size.width),
                      SizedBox(height: size.height * 0.02),
                      _buildSendCodeButton(size.width),
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
        'Khôi phục mật khẩu',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Arial',
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      );

  Widget _buildEmailaEmailField(double width) => FractionallySizedBox(
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
                  child: Image.asset('assets/images/email_icon.png',
                      fit: BoxFit.fill),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(
                        color: Colors.grey, fontFamily: 'Arial', fontSize: 15),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  ),
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'Arial', fontSize: 15),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Email không hợp lệ';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildSendCodeButton(double width) => FractionallySizedBox(
        widthFactor: 0.9,
        child: GestureDetector(
          onTap: () {
            if (_formKey.currentState!.validate()) {
              _sendVerificationCode(_emailController.text);
            }
          },
          child: Container(
            height: width * 0.12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Color(0xFF1FD662),
            ),
            child: Center(
              child: Text(
                'Gửi mã xác nhận',
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
