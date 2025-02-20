import 'package:flutter/material.dart';

class UniversityListScreen extends StatelessWidget {
  final List<Map<String, String>> mockUniversities = [
    {"name": "Đại học Bách Khoa Hà Nội", "location": "Hà Nội"},
    {"name": "Đại học Kinh tế Quốc dân", "location": "Hà Nội"},
    {"name": "Đại học Sư phạm TP.HCM", "location": "TP.HCM"},
    {"name": "Đại học Y Dược TP.HCM", "location": "TP.HCM"},
    {"name": "Đại học Đà Nẵng", "location": "Đà Nẵng"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Danh sách các trường đại học")),
      body: ListView.builder(
        itemCount: mockUniversities.length,
        itemBuilder: (context, index) {
          var uni = mockUniversities[index];
          return ListTile(
            leading: Icon(Icons.school),
            title: Text(uni["name"]!),
            subtitle: Text("Địa điểm: ${uni["location"]}"),
          );
        },
      ),
    );
  }
}
