import 'package:collegeadmissionhelper/services/token_service.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final TokenService _tokenService = TokenService();
  final Dio _dio = Dio(
    BaseOptions(
      headers: {
        'Accept-Encoding': 'gzip',
      },
      baseUrl:
          "https://swpproject-egd0b4euezg4akg7.southeastasia-01.azurewebsites.net", 
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 5),
    ),
  );

  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print("Đăng nhập bị hủy bởi người dùng");
        return false;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;
      String? firebaseToken = await user?.getIdToken();

      if (firebaseToken != null) {
        bool success = await sendTokenToBackend(firebaseToken);
        return success;
      } else {
        print("Không thể lấy Firebase ID Token");
        return false;
      }
    } catch (e) {
      print("Lỗi đăng nhập: $e");
      return false;
    }
  }

  Future<bool> sendTokenToBackend(String firebaseToken) async {
    //const String backendUrl = "https://10.0.2.2:7286/api/auth/login-google";
    const String backendUrl =
        "https://swpproject-egd0b4euezg4akg7.southeastasia-01.azurewebsites.net/api/auth/login-google";
    try {
      var response = await _dio.post(
        backendUrl,
        data: {"token": firebaseToken},
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      if (response.statusCode == 200) {
        String accessToken = response.data["accessToken"];
        String refreshToken = response.data["refreshToken"];
        String sub = _tokenService.checkUserSub(accessToken);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', accessToken);
        await prefs.setString('refreshToken', refreshToken);
        await prefs.setString('sub', sub);

        return true;
      } else {
        print("Lỗi từ backend: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Lỗi khi gửi token lên backend: $e");
      return false;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
