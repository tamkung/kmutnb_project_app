import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../config/constant.dart';

class NotiFire extends StatefulWidget {
  final dynamic name2;
  const NotiFire({
    required this.name2,
  }) : super();

  @override
  _NotiFireState createState() => _NotiFireState();
}

class _NotiFireState extends State<NotiFire> {
  dynamic user = FirebaseAuth.instance.currentUser!;
  late FirebaseMessaging messaging;
  String? msg;
  String? name;
  FirebaseStorage storage = FirebaseStorage.instance;
  final formKey = GlobalKey<FormState>();

  List<String> _type = [
    'กักตัว',
    'ติดเชื้อ',
    'รักษาหายแล้ว',
  ];
  String? _selectedType;
  @override
  void initState() {
    super.initState();
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      print(value);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      print('Message clicked!');
      await Navigator.pushNamed(context, 'Login');
    });
    /*
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification!.body);
      print(event.data.values);
      msg = event.notification!.body.toString();
      print('tes' + '$msg');
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Notification"),
              content: Text(event.notification!.body!),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });*/
    messaging.subscribeToTopic("messaging");
    //FirebaseMessaging.onBackgroundMessage(_messageHandler);
  }

  Future<http.Response> postRequest() async {
    var url = 'https://fcm.googleapis.com/fcm/send';
    var token =
        'AAAAe_-6loo:APA91bHk4ZRhBGeUjKSKxqOAc1eHD0r2ucEBs7MvB20hbpw6uga2Gm_sWV1P7xVkDumIcX7RNuL9nwvc4RK4ZZzqvH_OgHLO2WA-PLA2HNu_SlRVqHI0yHEPS3elKZATyB4dr-H2XF_S';

    Map data = {
      "to": "/topics/messaging",
      "notification": {"title": "${widget.name2}", "body": "$_selectedType"},
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
    formKey.currentState!.reset();
    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name2),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _selectedType = null;
              });
            },
            icon: Icon(Icons.ac_unit),
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Center(
              child: DropdownButton(
                hint: Text('กรุณาเลือกประเภท'), // Not necessary for Option 1
                value: _selectedType,
                onChanged: (newValue) {
                  setState(() {
                    _selectedType = newValue.toString();
                  });
                },
                items: _type.map((type) {
                  return DropdownMenuItem(
                    child: new Text(type),
                    value: type,
                  );
                }).toList(),
              ),
            ),
            Container(
              child: Center(
                child: Column(
                  children: [
                    _selectedType == null
                        ? Text('data')
                        : Text(
                            _selectedType.toString(),
                          ),
                    //txtName(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.upload),
          onPressed: () async {
            print(msg);
            print(name);
            /*
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
            }*/
            if (_selectedType == null && name == null) {
              _onBasicAlertPressed(context);
            } else {
              postRequest();
              await createData();
            }
          }),
    );
  }

  Future<void> createData() async {
    if (_selectedType != null) {
      try {
        /*
      await storage.ref('Image').child(fileName!).putFile(
            imageFile!,
            SettableMetadata(
              customMetadata: {
                'uploaded_by': 'Admin',
                'description': 'Some description...'
              },
            ),
          );
      */

        await dbAlert.push().set({
          'uid': user.uid!,
          'tName': widget.name2,
          'type': _selectedType,
          'status': 'รอยืนยัน',
        }).then((value) {
          //formKey.currentState!.reset();

          _selectedType = null;
          name = null;
          print("Success");
        }).catchError((onError) {
          print(onError.code);
          print(onError.message);
        });

        await dbStd.child(user.uid!).update({
          'Status': 'รอยืนยัน',
        }).then((value) {
          print("Success");
        }).catchError((onError) {
          print(onError.code);
          print(onError.message);
        });

        final snackBar = SnackBar(content: Text('เพิ่มสำเร็จ'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        //print(fileName);
        //print(imageFile);
        //print(downloadUrl);
        setState(() {});
      } on FirebaseException catch (error) {
        print(error);
      }
    } else {
      _onBasicAlertPressed(context);
    }
  }

  Widget txtName() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 15, 15, 10),
      child: TextFormField(
        style: TextStyle(
          fontSize: 20,
        ),
        decoration: InputDecoration(
          labelText: 'ชื่อ',
          icon: Icon(Icons.file_upload),
          hintText: 'Input your name',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณาป้อนข้อมูล';
          }
        },
        onSaved: (value) {
          name = value!.trim();
        },
      ),
    );
  }

  _onBasicAlertPressed(context) {
    Alert(
      style: AlertStyle(
        backgroundColor: pColor,
        titleStyle: TextStyle(fontSize: 32),
      ),
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          color: tColor,
          onPressed: () => Navigator.pop(context),
          width: 120,
        ),
      ],
      context: context,
      title: "กรุณาป้อนข้อมูล",
      //desc: "Flutter is more awesome with RFlutter Alert.",
    ).show();
  }
}
/*
fHeGTcokTFOwoMNxDjW-CL:APA91bH9FWiHaMSZZTQeeh5elNGoasbdMeigcJ53f6vhbjPjnXMQ02oYWc4hEssDJ2XitCzxwJvAgQL_4nUU6fPPDasAuWYsXFKReAKsZCDK9YZ4hy-3J8lw88XcGiUpHRXhkaowXq-b
fVX0xCDoR-iMPFI6uISR2c:APA91bFjPAwmlH--ZnD6-l0IOWFS53pC2hQbEQfJXrhoh4mH-YNNOKYb8U56hL3LoBHAcbVJRZrJjdybC5EN0DijJxtjcs2PSplsBMoMmnP6Kbbamv3AZpCrk6AVxJJ82t0aKBab4hre
*/