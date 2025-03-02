import 'package:collegeadmissionhelper/services/token_service.dart';
import 'package:flutter/material.dart';

class MainMenuScreen extends StatelessWidget {
  final TokenService _tokenService = TokenService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Menu người dùng")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder<String?>(
          future: _tokenService.getUserName(),
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Có lỗi xảy ra!"));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text("Không tìm thấy tên người dùng!"));
            } else {
              String userName = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Xin chào, $userName", style: TextStyle(fontSize: 20)),
                  SizedBox(height: 20),
                  FutureBuilder<String?>(
                    future:
                        _tokenService.getUserRole(), 
                    builder: (context, roleSnapshot) {
                      if (roleSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (roleSnapshot.hasError ||
                          !roleSnapshot.hasData) {
                        return Center(
                            child: Text("Không thể xác định vai trò!"));
                      }

                      String? role = roleSnapshot.data;
                      bool isAdmin = role == 'Admin';

                      return GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        children: [
                          _buildCard("Quản lý người dùng", Icons.people,
                              context, '/users', isAdmin),
                          _buildCard("Dashboard", Icons.bar_chart, context,
                              '/dashBoard', isAdmin),
                          _buildCard("Danh sách trường Đại học", Icons.school,
                              context, '/universities', true),
                        ],
                      );
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildCard(String title, IconData icon, BuildContext context,
      String route, bool canAccess) {
    return GestureDetector(
      onTap: () {
        if (canAccess) {
          Navigator.pushNamed(context, route);
        } else {
          _showAccessDeniedDialog(context);
        }
      },
      child: Card(
        elevation: 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            SizedBox(height: 10),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  void _showAccessDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Thông báo"),
        content: Text("Bạn không có quyền truy cập vào mục này."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}
