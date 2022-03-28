import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:kmutnb_app/config/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class Contact extends StatefulWidget {
  const Contact({Key? key}) : super(key: key);

  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  final dbfirebase = FirebaseDatabase.instance.reference().child('Officer');
  final dbfirebase2 = FirebaseDatabase.instance.reference().child('Hotline');
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("เบอร์ติดต่อ"),
        centerTitle: true,
        actions: [],
      ),
      body: Container(
        color: pColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Text(
                'เจ้าหน้าที่',
                style:
                    TextStyle(fontSize: size.width * 0.05, color: Colors.white),
              ),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 12),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  //color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: FirebaseAnimatedList(
                  query: dbOff,
                  itemBuilder: (context, snapshot, animation, index) {
                    return Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 29,
                                backgroundImage:
                                    NetworkImage('${snapshot.value['ImgURL']}'),
                                //backgroundColor: pColor,
                              ),
                              title: Text(
                                '${snapshot.value['Name']}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        iconSize: 1,
                                        onPressed: () {},
                                        icon: CircleAvatar(
                                          radius: 20,
                                          backgroundImage: NetworkImage(
                                              'https://upload.wikimedia.org/wikipedia/commons/2/2e/LINE_New_App_Icon_%282020-12%29.png',
                                              scale: 10),
                                          //backgroundColor: pColor,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      snapshot.value['Line'] != null
                                          ? Text(
                                              '${snapshot.value['Line']}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          : Text(
                                              'ไม่มีข้อมูล',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          final snackBar = SnackBar(
                                              content: Text('ไม่มีข้อมูล'));
                                          snapshot.value['Tel'] != null
                                              ? _makePhoneCall(
                                                  '${snapshot.value['Tel']}')
                                              : ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                        },
                                        icon: CircleAvatar(
                                          radius: 20,
                                          backgroundImage: NetworkImage(
                                              'https://abcjourneys.co/images/theme/default/img/logo-phone.png',
                                              scale: 10),
                                          //backgroundColor: pColor,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      snapshot.value['Tel'] != null
                                          ? Text(
                                              '${snapshot.value['Tel']}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          : Text(
                                              'ไม่มีข้อมูล',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                              //subtitle: Text('เมนู : ' + '${snapshot.value['tName']}'),
                            ),
                          ),
                        ),
                        Container(
                          width: size.width,
                          height: 1,
                          color: Colors.black54,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Container(
              child: Text(
                'สายด่วน',
                style:
                    TextStyle(fontSize: size.width * 0.05, color: Colors.white),
              ),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 12),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(10),
                width: size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  //color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: FirebaseAnimatedList(
                  query: dbfirebase2,
                  itemBuilder: (context, snapshot, animation, index) {
                    return Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: ListTile(
                              title: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Text(
                                      '${snapshot.value['Name']}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      iconSize: 1,
                                      onPressed: () {
                                        _makePhoneCall(
                                            '${snapshot.value['Tel']}');
                                      },
                                      icon: CircleAvatar(
                                        radius: 20,
                                        backgroundImage: NetworkImage(
                                            'https://abcjourneys.co/images/theme/default/img/logo-phone.png',
                                            scale: 10),
                                        //backgroundColor: pColor,
                                      ),
                                    ),
                                    Text(
                                      '${snapshot.value['Tel']}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //subtitle: Text('เมนู : ' + '${snapshot.value['tName']}'),
                            ),
                          ),
                        ),
                        Container(
                          width: size.width,
                          height: 1,
                          color: Colors.black54,
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.005,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }
}
