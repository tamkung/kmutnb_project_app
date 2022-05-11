import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kmutnb_app/screens/pdf_viewer.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

const pColor = Color(0xFFFF6633);

const sColor = Color(0xFFFF6633);

const tColor = Color(0xFF6600FF);

const bColor = Color(0xFF2D55A6);

dynamic allState = '';

bool? login = false;

//late dynamic status;

const txtload = Text(
  'กำลังโหลดข้อมูล',
  style: TextStyle(
    fontSize: 16,
  ),
);

const homeName =
    'แอปติดตามการกักตัวสถานการณ์แพร่ระบาดโควิด19 นักศึกษามหาวิทยาลัยเทคโนโลยีพระจอมเกล้าพระนครเหนือ';

final dbAlert = FirebaseDatabase.instance.reference().child('Alert');
final dbStd = FirebaseDatabase.instance.reference().child('Student');
final dbOff = FirebaseDatabase.instance.reference().child('Officer');
final dbFile = FirebaseDatabase.instance.reference().child('File');
final dbTel = FirebaseDatabase.instance.reference().child('Hotline');
final dbHis = FirebaseDatabase.instance.reference().child('History');
final dbTimeline = FirebaseDatabase.instance.reference().child('Timeline');
final dbAssess = FirebaseDatabase.instance.reference().child('Assessment');

Widget menu1(context, name, nav) {
  return ListTile(
    title: Text(
      name,
      style: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    ),
    onTap: () {
      Navigator.pushNamed(context, nav);
    },
  );
}

Widget sizeBoxDrawer() {
  return const SizedBox(
    height: 4,
    width: 500,
    child: const DecoratedBox(
      decoration: const BoxDecoration(color: pColor),
    ),
  );
}

class AllFunction {
  Future<http.Response> postRequest(name, val) async {
    var url = 'https://fcm.googleapis.com/fcm/send';
    var token =
        'AAAAe_-6loo:APA91bHk4ZRhBGeUjKSKxqOAc1eHD0r2ucEBs7MvB20hbpw6uga2Gm_sWV1P7xVkDumIcX7RNuL9nwvc4RK4ZZzqvH_OgHLO2WA-PLA2HNu_SlRVqHI0yHEPS3elKZATyB4dr-H2XF_S';

    Map data = {
      "to": "/topics/messaging",
      "notification": {"title": "$name", "body": "$val"},
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

  Future<void> signOutFromGoogle(context) async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    //await Navigator.pushNamedAndRemoveUntil(
    //   context, routeName, (route) => false);
    //await Navigator.pushNamed(context, 'index');
  }

  Future<void> _delete(String ref) async {
    await FirebaseStorage.instance.refFromURL(ref).delete();
  }

  Future<void> showMyDialog(context, key, imgurl) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'ยืนยันการลบ',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  'คุณแน่ใจใช่ไหมที่จะลบรายการ',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'ยืนยัน',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                print('Confirmed');
                _delete(imgurl);
                dbFile.child(key).remove();
                //print(key);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'ยกเลิก',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future sendURL(context, String url, name) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PDFViewer1(
          url: url,
          name: name,
        ),
      ),
    );
  }

  onBasicAlertPressed(context) {
    Alert(
      style: AlertStyle(
        backgroundColor: Colors.white,
        titleStyle: TextStyle(fontSize: 28),
      ),
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          color: bColor,
          onPressed: () => Navigator.pop(context),
          width: 120,
        ),
      ],
      context: context,
      title: "กรุณาใช้อีเมลของ มจพ.",
      //desc: "Flutter is more awesome with RFlutter Alert.",
    ).show();
  }
}
