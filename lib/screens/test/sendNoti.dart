import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

void main() {
  postRequest();
}

Future<http.Response> postRequest() async {
  var url = 'https://fcm.googleapis.com/fcm/send';
  var token =
      'AAAAe_-6loo:APA91bHk4ZRhBGeUjKSKxqOAc1eHD0r2ucEBs7MvB20hbpw6uga2Gm_sWV1P7xVkDumIcX7RNuL9nwvc4RK4ZZzqvH_OgHLO2WA-PLA2HNu_SlRVqHI0yHEPS3elKZATyB4dr-H2XF_S';

  Map data = {
    "to": "/topics/messaging",
    "notification": {"title": "Test", "body": "สวัสดี"},
    "data": {"msgId": "msg_12342"}
  };
  //encode Map to JSON
  var body = json.encode(data);

  var response = await http.post(
    Uri.parse(url),
    headers: {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    },
    body: body,
  );
  print("${response.statusCode}");
  print("${response.body}");
  return response;
}
