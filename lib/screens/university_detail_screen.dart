import 'package:flutter/material.dart';
import 'package:collegeadmissionhelper/models/university.dart';
import 'package:collegeadmissionhelper/services/university_service.dart';

class UniversityDetailScreen extends StatefulWidget {
  final String universityId;
  UniversityDetailScreen({required this.universityId});

  @override
  _UniversityDetailScreenState createState() => _UniversityDetailScreenState();
}

class _UniversityDetailScreenState extends State<UniversityDetailScreen> {
  final UniversityService _universityService = UniversityService();
  late Future<University> _futureUniversity;

  @override
  void initState() {
    super.initState();
    _futureUniversity = _universityService.getUniversityById(widget.universityId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chi tiết trường đại học")),
      body: FutureBuilder<University>(
        future: _futureUniversity,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Lỗi tải dữ liệu!"));
          } else if (!snapshot.hasData) {
            return Center(child: Text("Không tìm thấy dữ liệu"));
          }

          final uni = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Tên: ${uni.name}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text("Mã trường: ${uni.universityCode}"),
                Text("Địa điểm: ${uni.location}"),
                Text("Email: ${uni.email}"),
                Text("Số điện thoại: ${uni.phoneNumber}"),
                Text("Loại: ${uni.type}"),
                Text("Xếp hạng quốc gia: ${uni.rankingNational}"),
                Text("Xếp hạng quốc tế: ${uni.rankingInternational}"),
              ],
            ),
          );
        },
      ),
    );
  }
}
