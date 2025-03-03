import 'package:flutter/material.dart';
import 'package:collegeadmissionhelper/models/university.dart';
import 'package:collegeadmissionhelper/models/major.dart';
import 'package:collegeadmissionhelper/services/university_service.dart';
import 'package:collegeadmissionhelper/services/major_service.dart';

class UniversityDetailScreen extends StatefulWidget {
  final String universityId;
  UniversityDetailScreen({required this.universityId});

  @override
  _UniversityDetailScreenState createState() => _UniversityDetailScreenState();
}

class _UniversityDetailScreenState extends State<UniversityDetailScreen> {
  final UniversityService _universityService = UniversityService();
  final MajorService _majorService = MajorService();

  late Future<List<dynamic>> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = Future.wait([
      _universityService.getUniversityById(widget.universityId),
      _majorService.getMajors(widget.universityId)
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chi tiết Trường Đại Học")),
      body: FutureBuilder<List<dynamic>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Loading chung
          } else if (snapshot.hasError) {
            return Center(child: Text("Lỗi tải dữ liệu! Vui lòng thử lại."));
          } else if (!snapshot.hasData || snapshot.data!.length < 2) {
            return Center(child: Text("Không tìm thấy dữ liệu"));
          }

          final University uni = snapshot.data![0];
          final List<Major> majors = snapshot.data![1];

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  uni.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                ),
                SizedBox(height: 10),
                Text("Mã trường: ${uni.universityCode}", style: TextStyle(fontSize: 16)),
                Text("Địa điểm: ${uni.location}", style: TextStyle(fontSize: 16)),
                Text("Email: ${uni.email}", style: TextStyle(fontSize: 16)),
                Text("Số điện thoại: ${uni.phoneNumber}", style: TextStyle(fontSize: 16)),
                Text("Loại: ${uni.type}", style: TextStyle(fontSize: 16)),
                Text("Xếp hạng quốc gia: ${uni.rankingNational}", style: TextStyle(fontSize: 16)),
                Text("Xếp hạng quốc tế: ${uni.rankingInternational}", style: TextStyle(fontSize: 16)),
                SizedBox(height: 20),
                Divider(thickness: 2),
                SizedBox(height: 10),
                Text("Chuyên ngành", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

                if (majors.isEmpty)
                  Center(child: Text("Không có chuyên ngành nào."))
                else
                  Column(
                    children: majors.map((major) {
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.school, color: Colors.blueAccent, size: 30),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      major.name,
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              if (major.description != null && major.description!.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text("Mô tả: ${major.description}", style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                                ),
                              if (major.relatedSkills != null && major.relatedSkills!.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Text("Kỹ năng liên quan: ${major.relatedSkills}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.blueGrey)),
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
