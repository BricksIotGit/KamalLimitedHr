import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> sendTopicMessage(String topic,String title,String body, String notificationId) async {
  // final String topic = 'flag'; // Replace with the topic name
  final Map<String, dynamic> message = {
    "to": "/topics/$topic",
    'notification': {
      'title': title,
      'body': body,
    },
    'notification_id': notificationId,
    // 'topic': topic,
  };

  const String url = 'https://fcm.googleapis.com/fcm/send';
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