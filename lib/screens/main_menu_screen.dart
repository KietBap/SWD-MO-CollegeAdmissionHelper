import 'package:collegeadmissionhelper/services/token_service.dart';
import 'package:collegeadmissionhelper/services/user_service.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import 'profile_screen.dart';

class MainMenuScreen extends StatelessWidget {
  final TokenService _tokenService = TokenService();
  final UserService _userService = UserService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User menu"),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, size: 32),
            onPressed: () => _navigateToProfile(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder<String?>(
          future: _tokenService.getUserName(),
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("An error occurred!"));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text("Username not found!"));
            } else {
              String userName = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Hi, $userName", style: TextStyle(fontSize: 20)),
                  SizedBox(height: 20),
                  FutureBuilder<String?>(
                    future: _tokenService.getUserRole(),
                    builder: (context, roleSnapshot) {
                      if (roleSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (roleSnapshot.hasError ||
                          !roleSnapshot.hasData) {
                        return Center(
                            child: Text("Unable to determine role!"));
                      }

                      String? role = roleSnapshot.data;
                      bool isAdmin = role == 'Admin';

                      return GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        children: [
                          _buildCard("User Management", Icons.people,
                              context, '/users', isAdmin),
                          _buildCard("Dashboard", Icons.bar_chart, context,
                              '/dashBoard', isAdmin),
                          _buildCard("University Management", Icons.school,
                              context, '/universities', true),
                          _buildCard("Chat With AI", Icons.smart_toy, context,
                              '/chatboxAI', true),
                          _buildCard("Major Management", Icons.book, context,
                              '/major', true),
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
        title: Text("Notification"),
        content: Text("You do not have access !"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToProfile(BuildContext context) async {
    String? userId = await _tokenService.getUserId();

    if (userId != null) {
      try {
        User user = await _userService.getUserById(userId);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(user: user),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading user information')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('UserId not found')),
      );
    }
  }
}
