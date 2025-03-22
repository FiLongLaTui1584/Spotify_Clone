import 'package:flutter/material.dart';
import 'package:test_do_an/helper/database_helper.dart'; // Đảm bảo đường dẫn đúng
import 'package:test_do_an/page/sign_in.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Hàm hiển thị bottom sheet để nhập tên
  void _showNameInputSheet(String email, String password) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Cho phép sheet mở rộng khi bàn phím xuất hiện
      backgroundColor: Color(0xFF2A2A2A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // Điều chỉnh khi bàn phím xuất hiện
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Nhập tên của bạn',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Arial',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Tên',
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Color(0xFF121212),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String name = _nameController.text.trim();
                  if (name.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Vui lòng nhập tên')),
                    );
                  } else {
                    _completeSignUp(email, password, name);
                    Navigator.pop(context); // Đóng bottom sheet
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1FD662),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text(
                  'Xác nhận',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Arial',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // Hàm xử lý đăng ký sau khi có tên
  void _completeSignUp(String email, String password, String name) async {
    int result = await _dbHelper.registerUser(email, password, name, null); // Avatar để null vì chưa tích hợp
    if (result != -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng ký thành công! Vui lòng đăng nhập')),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SignIn()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng ký thất bại: Email đã tồn tại hoặc lỗi khác')),
      );
    }
  }

  // Hàm xử lý khi nhấn "Tạo tài khoản"
  void _handleSignUp() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập email và mật khẩu')),
      );
      return;
    }

    // Hiển thị bottom sheet để nhập tên
    _showNameInputSheet(email, password);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 200),
              _buildLogo(size.width),
              SizedBox(height: size.height * 0.03),
              _buildTitle(),
              SizedBox(height: size.height * 0.05),
              _buildEmailField(size.width),
              SizedBox(height: size.height * 0.01),
              _buildPasswordField(size.width),
              SizedBox(height: size.height * 0.02),
              _buildCreateAccountButton(size.width),
              SizedBox(height: size.height * 0.05),
              _buildAccountQuestion(),
              _buildLoginButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(double width) => Container(
        width: 70,
        height: 70,
        child: Center(child: Image.asset('assets/images/logo.png', fit: BoxFit.cover)),
      );

  Widget _buildTitle() => Text(
        'Đăng ký để bắt đầu nghe',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white, fontFamily: 'Arial', fontSize: 30, fontWeight: FontWeight.bold),
      );

  Widget _buildEmailField(double width) => FractionallySizedBox(
        widthFactor: 0.8,
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
                  child: Image.asset('assets/images/email_icon.png', fit: BoxFit.fill),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Arial', fontSize: 15),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  ),
                  style: TextStyle(color: Colors.white, fontFamily: 'Arial', fontSize: 15),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildPasswordField(double width) => FractionallySizedBox(
        widthFactor: 0.8,
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
                  child: Image.asset('assets/images/password_icon.png', fit: BoxFit.fill),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Mật khẩu',
                    hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Arial', fontSize: 15),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  ),
                  style: TextStyle(color: Colors.white, fontFamily: 'Arial', fontSize: 15),
                  obscureText: true,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildCreateAccountButton(double width) => FractionallySizedBox(
        widthFactor: 0.8,
        child: GestureDetector(
          onTap: _handleSignUp, // Gọi hàm xử lý đăng ký
          child: Container(
            height: width * 0.12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Color(0xFF1FD662),
            ),
            child: Center(
              child: Text(
                'Tạo tài khoản',
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

  Widget _buildAccountQuestion() => Text(
        'Bạn đã có tài khoản?',
        style: TextStyle(color: Colors.white, fontFamily: 'Arial', fontSize: 15),
      );

  Widget _buildLoginButton(BuildContext context) => GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SignIn())),
        child: Text(
          'Đăng nhập',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Arial',
            fontSize: 15,
            fontWeight: FontWeight.bold,
            height: 2.5,
          ),
        ),
      );
}