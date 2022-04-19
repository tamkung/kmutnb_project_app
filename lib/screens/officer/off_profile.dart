import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in/widgets.dart';
import 'dart:convert' show json;
import "package:http/http.dart" as http;
import 'package:kmutnb_app/config/constant.dart';

import 'edit_off.dart';

class OfficerProfile extends StatefulWidget {
  static const routeName = '/';

  const OfficerProfile({Key? key}) : super(key: key);

  @override
  _OfficerProfileState createState() => _OfficerProfileState();
}

class _OfficerProfileState extends State<OfficerProfile> {
  FirebaseStorage storage = FirebaseStorage.instance;
  String? name, imgURL;
  final formKey = GlobalKey<FormState>();
  dynamic user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: FirebaseAnimatedList(
                    query: dbOff.orderByKey().equalTo(user.uid),
                    itemBuilder: (context, snapshot, animation, index) {
                      print(snapshot.value);
                      return Container(
                        //color: pColor,
                        //height: 100,
                        child: Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            CircleAvatar(
                              radius: 80,
                              backgroundImage:
                                  NetworkImage(snapshot.value['ImgURL']),
                              //backgroundColor: pColor,
                            ),
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            contain(
                                'ชื่อ-นามสกุล :', '${snapshot.value['Name']}'),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            contain('อีเมล :', '${snapshot.value['Email']}'),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            contain(
                                'เบอร์โทรศัพท์ :',
                                snapshot.value['Tel'] == null
                                    ? 'ไม่มีข้อมูล'
                                    : '${snapshot.value['Tel']}'),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            contain(
                                'ไอดีไลน์ :',
                                snapshot.value['Tel'] == null
                                    ? 'ไม่มีข้อมูล'
                                    : '${snapshot.value['Line']}'),
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Colors.green.shade600,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    side: BorderSide(
                                      color: Colors.green.shade600,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                                child: Column(
                                  children: [
                                    Icon(Icons.edit),
                                    Text(
                                      'แก้ไขข้อมูล',
                                      style: TextStyle(
                                        fontSize: size.height * 0.02,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onPressed: () {
                                print('Edit');
                                _edit(
                                  snapshot.key,
                                  '${snapshot.value['Name']}',
                                  '${snapshot.value['Email']}',
                                  '${snapshot.value['Tel']}',
                                  '${snapshot.value['Line']}',
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget contain(name, val) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      //color: Colors.amberAccent,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              //color: Colors.blue,
              alignment: Alignment.centerRight,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(name),
                ],
              ),
            ),
          ),
          SizedBox(
            width: size.width * 0.02,
          ),
          Expanded(
            flex: 5,
            child: Container(
              //color: Colors.pink,
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  Text(val),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future _edit(key, name, email, tel, line) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileOff(
          off_key: key,
          name: name,
          email: email,
          tel: tel,
          address: line,
        ),
      ),
    );
    print(key);
  }
}
