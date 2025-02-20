import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // final ApiService apiService = ApiService();
  List<dynamic> dashboardData = [];

  @override
  void initState() {
    super.initState();
    fetchDashboard();
  }

  void fetchDashboard() async {
    // final data = await apiService.getDashboardData();
    setState(() {
      // dashboardData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: dashboardData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: dashboardData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(dashboardData[index]['title']),
                  subtitle: Text("Value: ${dashboardData[index]['value']}"),
                );
              },
            ),
    );
  }
}
