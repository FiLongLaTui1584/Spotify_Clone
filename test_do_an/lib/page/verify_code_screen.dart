import 'package:flutter/material.dart';
import 'package:test_do_an/helper/database_helper.dart';
import 'package:test_do_an/page/reset_password_screen.dart';
import 'package:test_do_an/page/new_password_screen.dart';
import 'dart:async';

class VerifyCodeScreen extends StatefulWidget {
  final String email;
  final String verificationCode;

  const VerifyCodeScreen({required this.email, required this.verificationCode, super.key});

  @override
  _VerifyCodeScreenState createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  late Timer _timer;
  int _remainingSeconds = 120;
  bool _isCodeExpired = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          } else {
            _isCodeExpired = true;
            timer.cancel();
          }
        });
      }
    });
  }

  Future<void> _resendCode() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ResetPasswordScreen()),
    );
  }

  void _verifyCode() {
    if (_formKey.currentState!.validate()) {
      if (_isCodeExpired) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mã đã hết hạn, vui lòng gửi lại')),
        );
        return;
      }

      String enteredCode = _codeController.text.trim();
      if (enteredCode == widget.verificationCode) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NewPasswordScreen(email: widget.email),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mã xác nhận không đúng')),
        );
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xác nhận mã'),
        backgroundColor: const Color(0xFF121212),
      ),
      backgroundColor: const Color(0xFF121212),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Mã sẽ hết hạn sau $_remainingSeconds giây',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Nhập mã xác nhận',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF1FD662)),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mã xác nhận';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _verifyCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1FD662),
                  foregroundColor: Colors.black,
                ),
                child: const Text('Xác nhận'),
              ),
              const SizedBox(height: 10),
              if (_isCodeExpired)
                ElevatedButton(
                  onPressed: _resendCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Gửi lại mã mới'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}