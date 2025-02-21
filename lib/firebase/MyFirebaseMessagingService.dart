import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MyFirebaseMessagingService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static late AndroidNotificationChannel channel;

  static Future<void> initialize() async {
  // 🛠️ Yêu cầu quyền thông báo (Android 13+)
  NotificationSettings settings = await _firebaseMessaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('🔔 Notification permission: ${settings.authorizationStatus}');

  // 🛠️ Khởi tạo kênh thông báo cho Android
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // ID kênh
    'High Importance Notifications', // Tên kênh
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  // Đăng ký kênh với hệ thống Android
  await _flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // Cấu hình Flutter Local Notifications
  var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
    print("🔔 Notification tapped: ${response.payload}");
  });

  // Lắng nghe thông báo khi ứng dụng đang mở
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("📩 Received notification: ${message.notification?.title}");
    _showNotification(message);
  });

  // Khi người dùng nhấn vào thông báo và ứng dụng mở
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("🔔 Notification clicked: ${message.data}");
  });

  // Khi ứng dụng mở từ trạng thái bị đóng
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      print("🚀 App opened from notification: ${message.data}");
    }
  });
}


  static Future<void> _showNotification(RemoteMessage message) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      channel.id, // ID kênh phải trùng khớp
      channel.name,
      channelDescription: channel.description,
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0, // ID thông báo
      message.notification?.title ?? "No Title",
      message.notification?.body ?? "No Body",
      platformChannelSpecifics,
      payload: message.data.toString(),
    );
  }
}
