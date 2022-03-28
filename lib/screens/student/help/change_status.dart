import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kmutnb_app/config/constant.dart';

class StdChangeStatus extends StatefulWidget {
  const StdChangeStatus({Key? key}) : super(key: key);

  @override
  _StdChangeStatusState createState() => _StdChangeStatusState();
}

class _StdChangeStatusState extends State<StdChangeStatus> {
  dynamic user = FirebaseAuth.instance.currentUser!;
  late Timer timer;
  dynamic status = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => getStatus());
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('ขอเปลี่ยนสถานะ'),
        centerTitle: true,
      ),
      body: Container(
        color: pColor,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.7),
                      )
                    ],
                  ),
                  //color: Colors.amber,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
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
                  child: Column(
                    children: [
                      Text(
                        'ขอเปลี่ยนสถานะ : ' + '$status',
                        style: TextStyle(
                          fontSize: size.height * 0.03,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: chk(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget chk() {
    dynamic contain;
    if (status == "ปกติ") {
      contain = Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          sizeBox02(),
          image("assets/images/keep.png"),
          sizeBox02(),
          btn('สถานะกักตัว', Color(0xFFFFC56D), 'StdRateKeep'),
          sizeBox02(),
          image("assets/images/infect.png"),
          sizeBox02(),
          btn('สถานะติดเชื้อ', Color(0xFFFF5454), 'StdRateInfect'),
          sizeBox02(),
        ],
      );
    } else if (status == "รอยืนยัน") {
      contain = Text('กรุณารอการยืนยันจากเจ้าหน้าที่');
    } else if (status == "กักตัว") {
      contain = Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          sizeBox02(),
          image("assets/images/normal.png"),
          sizeBox02(),
          btn('สถานะปกติ', Color(0xFF008C0E), 'normal'),
          sizeBox02(),
          image("assets/images/infect.png"),
          sizeBox02(),
          btn('สถานะติดเชื้อ', Color(0xFFFF5454), 'StdRateInfect'),
          sizeBox02(),
        ],
      );
    } else if (status == "ติดเชื้อ") {
      contain = Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          sizeBox02(),
          image("assets/images/normal.png"),
          sizeBox02(),
          btn('สถานะปกติ', Color(0xFF008C0E), 'normal'),
          sizeBox02(),
        ],
      );
    }

    return contain;
  }

  Widget btn(name, color, tap) {
    var size = MediaQuery.of(context).size;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: color,
        padding: EdgeInsets.fromLTRB(45, 13, 45, 13),
        shape: StadiumBorder(),
      ),
      child: Text(
        name,
        style: TextStyle(
          fontSize: size.height * 0.026,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () {
        print(status);
        Navigator.pushNamed(context, tap);
      },
    );
  }

  Widget image(url) {
    var size = MediaQuery.of(context).size;
    return Image.asset(
      url,
      width: size.width * 0.22,
      //height: size.height * 0.4,
    );
  }

  Widget sizeBox02() {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.02,
    );
  }

  Future<void> getStatus() async {
    await dbStd.child(user.uid!).once().then((DataSnapshot snapshot) async {
      //print('Status');
      //print(snapshot.value['Status']);
      Map<dynamic, dynamic> values = snapshot.value;
      //print(values.toString());
      values.forEach((k, v) async {
        setState(() {
          //print(db.get());
          //print('Name : ' + v["Name"]);
          status = snapshot.value['Status'];
          print(status);
        });
      });
      // status = snapshot.value['Status'];
    });
  }
}
