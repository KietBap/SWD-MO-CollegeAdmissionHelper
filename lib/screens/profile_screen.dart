import 'package:flutter/material.dart';
import 'package:collegeadmissionhelper/models/user.dart';
import 'package:collegeadmissionhelper/services/login_service.dart';
import '../services/google_signIn_service.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({required this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GoogleAuthService _googleAuthService = GoogleAuthService();
  final LoginService _loginService = LoginService();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await _googleAuthService.signOut();
      await _loginService.logout();
      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logout error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: widget.user.userImage != null && widget.user.userImage!.isNotEmpty
                  ? CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(widget.user.userImage!),
                    )
                  : CircleAvatar(
                      radius: 50,
                      child: Icon(Icons.account_circle, size: 50),
                    ),
            ),
            SizedBox(height: 20),
            Text("User name: ${widget.user.userName}", 
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Name: ${widget.user.name}", 
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Email: ${widget.user.email}", 
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Phone: ${widget.user.phoneNumber ?? 'None'}", 
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _logout(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: Text("Logout",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}