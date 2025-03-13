import 'package:flutter/material.dart';
import 'package:collegeadmissionhelper/models/major.dart';
import 'package:collegeadmissionhelper/services/major_service.dart';

import '../widgets/dialog_utils.dart';
import '../widgets/snackbar_utils.dart';
import '../widgets/widget_utils.dart';

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

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _majorNameController = TextEditingController();
  final TextEditingController _relatedSkillsController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMajors();
    _searchController.addListener(() {
      fetchMajors(majorName: _searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _majorNameController.dispose();
    _relatedSkillsController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
      if (mounted)
        showSnackBar(context, "Lỗi khi tải dữ liệu: $e", isError: true);
    }
  }

  void showMajorDialog({Major? major}) {
    _majorNameController.text = major?.name ?? "";
    _relatedSkillsController.text = major?.relatedSkills ?? "";
    _descriptionController.text = major?.description ?? "";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          major == null ? "Thêm ngành học" : "Cập nhật ngành học",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTextField(_majorNameController, "Tên ngành"),
              buildTextField(_relatedSkillsController, "Kỹ năng liên quan"),
              buildTextField(_descriptionController, "Mô tả", maxLines: 3),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              showConfirmationDialog(
                context: context,
                title: major == null
                    ? "Xác nhận thêm ngành học?"
                    : "Xác nhận cập nhật?",
                onConfirm: () async {
                  if (major == null) {
                    await createMajor();
                  } else {
                    await updateMajor(major.id);
                  }
                  if (mounted) Navigator.pop(context);
                },
              );
            },
            child: Text(major == null ? "Thêm" : "Cập nhật"),
          ),
        ],
      ),
    );
  }

  Future<void> createMajor() async {
    if (_majorNameController.text.isEmpty) {
      if (mounted) {
        showSnackBar(context, "Vui lòng nhập tên ngành", isError: true);
      }
      return;
    }

    try {
      final newMajor = Major(
        name: _majorNameController.text,
        relatedSkills: _relatedSkillsController.text,
        description: _descriptionController.text, id: '',
      );
      await _majorService.createMajor(newMajor);
      await fetchMajors(majorName: _searchController.text);
      if (mounted) showSnackBar(context, "Thêm ngành học thành công");
    } catch (e) {
      if (mounted) {
        showSnackBar(context, "Lỗi khi thêm ngành: $e", isError: true);
      }
    }
  }

  Future<void> updateMajor(String id) async {
    if (_majorNameController.text.isEmpty) {
      if (mounted) {
        showSnackBar(context, "Vui lòng nhập tên ngành", isError: true);
      }
      return;
    }

    try {
      final updatedMajor = Major(
        name: _majorNameController.text,
        relatedSkills: _relatedSkillsController.text,
        description: _descriptionController.text, id: '',
      );
      await _majorService.updateMajor(id, updatedMajor);
      await fetchMajors(majorName: _searchController.text);
      if (mounted) showSnackBar(context, "Cập nhật ngành học thành công");
    } catch (e) {
      if (mounted) showSnackBar(context, "Lỗi khi cập nhật: $e", isError: true);
    }
  }

  Future<void> deleteMajor(String id) async {
    showConfirmationDialog(
      context: context,
      title: "Bạn có chắc chắn muốn xóa ngành học này?",
      onConfirm: () async {
        try {
          await _majorService.deleteMajor(id);
          await fetchMajors(majorName: _searchController.text);
          if (mounted) showSnackBar(context, "Xóa ngành học thành công");
        } catch (e) {
          if (mounted) showSnackBar(context, "Lỗi khi xóa: $e", isError: true);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Danh sách ngành học",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort, color: Colors.black),
            onSelected: (String value) {
              setState(() {
                sortBy = value;
                fetchMajors(majorName: _searchController.text);
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
                          ? const Icon(Icons.check, color: Colors.blue)
                          : null,
                    ),
                    const SizedBox(width: 8),
                    const Text("Sắp xếp theo tên ngành"),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              isAscending ? Icons.arrow_upward : Icons.arrow_downward,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                isAscending = !isAscending;
                fetchMajors(majorName: _searchController.text);
              });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => showMajorDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Tìm kiếm ngành học...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : majors.isEmpty
                    ? const Center(
                        child: Text(
                          "Không tìm thấy ngành nào",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: majors.length,
                        itemBuilder: (context, index) {
                          final major = majors[index];
                          return buildMajorCard(
                            major: major,
                            onTap: () => showMajorDialog(major: major),
                            onDelete: () => deleteMajor(major.id),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
