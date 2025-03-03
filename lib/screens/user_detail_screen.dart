import 'package:flutter/material.dart';
import 'package:collegeadmissionhelper/models/user.dart';

class UserDetailScreen extends StatelessWidget {
  final User user;

  const UserDetailScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Thông tin người dùng")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blueAccent,
                backgroundImage: (user.userImage != null &&
                        user.userImage!.isNotEmpty)
                    ? NetworkImage(user.userImage!)
                    : null,
                child: (user.userImage == null || user.userImage!.isEmpty)
                    ? Icon(Icons.person, size: 50, color: Colors.white)
                    : null,
              ),
            ),
            SizedBox(height: 20),
            Text("Họ và tên:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(user.name, style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Email:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(user.email, style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Tên đăng nhập:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(user.userName, style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Số điện thoại:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(user.phoneNumber ?? "Chưa có", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
