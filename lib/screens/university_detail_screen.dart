import 'package:flutter/material.dart';
import 'package:collegeadmissionhelper/models/uni_major.dart';
import 'package:collegeadmissionhelper/models/university.dart';
import 'package:collegeadmissionhelper/services/university_service.dart';

class UniversityDetailScreen extends StatefulWidget {
  final String universityId;

  const UniversityDetailScreen({required this.universityId, super.key});

  @override
  _UniversityDetailScreenState createState() => _UniversityDetailScreenState();
}

class _UniversityDetailScreenState extends State<UniversityDetailScreen> {
  final UniversityService _universityService = UniversityService();
  late Future<University?> _universityFuture;

  @override
  void initState() {
    super.initState();
    _refreshFuture(widget.universityId);
  }

  @override
  void didUpdateWidget(UniversityDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.universityId != widget.universityId) {
      _refreshFuture(widget.universityId);
    }
  }

  void _refreshFuture(String universityId) {
    _universityFuture = _universityService.getUniversityById(universityId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chi tiết Trường Đại Học")),
      body: FutureBuilder<University?>(
        future: _universityFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print("Error: ${snapshot.error}");
            return Center(
              child: Text(
                "Lỗi: ${snapshot.error.toString()}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Không tìm thấy dữ liệu"));
          }

          final University uni = snapshot.data!;
          final List<UniMajor> majors = uni.majors;
          
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (uni.image.isNotEmpty && Uri.tryParse(uni.image)?.hasAuthority == true)
                    ? Image.network(
                        uni.image,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 200,
                          color: Colors.grey[300],
                          child: const Center(child: Text("Lỗi tải hình ảnh")),
                        ),
                      )
                    : Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Center(child: Text("Không có hình ảnh")),
                      ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        uni.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildInfoRow("Mã trường", uni.universityCode),
                      _buildInfoRow("Địa điểm", uni.location),
                      _buildInfoRow("Email", uni.email),
                      _buildInfoRow("Số điện thoại", uni.phoneNumber),
                      _buildInfoRow("Loại", uni.type),
                      _buildInfoRow("Xếp hạng quốc gia", uni.rankingNational.toString()),
                      _buildInfoRow("Xếp hạng quốc tế", uni.rankingInternational.toString()),
                      const SizedBox(height: 20),
                      const Divider(thickness: 2),
                      const SizedBox(height: 10),
                      const Text(
                        "Chuyên ngành",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      majors.isEmpty
                          ? const Center(child: Text("Không có chuyên ngành nào."))
                          : SizedBox(
                              height: 300,
                              child: ListView.builder(
                                itemCount: majors.length,
                                itemBuilder: (context, index) {
                                  final major = majors[index];
                                  return Card(
                                    margin: const EdgeInsets.symmetric(vertical: 8),
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.school, color: Colors.blueAccent, size: 30),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  major.majorName,
                                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (major.tuitionFee.isNotEmpty)
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8),
                                              child: Text(
                                                "Học phí: ${major.tuitionFee}",
                                                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                              ),
                                            ),
                                          if (major.majorCode.isNotEmpty)
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8),
                                              child: Text(
                                                "Mã ngành: ${major.majorCode}",
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.blueGrey,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text("$label: $value", style: const TextStyle(fontSize: 16)),
    );
  }
}