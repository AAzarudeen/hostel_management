// import 'package:http/http.dart' as http;
//
// void sendNotification(String title, String body) async {
//   final String serverKey = 'YOUR_FIREBASE_SERVER_KEY';
//   final String fcmUrl = 'https://fcm.googleapis.com/fcm/send';
//
//   final Map<String, dynamic> notification = {
//     'notification': {'title': title, 'body': body},
//     'to': '/topics/all', // Send to a topic or a specific device token
//   };
//
//   final http.Response response = await http.post(
//     fcmUrl as Uri,
//     headers: <String, String>{
//       'Content-Type': 'application/json',
//       'Authorization': 'key=$serverKey',
//     },
//     body: jsonEncode(notification),
//   );
//
//   if (response.statusCode == 200) {
//     print('Notification sent successfully');
//   } else {
//     print('Failed to send notification. Error: ${response.body}');
//   }
// }