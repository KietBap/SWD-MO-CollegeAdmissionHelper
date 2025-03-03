import 'package:flutter/material.dart';
import 'package:collegeadmissionhelper/models/user.dart';
import 'package:collegeadmissionhelper/services/login_service.dart';
import '../services/google_signIn_service.dart';

class ProfileScreen extends StatelessWidget {
  final User user;
  final GoogleAuthService _googleAuthService = GoogleAuthService();
  final LoginService _loginService = LoginService();

  ProfileScreen({required this.user});

  Future<void> _logout(BuildContext context) async {
    try {
      await _googleAuthService.signOut();
      await _loginService.logout();
      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi đăng xuất: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hồ sơ cá nhân")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: user.userImage != null && user.userImage!.isNotEmpty
                  ? CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(user.userImage!),
                    )
                  : CircleAvatar(
                      radius: 50,
                      child: Icon(Icons.account_circle, size: 50),
                    ),
            ),
            SizedBox(height: 20),
            Text("Tên: ${user.name}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Email: ${user.email}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text(
              "Số điện thoại: ${user.phoneNumber ?? 'Chưa có'}",
              style: TextStyle(fontSize: 18),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () => _logout(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: Text("Đăng xuất",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
