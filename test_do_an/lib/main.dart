import 'package:flutter/material.dart';
import 'page/firstPage.dart';
import 'page/sign_in.dart';
import 'page/sign_up.dart';
import 'main_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => IntroWidget(),
        '/login': (context) => SignIn(),
        '/register': (context) => SignUp(),
        '/main': (context) => MainScreen(),
      },
    );
  }
}
