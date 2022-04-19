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
import 'package:kmutnb_app/screens/student/edit_std.dart';

class StudentProfile extends StatefulWidget {
  static const routeName = '/';

  const StudentProfile({Key? key}) : super(key: key);

  @override
  _StudentProfileState createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  FirebaseStorage storage = FirebaseStorage.instance;
  String? name, imgURL;
  final formKey = GlobalKey<FormState>();

  dynamic user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // List<int> id = [];
    // List<int> dep = [];
    // int n1, n2;
    // var dep_name;
    // //print(user!.email.length);
    // for (var i = 1; i <= 13; i++) {
    //   //print(user!.email[i]);
    //   n1 = int.parse(user!.email[i]);
    //   id.add(n1);
    // }
    // for (var i = 4; i <= 6; i++) {
    //   //print(user!.email[i]);
    //   n2 = int.parse(user!.email[i]);
    //   dep.add(n2);
    // }

    // print(id.join().toString());
    // print(dep.join().toString());
    // if (int.parse(dep.join()) == 0) {
    //   dep_name = 'วิศวกรรมศาสตร์';
    // } else if (int.parse(dep.join()) == 204) {
    //   dep_name = 'ครุศาสตร์อุตสาหกรรม';
    // } else if (int.parse(dep.join()) == 0) {
    //   dep_name = 'เทคโนโลยีและการจัดการอุตสาหกรรม';
    // } else if (int.parse(dep.join()) == 0) {
    //   dep_name = 'วิทยาศาสตร์ประยุกต์';
    // } else if (int.parse(dep.join()) == 305) {
    //   dep_name = 'วิทยาลัยเทคโนโลยีอุตสาหกรรม';
    // } else if (int.parse(dep.join()) == 0) {
    //   dep_name = 'สถาปัตยกรรมและการออกแบบ';
    // } else if (int.parse(dep.join()) == 0) {
    //   dep_name = 'อุตสาหกรรมเกษตร';
    // } else if (int.parse(dep.join()) == 0) {
    //   dep_name = 'พัฒนาธุรกิจและอุตสาหกรรม';
    // } else if (int.parse(dep.join()) == 0) {
    //   dep_name = 'บริหารธุรกิจและอุตสาหกรรมบริการ';
    // } else if (int.parse(dep.join()) == 0) {
    //   dep_name = 'วิศวกรรมศาสตร์และเทคโนโลยี';
    // } else if (int.parse(dep.join()) == 0) {
    //   dep_name = 'วิทยาศาสตร์ พลังงาน และสิ่งแวดล้อม';
    // } else if (int.parse(dep.join()) == 0) {
    //   dep_name = 'บริหารธุรกิจ';
    // } else {
    //   dep_name = 'ไม่มีข้อมูล';
    // }

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
                    query: dbStd.orderByKey().equalTo(user.uid),
                    itemBuilder: (context, snapshot, animation, index) {
                      // print(snapshot.value);
                      return Stack(
                        children: [
                          Positioned(
                            top: -10,
                            right: -10,
                            child: txtState(snapshot.value['Status']),
                          ),
                          Container(
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
                                contain('รหัสนักศึกษา :',
                                    '${snapshot.value['Std_ID']}'),
                                SizedBox(
                                  height: size.height * 0.01,
                                ),
                                contain('ชื่อ-นามสกุล :',
                                    '${snapshot.value['Name']}'),
                                SizedBox(
                                  height: size.height * 0.01,
                                ),
                                contain(
                                    'อีเมล :', '${snapshot.value['Email']}'),
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
                                    'ที่อยู่ :',
                                    snapshot.value['Address'] == null
                                        ? 'ไม่มีข้อมูล'
                                        : '${snapshot.value['Address']}'),
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
                                        borderRadius:
                                            BorderRadius.circular(15.0),
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
                                      '${snapshot.value['Std_ID']}',
                                      '${snapshot.value['Name']}',
                                      '${snapshot.value['Email']}',
                                      '${snapshot.value['Tel']}',
                                      '${snapshot.value['Address']}',
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
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

  Widget txtState(val) {
    var color = Colors.white;
    if (val == "ปกติ") {
      color = Colors.green;
    } else if (val == "กักตัว") {
      color = Colors.amber;
    } else if (val == "ติดเชื้อ") {
      color = Colors.red;
    } else if (val == "รอยืนยัน") {
      color = Colors.pink.shade400;
    } else if (val == "รักษาหายแล้ว") {
      color = Colors.blue;
    }
    return Container(
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(width: 3.0, color: color),
        borderRadius: BorderRadius.all(
            Radius.circular(8.0) //                 <--- border radius here
            ),
      ),
      child: Text(
        val,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Future _edit(key, std_id, name, email, tel, address) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileStd(
          std_key: key,
          std_id: std_id,
          name: name,
          email: email,
          tel: tel,
          address: address,
        ),
      ),
    );
    print(key);
  }
}
