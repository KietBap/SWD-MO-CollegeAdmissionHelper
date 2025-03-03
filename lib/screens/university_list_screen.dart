import 'package:flutter/material.dart';
import 'package:collegeadmissionhelper/models/university.dart';
import 'package:collegeadmissionhelper/services/university_service.dart';
import 'university_detail_screen.dart';

class UniversityListScreen extends StatefulWidget {
  @override
  _UniversityListScreenState createState() => _UniversityListScreenState();
}

class _UniversityListScreenState extends State<UniversityListScreen> {
  final UniversityService _universityService = UniversityService();
  List<University> universities = [];
  bool isLoading = false;

  final TextEditingController _uniCodeController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUniversities();
  }

  Future<void> fetchUniversities({String? uniCode, String? type, String? location}) async {
    setState(() => isLoading = true);
    try {
      final response = await _universityService.getAllUniversities(
        uniCode: uniCode,
        type: type,
        location: location,
      );
      setState(() {
        universities = response.items;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi khi tải dữ liệu: $e")),
      );
    }
  }

  void applyFilter() {
    fetchUniversities(
      uniCode: _uniCodeController.text.isNotEmpty ? _uniCodeController.text : null,
      type: _typeController.text.isNotEmpty ? _typeController.text : null,
      location: _locationController.text.isNotEmpty ? _locationController.text : null,
    );
  }

  void clearFilters() {
    _uniCodeController.clear();
    _typeController.clear();
    _locationController.clear();
    fetchUniversities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Danh sách các trường đại học")),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  TextField(
                    controller: _uniCodeController,
                    decoration: InputDecoration(
                      labelText: "Mã trường",
                      prefixIcon: Icon(Icons.code),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _typeController,
                    decoration: InputDecoration(
                      labelText: "Loại hình",
                      prefixIcon: Icon(Icons.category),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: "Địa điểm",
                      prefixIcon: Icon(Icons.location_on),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: applyFilter,
                          icon: Icon(Icons.search),
                          label: Text("Lọc"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: clearFilters,
                          icon: Icon(Icons.clear),
                          label: Text("Xóa lọc"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : universities.isEmpty
                    ? Center(child: Text("Không có trường nào"))
                    : ListView.builder(
                        itemCount: universities.length,
                        itemBuilder: (context, index) {
                          var uni = universities[index];
                          return Card(
                            elevation: 3,
                            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              leading: Icon(Icons.school, color: Colors.blueAccent),
                              title: Text(
                                uni.name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text("Mã trường: ${uni.universityCode} - Địa điểm: ${uni.location}"),
                              trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UniversityDetailScreen(universityId: uni.id),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
