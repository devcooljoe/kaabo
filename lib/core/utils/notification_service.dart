// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:injectable/injectable.dart';

// @injectable
// class NotificationService {
//   final FlutterLocalNotificationsPlugin _localNotifications;
//   final FirebaseMessaging _firebaseMessaging;

//   NotificationService(this._localNotifications, this._firebaseMessaging);

//   static Future<void> initialize() async {
//     // Static initialization method remains for app startup
//   }

//   Future<void> showLocalNotification({
//     required String title,
//     required String body,
//     String? payload,
//   }) async {
//     const androidDetails = AndroidNotificationDetails(
//       'kaabo_channel',
//       'Kaabo Notifications',
//       channelDescription: 'Property and rental notifications',
//       importance: Importance.high,
//       priority: Priority.high,
//     );

//     const iosDetails = DarwinNotificationDetails();
//     const details = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );

//     await _localNotifications.show(0, title, body, details, payload: payload);
//   }

//   Future<void> subscribeToTopic(String topic) async {
//     await _firebaseMessaging.subscribeToTopic(topic);
//   }

//   Future<void> unsubscribeFromTopic(String topic) async {
//     await _firebaseMessaging.unsubscribeFromTopic(topic);
//   }

//   Future<String?> getToken() async {
//     return await _firebaseMessaging.getToken();
//   }
// }
