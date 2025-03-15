import 'package:flutter/material.dart';
import 'package:test_do_an/page/sign_in.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color.fromRGBO(18, 18, 18, 1),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 200),
              LogoWidget(screenWidth: screenWidth),
              SizedBox(height: screenHeight * 0.03),
              TitleWidget(screenWidth: screenWidth),
              SizedBox(height: screenHeight * 0.05),
              EmailButton(screenWidth: screenWidth),
              SizedBox(height: screenHeight * 0.01),
              PhoneButton(screenWidth: screenWidth),
              SizedBox(height: screenHeight * 0.05),
              AccountQuestion(screenWidth: screenWidth),
              LoginButton(screenWidth: screenWidth),
            ],
          ),
        ),
      ),
    );
  }
}

class LogoWidget extends StatelessWidget {
  final double screenWidth;

  const LogoWidget({super.key, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Center(
        child: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

class TitleWidget extends StatelessWidget {
  final double screenWidth;

  const TitleWidget({super.key, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Đăng ký để bắt đầu nghe',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color.fromRGBO(255, 255, 255, 1),
        fontFamily: 'Arial',
        fontSize: 30,
        fontWeight: FontWeight.bold,
        height: 1,
      ),
    );
  }
}

class EmailButton extends StatelessWidget {
  final double screenWidth;

  const EmailButton({super.key, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.8,
      child: Container(
        height: screenWidth * 0.12,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Color.fromRGBO(31, 214, 98, 1),
        ),
        child: Stack(
          children: <Widget>[
            // Icon cố định bên trái
            Positioned(
              top: 0,
              bottom: 0,
              left: screenWidth * 0.05, // Khoảng cách từ lề trái
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/email_icon.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            // Dòng chữ căn giữa
            Center(
              child: Text(
                'Tiếp tục bằng email',
                style: TextStyle(
                  color: Color.fromRGBO(0, 2, 0, 1),
                  fontFamily: 'Arial',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PhoneButton extends StatelessWidget {
  final double screenWidth;

  const PhoneButton({super.key, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.8,
      child: Container(
        height: screenWidth * 0.12,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: Color.fromRGBO(176, 176, 176, 1),
            width: 1.5,
          ),
        ),
        child: Stack(
          children: <Widget>[
            // Icon cố định bên trái
            Positioned(
              top: 0,
              bottom: 0,
              left: screenWidth * 0.05, // Khoảng cách từ lề trái
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/phone_icon.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            // Dòng chữ căn giữa
            Center(
              child: Text(
                'Tiếp tục bằng số điện thoại',
                style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontFamily: 'Arial',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AccountQuestion extends StatelessWidget {
  final double screenWidth;

  const AccountQuestion({super.key, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Bạn đã có tài khoản?',
      style: TextStyle(
        color: Color.fromRGBO(255, 255, 255, 1),
        fontFamily: 'Arial',
        fontSize: 15,
        fontWeight: FontWeight.normal,
        height: 0,
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final double screenWidth;

  const LoginButton({super.key, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Chuyển đến trang đăng nhập (SignIn)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignIn()),
        );
      },
      child: Text(
        'Đăng nhập',
        style: TextStyle(
          color: Color.fromRGBO(255, 255, 255, 1),
          fontFamily: 'Arial',
          fontSize: 15,
          fontWeight: FontWeight.bold,
          height: 2.5,
        ),
      ),
    );
  }
}
