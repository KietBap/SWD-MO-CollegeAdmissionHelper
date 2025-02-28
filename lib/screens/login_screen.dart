import 'package:flutter/material.dart';
import '../services/google_signIn_service.dart';
import '../services/login_service.dart';
import '../services/token_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LoginService _loginService = LoginService();
  final GoogleAuthService _googleAuthService = GoogleAuthService();
  final TokenService _tokenService = TokenService();

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
        String? accessToken = await _loginService.getToken();
        if (accessToken != null) {
          String? role = _tokenService.checkUserRole(accessToken);
          Future.microtask(() {
            if (role == 'Admin') {
              Navigator.pushReplacementNamed(context, '/mainMenu');
            } else {
              Navigator.pushReplacementNamed(context, '/');
            }
          });
        } else {
          setState(() => errorMessage = "Không tìm thấy token.");
        }
      } else {
        setState(() {
          errorMessage = "Đăng nhập thất bại! Kiểm tra lại thông tin.";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => errorMessage = "Có lỗi xảy ra, vui lòng thử lại!");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> loginWithGoogle() async {
    setState(() => isLoading = true);
    try {
      final user = await _googleAuthService.signInWithGoogle();
      if (user != null) {
        Future.microtask(() {
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/mainMenu');
          }
        });
      } else {
        setState(() {
          errorMessage = "Đăng nhập Google thất bại!";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => errorMessage = "Lỗi khi đăng nhập Google!");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("College Admission Helper",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: login,
                        child: Text('Đăng nhập'),
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Text("Chưa có tài khoản? Đăng ký ngay"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/forgotPassword');
                        },
                        child: Text("Quên mật khẩu?"),
                      ),
                      SizedBox(height: 40),
                      Text("Login with",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey)),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: loginWithGoogle,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.all(10),
                          shape: CircleBorder(),
                        ),
                        child: Image.asset(
                          './lib/assets/google_logo.png',
                          height: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
