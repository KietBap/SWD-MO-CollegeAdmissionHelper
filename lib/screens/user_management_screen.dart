import 'package:flutter/material.dart';
import 'package:collegeadmissionhelper/models/user.dart';
import 'package:collegeadmissionhelper/services/user_service.dart';
import 'user_detail_screen.dart';

class UserManagementScreen extends StatefulWidget {
  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final UserService _userService = UserService();
  List<User> users = [];
  bool isLoading = true;
  bool isAscending = true;
  String? sortBy = "name";

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers({String? email, String? phoneNumber}) async {
    setState(() => isLoading = true);
    try {
      var response = await _userService.getAllUser(
        email: email,
        phoneNumber: phoneNumber,
        page: 1,
        pageSize: 10,
      );
      List<User> listUsers = response.items;
      if (sortBy == "name") {
        listUsers.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      } else if (sortBy == "email") {
        listUsers.sort(
            (a, b) => a.email.toLowerCase().compareTo(b.email.toLowerCase()));
      }
      setState(() {
        users = response.items;
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
    fetchUsers(
      email: _emailController.text.isNotEmpty ? _emailController.text : null,
      phoneNumber:
          _phoneController.text.isNotEmpty ? _phoneController.text : null,
    );
  }

  void clearFilters() {
    _emailController.clear();
    _phoneController.clear();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Management"),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.sort),
            onSelected: (String value) {
              setState(() {
                sortBy = value;
                fetchUsers();
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
                    Text("Sort by Name"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: "email",
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      child: sortBy == "email"
                          ? Icon(Icons.check, color: Colors.blue)
                          : null,
                    ),
                    SizedBox(width: 8),
                    Text("Sort by Email"),
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
                fetchUsers();
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
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: "Phone",
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    keyboardType: TextInputType.phone,
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
                : users.isEmpty
                    ? Center(child: Text("No users"))
                    : ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          var user = users[index];
                          return Card(
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blueAccent,
                                backgroundImage: (user.userImage != null &&
                                        user.userImage!.isNotEmpty)
                                    ? NetworkImage(user.userImage!)
                                    : null,
                                child: (user.userImage == null ||
                                        user.userImage!.isEmpty)
                                    ? Icon(Icons.person, color: Colors.white)
                                    : null,
                              ),
                              title: Text(
                                user.name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(user.email),
                              trailing: Icon(Icons.arrow_forward_ios,
                                  color: Colors.grey),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UserDetailScreen(user: user),
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
