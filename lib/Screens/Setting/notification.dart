import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Future<void> subscribeToTopic() async {
    FirebaseMessaging.instance.subscribeToTopic('flag');
    print('Subscribed to topic');
  }

  Future<void> unSubscribeToTopic() async {
    await FirebaseMessaging.instance.unsubscribeFromTopic("flag");
    print('un-Subscribed to topic');
  }

  Future<void> sendTopicMessage() async {
    final String topic = 'flag'; // Replace with the topic name
    final Map<String, dynamic> message = {
      "to": "/topics/$topic",
      'notification': {
        'title': 'Topic Message',
        'body': 'This is a topic message sent using HTTP.',
      },
      // 'topic': topic,
    };

    final String url = 'https://fcm.googleapis.com/fcm/send';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAA8JA0C8s:APA91bHV23I9Kcp875d7LD4SQqc0R2TMLXrRI95nS7-05SIqDfYrGjRVehJpL5qEktIWN6b6GFOuAZNTu98RxIgJ6O_fn-Z7wdnQm26PIRbuG5hFtQ5dfV7EI4LpwdXIVIxw4fvwjef3',
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(message),
    );

    if (response.statusCode == 200) {
      print('Topic message sent successfully.');
    } else {
      print(
          'Failed to send topic message. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () async {
                  await subscribeToTopic();
                },
                child: Text("Subscribe")),
            ElevatedButton(
                onPressed: () async {
                  await unSubscribeToTopic();
                },
                child: Text("Un-Subscribe")),
            ElevatedButton(
                onPressed: () async {
                  await sendTopicMessage();
                },
                child: Text("Send Notification")),
          ],
        ),
      ),
    );
  }
}
