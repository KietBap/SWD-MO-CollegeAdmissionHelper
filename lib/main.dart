import 'package:collegeadmissionhelper/screens/chart/chart_screen_1.dart';
import 'package:collegeadmissionhelper/screens/chart/chart_screen_2.dart';
import 'package:collegeadmissionhelper/screens/chart/chart_screen_3.dart';
import 'package:collegeadmissionhelper/screens/university_list_screen.dart';
import 'package:flutter/material.dart';
import 'firebase/MyFirebaseMessagingService.dart';
import 'screens/login_screen.dart';
import 'screens/main_menu_screen.dart';
import 'screens/user_management_screen.dart';
import 'screens/dashBoard_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  getFCMToken();
  MyFirebaseMessagingService.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'College Admission Helper',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(), //màn hình mặc định
        '/mainMenu': (context) => MainMenuScreen(),
        '/users': (context) => UserManagementScreen(),
        '/dashBoard': (context) => DashBoardScreen(),
        '/chart1': (context) => ChartScreen1(),
        '/chart2': (context) => ChartScreen2(),
        '/chart3': (context) => ChartScreen3(),
        '/universities': (context) => UniversityListScreen(),
      },
    );
  }
}


Future<void> getFCMToken() async {
  String? token = await FirebaseMessaging.instance.getToken();
  print("FCM Token: $token");
}


