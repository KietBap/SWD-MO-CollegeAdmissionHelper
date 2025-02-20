import 'package:flutter/material.dart';

class MainMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Menu người dùng")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Xin chào, Admin!", style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              children: [
                _buildCard("Quản lý người dùng", Icons.people, context, '/users'),
                _buildCard("Dashboard", Icons.bar_chart, context, '/dashBoard'),
                _buildCard("Danh sách trường Đại học", Icons.school, context, '/universities'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, IconData icon, BuildContext context, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Card(
        elevation: 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            SizedBox(height: 10),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
