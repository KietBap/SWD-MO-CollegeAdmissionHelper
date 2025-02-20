import 'package:flutter/material.dart';

class UserManagementScreen extends StatelessWidget {
  final List<Map<String, String>> mockUsers = [
    {"name": "Nguyễn Văn A", "email": "a@example.com"},
    {"name": "Trần Thị B", "email": "b@example.com"},
    {"name": "Lê Văn C", "email": "c@example.com"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quản lý người dùng")),
      body: ListView.builder(
        itemCount: mockUsers.length,
        itemBuilder: (context, index) {
          var user = mockUsers[index];
          return ListTile(
            leading: Icon(Icons.person),
            title: Text(user["name"]!),
            subtitle: Text(user["email"]!),
            trailing: Icon(Icons.arrow_forward),
          );
        },
      ),
    );
  }
}
