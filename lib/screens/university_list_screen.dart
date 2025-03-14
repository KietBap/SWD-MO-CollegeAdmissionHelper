import 'package:collegeadmissionhelper/widgets/widget_utils.dart';
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
  bool isAscending = true;
  String? sortBy = "name";

  final TextEditingController _uniCodeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    fetchUniversities();
  }

  Future<void> fetchUniversities(
      {String? uniCode, String? type, String? location}) async {
    setState(() => isLoading = true);
    try {
      final response = await _universityService.getAllUniversities(
        uniCode: uniCode,
        type: type,
        location: location,
      );
      List<University> listUniversities = response.items;
      if (sortBy == "name") {
        listUniversities.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      } else if (sortBy == "code") {
        listUniversities.sort(
            (a, b) => a.email.toLowerCase().compareTo(b.email.toLowerCase()));
      }

      if (!isAscending) {
        listUniversities = listUniversities.reversed.toList();
      }
      setState(() {
        universities = listUniversities;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading data: $e")),
      );
    }
  }

  void applyFilter() {
    fetchUniversities(
      uniCode:
          _uniCodeController.text.isNotEmpty ? _uniCodeController.text : null,
      type: _selectedType,
      location:
          _locationController.text.isNotEmpty ? _locationController.text : null,
    );
  }

  void clearFilters() {
    _uniCodeController.clear();
    _locationController.clear();
    setState(() {
      sortBy = null;
      isAscending = true;
      isLoading = false;
    });
    fetchUniversities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("University Management"),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.sort), 
            onSelected: (String value) {
              setState(() {
                sortBy = value;
                fetchUniversities();
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
                    Text("Sort by name"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: "code",
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      child: sortBy == "code"
                          ? Icon(Icons.check, color: Colors.blue)
                          : null,
                    ),
                    SizedBox(width: 8),
                    Text("Sort by code"),
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
                fetchUniversities();
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
                    controller: _uniCodeController,
                    decoration: InputDecoration(
                      labelText: "University Code",
                      prefixIcon: Icon(Icons.code),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedType,
                    items: ["State", "Private", "International"]
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: _selectedType == null ? "Type" : "",
                      prefixIcon: Icon(Icons.category),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: "Location",
                      prefixIcon: Icon(Icons.location_on),
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
                          label: Text("Filter"),
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
                          label: Text("Clear"),
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
                : universities.isEmpty
                    ? Center(child: Text("No fields available"))
                    : ListView.builder(
                        itemCount: universities.length,
                        itemBuilder: (context, index) {
                          var uni = universities[index];
                          return buildUniversityCard(
                            university: uni,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UniversityDetailScreen(
                                      universityId: uni.id),
                                ),
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
