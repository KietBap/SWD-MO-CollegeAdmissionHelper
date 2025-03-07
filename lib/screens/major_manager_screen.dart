import 'package:flutter/material.dart';
import 'package:collegeadmissionhelper/models/major.dart';
import 'package:collegeadmissionhelper/services/major_service.dart';

class MajorListScreen extends StatefulWidget {
  @override
  _MajorListScreenState createState() => _MajorListScreenState();
}

class _MajorListScreenState extends State<MajorListScreen> {
  final MajorService _majorService = MajorService();
  List<Major> majors = [];
  bool isLoading = false;
  bool isAscending = true;
  String? sortBy = "name";

  final TextEditingController _majorNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMajors();
  }

  Future<void> fetchMajors({String? majorName}) async {
    setState(() => isLoading = true);
    try {
      final response = await _majorService.getAllMajors(majorName);
      List<Major> listMajors = response;
      if (sortBy == "name") {
        listMajors.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      }

      if (!isAscending) {
        listMajors = listMajors.reversed.toList();
      }
      setState(() {
        majors = listMajors;
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
    fetchMajors(
      majorName:
          _majorNameController.text.isNotEmpty ? _majorNameController.text : null,
    );
  }

  void clearFilters() {
    _majorNameController.clear();
    setState(() {
      sortBy = null;
      isAscending = true;
      isLoading = false;
    });
    fetchMajors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh sách ngành học"),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.sort),
            onSelected: (String value) {
              setState(() {
                sortBy = value;
                fetchMajors();
              });
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: "name",
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      child: sortBy == "name"
                          ? Icon(Icons.check, color: Colors.blue)
                          : null,
                    ),
                    SizedBox(width: 8),
                    Text("Sắp xếp theo tên ngành"),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(isAscending ? Icons.arrow_upward : Icons.arrow_downward),
            onPressed: () {
              setState(() {
                isAscending = !isAscending;
                fetchMajors();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  TextField(
                    controller: _majorNameController,
                    decoration: InputDecoration(
                      labelText: "Tên ngành",
                      prefixIcon: Icon(Icons.book),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
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
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
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
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
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
                : majors.isEmpty
                    ? Center(child: Text("Không có ngành nào"))
                    : ListView.builder(
                        itemCount: majors.length,
                        itemBuilder: (context, index) {
                          var major = majors[index];
                          return Card(
                            elevation: 3,
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              leading:
                                  Icon(Icons.book, color: Colors.blueAccent),
                              title: Text(
                                major.name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text("Kỹ năng liên quan: ${major.relatedSkills}"),
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
