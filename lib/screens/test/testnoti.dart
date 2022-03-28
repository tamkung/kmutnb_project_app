import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class MyNoti extends StatefulWidget {
  const MyNoti({Key? key}) : super(key: key);

  @override
  _MyNotiState createState() => _MyNotiState();
}

class _MyNotiState extends State<MyNoti> {
  final dbfirebase = FirebaseDatabase.instance.reference().child('Store');
  late String message;
  String channelId = "1000";
  String channelName = "FLUTTER_NOTIFICATION_CHANNEL";
  String channelDescription = "FLUTTER_NOTIFICATION_CHANNEL_DETAIL";

  Future readData() async {
    var db = FirebaseDatabase.instance.reference().child("Alert");
    db.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        print(key);
      });
    });
  }

  @override
  initState() {
    message = "No message.";

    var initializationSettingsAndroid =
        new AndroidInitializationSettings('logo_kmutnb');

    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) {
      print("onDidReceiveLocalNotification called.");
    });
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) {
      // when user tap on notification.
      print("onSelectNotification called.");
      setState(() {
        message = payload!;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('widget.title'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                message = "No message.";
              });
            },
            icon: Icon(Icons.ac_unit),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              message,
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          postRequest();
        },
        tooltip: 'Increment',
        child: Icon(Icons.send),
      ),
    );
  }

  Future sendNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '10000',
      channelName,
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        111, 'Keep', 'This is a your notifications. ', platformChannelSpecifics,
        payload: 'I just haven\'t Met You Yet');
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
}
