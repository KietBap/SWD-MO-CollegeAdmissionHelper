import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = "";

  void fakeLogin() {
    String email = emailController.text;
    String password = passwordController.text;

    if (email == "admin@gmail.com" && password == "123456") {
      // Thành công: Chuyển đến Dashboard
      Navigator.pushNamed(context, '/mainMenu');
    } else {
      // Sai thông tin đăng nhập
      setState(() {
        errorMessage = "Email hoặc mật khẩu không đúng!";
      });
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
              onPressed: fakeLogin,
              child: Text('Đăng nhập'),
            ),
          ],
        ),
      ),
    );
  }
}
