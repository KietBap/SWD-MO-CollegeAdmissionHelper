import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  Map<String, dynamic>? decodeToken(String token) {
    try {
      final jwt = JWT.verify(
          token,
          SecretKey(
              'HT4bb6d1dfbafb64a681139d1586b6f1160d18159afd57c8c79136d7490630407c'));
      print(jwt);
      return jwt.payload;
    } catch (e) {
      print("Lỗi khi giải mã token: $e");
      return null;
    }
  }

  bool hasRole(String token, String role) {
    final payload = decodeToken(token);
    if (payload != null) {
      String? userRole = payload[
          'http://schemas.microsoft.com/ws/2008/06/identity/claims/role'];
      return userRole == role;
    }
    return false;
  }

  bool isAdmin(String token) {
    return hasRole(token, 'Admin');
  }

  String? checkUserRole(String accessToken) {
    final tokenService = TokenService();
    final payload = tokenService.decodeToken(accessToken);
    if (payload != null) {
      if (tokenService.isAdmin(accessToken)) {
        return payload[
            'http://schemas.microsoft.com/ws/2008/06/identity/claims/role'];
      } else {
        print("Người dùng không có quyền admin");
      }
    } else {
      print("Không thể giải mã token");
      return null;
    }
    return null;
  }

  String checkUserSub(String accessToken) {
    final tokenService = TokenService();
    final payload = tokenService.decodeToken(accessToken);
    if (payload != null) {
      return payload['sub'];
    } else {
      print("Không thể giải mã token");
      return '';
    }
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<String?> getRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
  }

  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? subUserName = prefs.getString('sub');

    if (subUserName != null && subUserName.isNotEmpty) {
      return subUserName;
    }
    return "Người dùng";
  }
}
