import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  Map<String, dynamic>? decodeToken(String token) {
    try {
      final jwt = JWT.verify(
          token,
          SecretKey(
              'HT4bb6d1dfbafb64a681139d1586b6f1160d18159afd57c8c79136d7490630407c'));
      return jwt.payload;
    } catch (e) {
      print("Lỗi khi giải mã token: $e");
      return null;
    }
  }

  Future<String?> getUserRole() async {
    String? accessToken = await getToken();
    if (accessToken == null) return null;

    final payload = decodeToken(accessToken);
    return payload?[
        'http://schemas.microsoft.com/ws/2008/06/identity/claims/role'];
  }

  Future<bool> isAdmin() async {
    return await getUserRole() == 'Admin';
  }

  String? checkUserName(String accessToken) {
    final payload = decodeToken(accessToken);
    return payload?['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name'];
  }

  String? checkUserId(String accessToken) {
    final payload = decodeToken(accessToken);
    return payload?['userId'];
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<String?> getRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
  }

  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? subUserName = prefs.getString('name');

    if (subUserName != null && subUserName.isNotEmpty) {
      return subUserName;
    }
    return "Người dùng";
  }
}
