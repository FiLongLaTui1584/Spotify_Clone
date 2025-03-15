import 'package:flutter/material.dart';

class IntroWidget extends StatelessWidget {
  const IntroWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(18, 18, 18, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 350),
                SizedBox(
                    width: 70,
                    height: 70,
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.fill,
                    )),
                SizedBox(height: 40),
                Text(
                  'Hàng triệu bài hát.\nMiễn phí trên Spotifree.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontFamily: 'Arial',
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 180),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/register');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(31, 214, 98, 1),
                    foregroundColor: Color.fromRGBO(0, 2, 0, 1),
                    minimumSize:
                        Size(MediaQuery.of(context).size.width * 0.8, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: Text(
                    'Đăng ký miễn phí',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Color.fromRGBO(255, 255, 255, 1),
                    minimumSize:
                        Size(MediaQuery.of(context).size.width * 0.8, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                      side: BorderSide(
                        color: Color.fromRGBO(176, 176, 176, 1),
                        width: 2,
                      ),
                    ),
                  ),
                  child: Text(
                    'Đăng nhập',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
