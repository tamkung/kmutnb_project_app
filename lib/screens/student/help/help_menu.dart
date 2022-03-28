import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kmutnb_app/config/constant.dart';

class HelpMenu extends StatefulWidget {
  const HelpMenu({Key? key}) : super(key: key);

  @override
  State<HelpMenu> createState() => _HelpMenuState();
}

class _HelpMenuState extends State<HelpMenu> {
  dynamic user = FirebaseAuth.instance.currentUser!;
  late Timer timer;

  dynamic help = '';

  @override
  void initState() {
    setState(() {
      timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
        getHelp();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("ขอความช่วยเหลือ"),
        centerTitle: true,
      ),
      body: help != ''
          ? Container(
              height: size.height,
              padding: EdgeInsets.all(5),
              color: pColor,
              child: Container(
                margin: EdgeInsets.all(5),
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
                //height: 50,
                child: help != 'รอยืนยัน'
                    ? SingleChildScrollView(
                        child: Column(
                          //mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            Text(
                              'ขอความช่วยเหลือ',
                              style: TextStyle(
                                fontSize: size.height * 0.03,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            Container(
                              margin: EdgeInsets.all(5),
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              //color: Colors.amber,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _btn2("assets/images/tool_bg.png",
                                          "HelpTool"),
                                      SizedBox(
                                        width: size.width * 0.015,
                                      ),
                                      _btn2("assets/images/pill_bg.png",
                                          'HelpPill'),
                                    ],
                                  ),
                                  SizedBox(
                                    height: size.height * 0.015,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _btn2("assets/images/tel_bg.png",
                                          'HelpTel'),
                                      SizedBox(
                                        width: size.width * 0.015,
                                      ),
                                      _btn2("assets/images/food_bg.png",
                                          'HelpFood'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : Center(
                        child: Text('กรุณารอการยืนยันจากเจ้าหน้าที่'),
                      ),
              ),
            )
          : Center(
              child: txtload,
            ),
    );
  }

  Widget _btn2(img, tap) {
    var size = MediaQuery.of(context).size;
    return IconButton(
      onPressed: () {
        print(tap);
        Navigator.pushNamed(context, tap);
      },
      icon: Image.asset(
        img,
        //width: size.width * 5,
      ),
      iconSize: size.width * 0.37,
    );
  }

  Widget _btn(name, Icon icon, nav) {
    var size = MediaQuery.of(context).size;
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          Colors.green.shade600,
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
            icon,
            Text(
              name,
              style: TextStyle(
                fontSize: size.height * 0.02,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      onPressed: () {},
    );
  }

  Future<void> getHelp() async {
    dbStd.child(user.uid!).once().then((DataSnapshot snapshot) async {
      //print('Status');
      //print(snapshot.value['Status']);
      setState(() {
        help = snapshot.value['Help'];
      });
      print(help);
      /*
      Map<dynamic, dynamic> values = snapshot.value;
      //print(values.toString());
      values.forEach((k, v) async {
        // if (this.mounted) {
        //   // check whether the state object is in tree
        //   setState(() {
        //     status = snapshot.value['Status'];
        //     print(status);
        //   });
        // }
        setState(() {
          //print(db.get());
          //print('Name : ' + v["Name"]);
          status = snapshot.value['Status'];
          print(status);
        });
      });
      */
      // status = snapshot.value['Status'];
    });
  }
}
