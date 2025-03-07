import 'package:flutter/material.dart';

import '../services/dashboard_service.dart';

class DashBoardScreen extends StatefulWidget {
  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final DashboardService _dashboardService = DashboardService();
  String totalUsers = "...";
  String totalUniversities = "...";

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    String users = await _dashboardService.getTotalUser();
    String universities = await _dashboardService.getTotalUniversities();
    setState(() {
      totalUsers = users;
      totalUniversities = universities;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dashboard",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black, // Đổi màu chữ về đen
        elevation: 0, // Bỏ bóng
      ),
      body: Container(
        color: Colors.white, // Đổi nền trắng
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _buildStatCard(context, "Tổng số người dùng", totalUsers,
                  Icons.people, "/chart1"),
              SizedBox(height: 10),
              _buildStatCard(context, "Tổng số trường đại học",
                  totalUniversities, Icons.school, "/chart2"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value,
      IconData icon, String route) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, route); // Chuyển đến màn hình tương ứng
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.black),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text(value,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
