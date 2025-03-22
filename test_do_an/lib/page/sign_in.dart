import 'package:flutter/material.dart';
import 'package:test_do_an/helper/database_helper.dart';
import 'package:test_do_an/helper/user_session.dart';
import 'package:test_do_an/page/sign_up.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  void _handleSignIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập email và mật khẩu')),
      );
      return;
    }

    Map<String, dynamic>? user = await _dbHelper.loginUser(email, password);
    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng nhập thành công!')),
      );
      UserSession.currentUser = user; // Lưu thông tin user
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email hoặc mật khẩu không đúng')),
      );
    }
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
              _buildSignInButton(size.width),
              SizedBox(height: size.height * 0.05),
              _buildAccountQuestion(),
              _buildSignUpButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(double width) => Container(
        width: 70,
        height: 70,
        child: Center(child: Image.asset('assets/images/logo.png', fit: BoxFit.fill)),
      );

  Widget _buildTitle() => Text(
        'Đăng nhập vào Spotifree',
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

  Widget _buildSignInButton(double width) => FractionallySizedBox(
        widthFactor: 0.8,
        child: GestureDetector(
          onTap: _handleSignIn,
          child: Container(
            height: width * 0.12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Color(0xFF1FD662),
            ),
            child: Center(
              child: Text(
                'Đăng nhập',
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
        'Bạn chưa có tài khoản?',
        style: TextStyle(color: Colors.white, fontFamily: 'Arial', fontSize: 15),
      );

  Widget _buildSignUpButton(BuildContext context) => GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SignUp())),
        child: Text(
          'Đăng ký',
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