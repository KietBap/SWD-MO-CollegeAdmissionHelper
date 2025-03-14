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
        errorMessage = "Please enter email and password!";
      });
      return;
    }
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    try {
      bool success = await _loginService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      if (success) {
        bool isAdmin = await _tokenService.isAdmin();
        Future.microtask(() {
          if (isAdmin) {
            Navigator.pushReplacementNamed(context, '/mainMenu');
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Notification"),
                content: Text("You do not have access!"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("OK"),
                  ),
                ],
              ),
            );
            setState(() => isLoading = false);
          }
        });
      } else {
        setState(() {
          errorMessage = "Login failed! Check information again.";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => errorMessage = "An error occurred, please try again!");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> loginWithGoogle() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    try {
      final success = await _googleAuthService.signInWithGoogle();
      if (success) {
        bool isAdmin = await _tokenService.isAdmin();
        Future.microtask(() {
          if (isAdmin) {
            Navigator.pushReplacementNamed(context, '/mainMenu');
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Notification"),
                content: Text("You do not have access!"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("OK"),
                  ),
                ],
              ),
            );
            setState(() => isLoading = false);
          }
        });
      } else {
        setState(() {
          errorMessage = "Login failed!";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => errorMessage = "Error while signing in to Google!");
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
                    decoration: InputDecoration(labelText: 'Password'),
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
                        child: Text('Login'),
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
