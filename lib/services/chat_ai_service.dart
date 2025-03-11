import 'package:collegeadmissionhelper/services/token_service.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatService {
  TokenService _tokenService = TokenService();
  final Dio _dio = Dio(BaseOptions(
    headers: {
      'Accept-Encoding': 'gzip',
    },
    baseUrl:
        "https://swpproject-egd0b4euezg4akg7.southeastasia-01.azurewebsites.net/api",
  ));

  ChatService() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? token = await _tokenService.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  final DatabaseReference _db = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://collegeadmissionhelper.asia-southeast1.firebasedatabase.app/',
  ).ref().child('ChatHistory');

  Future<void> sendMessage(String text) async {
    try {
      var response =
          await _dio.get("/gemini", queryParameters: {"prompt": text});
      if (response.statusCode == 200) {
        var data = response.data;
        return data;
      } else {
        return;
      }
    } catch (e) {
      print("Error: $e");
      return;
    }
  }

  Stream<DatabaseEvent>? getMessages(String? userId) {
    if (userId == null) {
      return null;
    }
    return _db.child(userId).onValue;
  }
}
