import 'package:flutter/material.dart';
import 'package:collegeadmissionhelper/models/major.dart';
import 'package:collegeadmissionhelper/services/major_service.dart';

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
        showSnackBar(context, "Error loading data: $e", isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Major Management",
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
                    const Text("Sort by Name"),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search major...",
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
                          "Not found",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: majors.length,
                        itemBuilder: (context, index) {
                          final major = majors[index];
                          return buildMajorCard(
                            major: major
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}