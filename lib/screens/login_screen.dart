import 'package:flutter/material.dart';
import '../services/login_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LoginService _loginService = LoginService();
  String errorMessage = "";
  bool isLoading = false;

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() {
        errorMessage = "Vui lòng nhập email và mật khẩu!";
      });
      return;
    }
    setState(() => isLoading = true);

    try {
      bool success = await _loginService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (success) {
        Navigator.pushReplacementNamed(context, '/mainMenu');
      } else {
        setState(() => errorMessage = "Đăng nhập thất bại! Kiểm tra lại thông tin.");
      }
    } catch (e) {
      setState(() => errorMessage = "Có lỗi xảy ra, vui lòng thử lại!");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("College Admission Helper",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Mật khẩu'),
              obscureText: true,
            ),
            SizedBox(height: 10),
            Text(
              errorMessage,
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              child: Text('Đăng nhập'),
            ),
          ],
        ),
      ),
    );
  }
}
