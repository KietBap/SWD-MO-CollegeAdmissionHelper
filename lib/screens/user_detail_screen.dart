import 'package:flutter/material.dart';
import 'package:collegeadmissionhelper/models/user.dart';
import 'package:collegeadmissionhelper/services/user_service.dart';
import '../widgets/dialog_utils.dart';

class UserDetailScreen extends StatefulWidget {
  final User user;

  const UserDetailScreen({Key? key, required this.user}) : super(key: key);

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  final UserService _userService = UserService();

  Future<void> _banUser() async {
    showConfirmationDialog(
      context: context,
      title: 'Are you sure you want to ban the account ${widget.user.name}?',
      onConfirm: () async {
        try {
          await _userService.deleteUser(widget.user.id);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Account banned successfully')),
            );
            Navigator.pop(context); // Return to previous screen
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error banning account: $e')),
            );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Information")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blueAccent,
                backgroundImage: (widget.user.userImage != null &&
                        widget.user.userImage!.isNotEmpty)
                    ? NetworkImage(widget.user.userImage!)
                    : null,
                child: (widget.user.userImage == null ||
                        widget.user.userImage!.isEmpty)
                    ? const Icon(Icons.person, size: 50, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            const Text("Full name:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.user.name, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            const Text("Email:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.user.email, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            const Text("Name Account:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.user.userName, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            const Text("Phone:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.user.phoneNumber ?? "None",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: _banUser,
                icon: const Icon(Icons.block),
                label: const Text('Ban User'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}