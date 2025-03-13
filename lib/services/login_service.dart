import 'package:collegeadmissionhelper/services/token_service.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  final TokenService _tokenService = TokenService();
  final Dio _dio = Dio(BaseOptions(
    headers: {
      'Accept-Encoding': 'gzip',
    },
    baseUrl:
        "https://swpproject-egd0b4euezg4akg7.southeastasia-01.azurewebsites.net/api/auth"
  ));
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<bool> login(String username, String password) async {
    try {
      var response = await _dio.post(
        '/auth-account',
        data: {
          "username": username,
          "password": password,
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );
      

      if (response.statusCode == 200) {
        String accessToken = response.data["accessToken"];
        String? userId = _tokenService.checkUserId(accessToken);
        String? name = _tokenService.checkUserName(accessToken);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', accessToken);
        await prefs.setString('name', name!);
        await prefs.setString('userId', userId!);
        
        print('Ma user lgon ${userId}');
        await _registerOrLoginFirebase(userId, name, password);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Lỗi đăng nhập: $e");
      return false;
    }
  }

   Future<void> _registerOrLoginFirebase(String userId, String name, String pass) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: "$userId@myapp.com",
        password: "defaultPassword123@$pass", 
      );
      print("Đăng nhập Firebase thành công: ${userCredential.user?.uid}");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        UserCredential newUser = await _auth.createUserWithEmailAndPassword(
          email: "$userId@myapp.com",
          password: "defaultPassword123@$pass",
        );
        await newUser.user?.updateDisplayName(name);
        print("Tạo tài khoản Firebase thành công: ${newUser.user?.uid}");
      } else {
        print("Lỗi Firebase Auth: ${e.code}");
      }
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
