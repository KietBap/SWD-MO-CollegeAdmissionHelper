import 'package:flutter/material.dart';
import 'package:collegeadmissionhelper/models/user.dart';
import 'package:collegeadmissionhelper/services/login_service.dart';
import 'package:collegeadmissionhelper/services/user_service.dart';
import '../services/google_signIn_service.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({required this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GoogleAuthService _googleAuthService = GoogleAuthService();
  final LoginService _loginService = LoginService();
  final UserService _userService = UserService();
  late TextEditingController _userNameController;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _userImageController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController(text: widget.user.userName);
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phoneNumber);
    _userImageController = TextEditingController(text: widget.user.userImage);
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _userImageController.dispose();
    super.dispose();
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await _googleAuthService.signOut();
      await _loginService.logout();
      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi đăng xuất: $e")),
      );
    }
  }

  Future<void> _updateProfile() async {
    try {
      final updatedUser = User(
        id: widget.user.id, 
        userName: _userNameController.text,
        name: _nameController.text,
        email: _emailController.text,
        phoneNumber: widget.user.phoneNumber, 
        userImage: widget.user.userImage,   
      );
      
      await _userService.updateUser(widget.user.id!, updatedUser);
      setState(() {
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Cập nhật hồ sơ thành công")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi cập nhật hồ sơ: $e")),
      );
    }
  }

  Future<void> _deleteAccount() async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Xác nhận xóa tài khoản"),
        content: Text("Bạn có chắc chắn muốn xóa tài khoản? Hành động này không thể hoàn tác."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Hủy"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Xóa", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _userService.deleteUser(widget.user.id!);
        await _logout(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Đã xóa tài khoản thành công")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi xóa tài khoản: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hồ sơ cá nhân"),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
        ],
      ),
      body: SingleChildScrollView( 
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: widget.user.userImage != null && widget.user.userImage!.isNotEmpty
                  ? CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(widget.user.userImage!),
                    )
                  : CircleAvatar(
                      radius: 50,
                      child: Icon(Icons.account_circle, size: 50),
                    ),
            ),
            SizedBox(height: 20),
            _isEditing
                ? TextField(
                    controller: _userNameController,
                    decoration: InputDecoration(labelText: "Tên người dùng"),
                  )
                : Text("Tên người dùng: ${widget.user.userName}", 
                    style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            _isEditing
                ? TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: "Tên"),
                  )
                : Text("Tên: ${widget.user.name ?? 'Chưa có'}", 
                    style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            _isEditing
                ? TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: "Email"),
                    keyboardType: TextInputType.emailAddress,
                  )
                : Text("Email: ${widget.user.email}", 
                    style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            _isEditing
                ? const SizedBox.shrink()
                : Text("Số điện thoại: ${widget.user.phoneNumber ?? 'Chưa có'}", 
                    style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            _isEditing
                ?  const SizedBox.shrink()
                : SizedBox(),  
            if (_isEditing) ...[
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _updateProfile,
                    child: Text("Lưu"),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => setState(() => _isEditing = false),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    child: Text("Hủy"),
                  ),
                ],
              ),
            ],
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _logout(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: Text("Đăng xuất",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: _deleteAccount,
              child: Text("Xóa tài khoản", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}