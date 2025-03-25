import 'dart:convert';

import 'package:collegeadmissionhelper/services/token_service.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatService {
  TokenService _tokenService = TokenService();
  final Dio _dio = Dio(BaseOptions(
    headers: {
      'Accept-Encoding': 'gzip',
      'accept': 'text/plain',
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

  Future<void> sendMessage(String text, String userId) async {
    try {
      List<Map<String, dynamic>> chatHistory = await _getChatHistory(userId);
      print("Chat History: ${jsonEncode(chatHistory)}");

      var response = await _dio.post(
        "/gemini",
        queryParameters: {"prompt": text},
        data: jsonEncode(chatHistory),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        var data = response.data;
        print("Response: $data");
        return data;
      } else {
        print(
            "Status code: ${response.statusCode}, Response: ${response.data}");
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

  Future<List<Map<String, dynamic>>> _getChatHistory(String userId) async {
    try {
      final snapshot = await _db.child(userId).once();
      if (snapshot.snapshot.value != null) {
        Map<dynamic, dynamic> chatData = snapshot.snapshot.value as Map;
        List<Map<String, dynamic>> allMessages = [];
        chatData.forEach((sessionId, sessionData) {
          Map<dynamic, dynamic> messages = sessionData['messages'];
          messages.forEach((messageId, messageData) {
            allMessages.add({
              'sender': messageData['Sender'],
              'message': messageData['Text'],
              'timestamp': messageData['Timestamp'],
            });
          });
        });
        allMessages.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
        return allMessages.length > 3
            ? allMessages.sublist(0, 3) 
            : allMessages;
      }
      return [];
    } catch (e) {
      print("Error fetching chat history: $e");
      return [];
    }
  }
}
