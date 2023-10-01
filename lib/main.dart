import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:kamal_limited/authenticatons/AuthenticationRepo.dart';
import 'package:kamal_limited/firebase_options.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'Screens/Starting/Splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // .then((value) => Get.put(AuthenticationRepo()));
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  print('User granted permission: ${settings.authorizationStatus}');
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
      handleChatNotification(message);
    }
  });
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');

      handleChatNotification(message);
    }
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const GetMaterialApp(home: SplashScreen()));
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  handleChatNotification(message);
  print("Handling a background message: ${message.messageId}");
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> handleChatNotification(RemoteMessage message) async {
  final RemoteNotification? notification = message.notification;
  final AndroidNotification? android = message.notification?.android;

  if (notification != null && android != null) {
    // Display the notification
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('notifications', 'notifications',
            channelDescription: 'For Showing Message Notification',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      notification.title,
      notification.body,
      platformChannelSpecifics,
      payload: 'chat', // You can pass additional data in the payload
    );

    // Check if the custom data contains an image URL
    if (message.data.containsKey('image_url')) {
      final imageUrl = message.data['image_url'];

      // Download the image and convert it to Uint8List
      final http.Response response = await http.get(Uri.parse(imageUrl));
      final Uint8List imageData = response.bodyBytes;

      // Save the image to a temporary file
      final tempDir = await getTemporaryDirectory();
      final tempFilePath = '${tempDir.path}/notification_image.png';
      final tempFile = File(tempFilePath);
      await tempFile.writeAsBytes(imageData);

      // Display the notification with the image
      final BigPictureStyleInformation bigPictureStyleInformation =
          BigPictureStyleInformation(
        FilePathAndroidBitmap(tempFilePath),
        contentTitle: notification.title,
        summaryText: notification.body,
      );

      final AndroidNotificationDetails notificationDetails =
          AndroidNotificationDetails(
        'notifications',
        'notifications',
        channelDescription: 'For Showing Message Notification',
        styleInformation: bigPictureStyleInformation,
        importance: Importance.max,
        priority: Priority.high,
      );

      await flutterLocalNotificationsPlugin.show(
        0,
        notification.title,
        notification.body,
        platformChannelSpecifics,
        payload: 'notifications', // You can pass additional data in the payload
      );
    }
    // Perform your chat-related logic here
    print('New chat message: ${notification.title} - ${notification.body}');
  }
}
