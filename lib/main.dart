import 'dart:io';
import 'package:collegeadmissionhelper/screens/chart/chart_screen_1.dart';
import 'package:collegeadmissionhelper/screens/chart/chart_screen_2.dart';
import 'package:collegeadmissionhelper/screens/chart/chart_screen_3.dart';
import 'package:collegeadmissionhelper/screens/university_list_screen.dart';
import 'package:collegeadmissionhelper/services/token_service.dart';
import 'package:flutter/material.dart';
import 'firebase/MyFirebaseMessagingService.dart';
import 'screens/chatbox_ai_screen.dart';
import 'screens/login_screen.dart';
import 'screens/main_menu_screen.dart';
import 'screens/major_manager_screen.dart';
import 'screens/user_management_screen.dart';
import 'screens/dashBoard_screen.dart';
import 'package:firebase_core/firebase_core.dart';

class PostHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

final TokenService _tokenService = TokenService();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      //options: DefaultFirebaseOptions.currentPlatform,
      );
  MyFirebaseMessagingService.initialize();
  HttpOverrides.global = PostHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    try {
      userId = await _tokenService.getUserId();
    } catch (e) {
      print('Error loading userId: $e');
      userId = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'College Admission Helper',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/mainMenu': (context) => MainMenuScreen(),
        '/users': (context) => UserManagementScreen(),
        '/dashBoard': (context) => DashBoardScreen(),
        '/chart1': (context) => ChartScreen1(),
        '/chart2': (context) => ChartScreen2(),
        '/chart3': (context) => ChartScreen3(),
        '/universities': (context) => UniversityListScreen(),
        '/chatboxAI': (context) => ChatBoxAiScreen(userId: userId),
        '/major': (context) => MajorListScreen()
      },
    );
  }
}
