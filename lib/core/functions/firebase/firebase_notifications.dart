import 'package:bank_app/controller/app/home_controller.dart';
import 'package:bank_app/data/datasource/remote/auth/send_fcm_token_remote.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
import 'package:get/get.dart';

class FirebaseNotifications {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications',
    importance: Importance.high,
    playSound: true,
  );


  static Future<void> initNotifications() async {
    await Firebase.initializeApp();

    if (Platform.isIOS) {
      await _messaging.requestPermission(alert: true, badge: true, sound: true);
    }

    
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    // تهيئة الإشعارات المحلية
    await _flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );

    
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  print("📩 message.notification: ${message.notification}");
  print("📩 message.data: ${message.data}");

      _showNotification(message);
      _increaseControllerUnreadCount();
    });
      
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


    
 // حالة التطبيق كان مغلق تماماً وفتح من إشعار
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
       _increaseControllerUnreadCount();
    }

   
    String? token = await _messaging.getToken();
    print('📌 FCM Token:$token');

   
    if (token != null) {
      await sendTokenToBackend(token);
    }

 
    _messaging.onTokenRefresh.listen((newToken) async {
      print('🔄 Token updated: $newToken');
      await sendTokenToBackend(newToken);
    });
  }

  static Future<void> sendTokenToBackend(String token) async {
    try {
      await SendFcmTokenRemote().postData(fcm: token);
    } catch (e) {
      print("❌ خطأ بإرسال الـ FCM Token: $e");
    }
  }

 static Future<void> _showNotification(RemoteMessage message) async {
  String title = '';
  String body = '';

  print("📩 RemoteMessage: ${message.data}");
  print("📩 Notification payload: ${message.notification}");


  if (message.notification != null) {
    title = message.notification?.title ?? '';
    body = message.notification?.body ?? '';
  }

  if (message.data.isNotEmpty) {
    title = message.data['title'] ?? title;
    body = message.data['body'] ?? body;
  }

  if (title.isNotEmpty || body.isNotEmpty) {
    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          playSound: true,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
    );
    print("✅ إشعار محلي معروض: $title / $body");
  } else {
    print("⚠️ لا يوجد عنوان أو نص للإشعار.");
  }
}

static void _increaseControllerUnreadCount() {
    if (Get.isRegistered<HomeController>()) {
      final homeController = Get.find<HomeController>();
           homeController.unreadCount.value++; 

    }
  }
  /// هندل إشعار بالخلفية
  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    await Firebase.initializeApp();
    await _showNotification(message);
  }

  
//   static Future<void> showTestNotification({
//   required String title,
//   required String body,
// }) async {
//   await _flutterLocalNotificationsPlugin.show(
//     DateTime.now().millisecondsSinceEpoch ~/ 1000,
//     title,
//     body,
//     NotificationDetails(
//       android: AndroidNotificationDetails(
//         channel.id,
//         channel.name,
//         channelDescription: channel.description,
//         playSound: true,
//         icon: '@mipmap/ic_launcher',
//       ),
//       iOS: const DarwinNotificationDetails(),
//     ),
//   );
// }
}
