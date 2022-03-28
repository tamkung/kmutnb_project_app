import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kmutnb_app/config/constant.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class StdRateKeep extends StatefulWidget {
  const StdRateKeep({Key? key}) : super(key: key);

  @override
  _StdRateKeepState createState() => _StdRateKeepState();
}

class _StdRateKeepState extends State<StdRateKeep> {
  dynamic user = FirebaseAuth.instance.currentUser!;
  String txt1 =
      '1. คุณมีอาการอย่างใดอย่างหนึ่งดังต่อไปนี้มีประวัติไข้ หรือวัดอุณหภูมิได้ตั้งแต่ 37.5 องศาขึ้นไปไอ มีน้ำมูก เจ็บคอ ไม่ได้กลิ่น ลิ้นไม่รับรส หายใจเร็ว หายใจเหนื่อยหรือหายใจลำบาก ตาแดง ผื่น ถ่ายเหลว';
  String txt2 =
      '3. สมาชิกในครอบครัว/เพื่อน/เพื่อนร่วมงานหรือเดินทางร่วมยานพาหนะ กับผู้ติดเชื้อเข้าข่าย/ผู้ป่วยยืนยัน/';
  String txt3 =
      '3. สมาชิกในครอบครัว/เพื่อน/เพื่อนร่วมงานหรือเดินทางร่วมยานพาหนะ กับผู้ติดเชื้อเข้าข่าย/ผู้ป่วยยืนยัน/';
  String txt4 = '4. มีประวัติสัมผัสกับผู้ป่วยยืนยันโรคติดเชื้อไวรัส COVID-19';

  int _value1 = -1;
  int _value2 = -1;
  int _value3 = -1;
  int _value4 = -1;
  var data1 = "";
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
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
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
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(8),
                          width: size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0XFFF6EBDA),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0XFFF6EBDA),
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/scared.png",
                                width: size.width * 0.05,
                                //height: size.height * 0.4,
                              ),
                              Flexible(
                                child: Text(
                                  "การทำแบบประเมินจะมีผลกับการเปลี่ยนสถานะของนักศึกษา",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0XFFC38427),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _txtCont(txt1),
                        //Radio---------------------------------------------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _myRadioButton(
                              1,
                              _value1,
                              onChanged: (val) => setState(() => _value1 = val),
                            ),
                            _txtHave(),
                            _sizeBox02(),
                            _myRadioButton(
                              0,
                              _value1,
                              onChanged: (val) => setState(() => _value1 = val),
                            ),
                            _txtNot(),
                          ],
                        ),
                        //Radio---------------------------------------------
                        _txtCont(txt2),
                        //Radio---------------------------------------------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _myRadioButton(
                              1,
                              _value2,
                              onChanged: (val) => setState(() => _value2 = val),
                            ),
                            _txtHave(),
                            _sizeBox02(),
                            _myRadioButton(
                              0,
                              _value2,
                              onChanged: (val) => setState(() => _value2 = val),
                            ),
                            _txtNot(),
                          ],
                        ),
                        //Radio---------------------------------------------
                        _txtCont(txt3),
                        //Radio---------------------------------------------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _myRadioButton(
                              1,
                              _value3,
                              onChanged: (val) => setState(() => _value3 = val),
                            ),
                            _txtHave(),
                            _sizeBox02(),
                            _myRadioButton(
                              0,
                              _value3,
                              onChanged: (val) => setState(() => _value3 = val),
                            ),
                            _txtNot(),
                          ],
                        ),
                        //Radio---------------------------------------------
                        _txtCont(txt4),
                        //Radio---------------------------------------------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _myRadioButton(
                              1,
                              _value4,
                              onChanged: (val) => setState(() => _value4 = val),
                            ),
                            _txtHave(),
                            _sizeBox02(),
                            _myRadioButton(
                              0,
                              _value4,
                              onChanged: (val) => setState(() => _value4 = val),
                            ),
                            _txtNot(),
                          ],
                        ),
                        //Radio---------------------------------------------
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF008C0E),
                            padding: EdgeInsets.fromLTRB(45, 13, 45, 13),
                            shape: StadiumBorder(),
                          ),
                          child: Text(
                            'ยืนยัน',
                            style: TextStyle(
                              fontSize: size.height * 0.026,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () async {
                            print(user!.displayName);
                            //Navigator.pushNamed(context, 'OfficerLogin');
                            var sum = _value1 + _value2 + _value3 + _value4;
                            print("_value1 " + '$_value1');
                            print("_value2 " + '$_value2');
                            print("_value3 " + '$_value3');
                            print("_value4 " + '$_value4');
                            print("sum " + '$sum');
                            if (_value1 == -1 ||
                                _value2 == -1 ||
                                _value3 == -1 ||
                                _value4 == -1) {
                              _alertFail(context);
                            } else if (sum >= 3) {
                              await _alert(context, "ผ่าน");
                              await AllFunction()
                                  .postRequest(user.displayName, 'กักตัว');
                              await createData();
                            } else {
                              _alert(context, "ไม่ผ่าน");
                            }
                          },
                        ),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> createData() async {
    //if (_value1==1)
    try {
      await dbAssess.child('Keep').child(user!.displayName).push().set({
        'choice1': _value1,
        'choice2': _value2,
        'choice3': _value3,
        'choice4': _value4,
      }).then((value) async {
        await dbAlert.push().set({
          'uid': user.uid!,
          'Name': user!.displayName,
          'currentType': allState,
          'type': 'กักตัว',
          'status': 'รอยืนยัน',
        }).then((value) {
          //formKey.currentState!.reset();

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
      }).catchError((onError) {
        print(onError.code);
        print(onError.message);
      });
      final snackBar = SnackBar(content: Text('อัปเดตสำเร็จ'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      //setState(() {});

    } on FirebaseException catch (error) {
      print(error);
    }

    //dynamic user = FirebaseAuth.instance.currentUser;
  }

  Widget _txtCont(val) {
    var size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.all(10),
      width: size.width,
      child: Text(
        val,
        textAlign: TextAlign.left,
        style: TextStyle(),
      ),
    );
  }

  Widget _txtHave() {
    var size = MediaQuery.of(context).size;
    return Text('มี');
  }

  Widget _txtNot() {
    var size = MediaQuery.of(context).size;
    return Text('ไม่มี');
  }

  Widget _sizeBox02() {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.2,
    );
  }

  Widget _myRadioButton(value, _group, {onChanged}) {
    return Radio(
      value: value,
      groupValue: _group,
      onChanged: onChanged,
      //title: Text(title!),
    );
  }

  _alert(context, val) {
    var color = Colors.white;
    val == "ผ่าน" ? color = Colors.green : color = Colors.red;
    Alert(
        context: context,
        //title: "LOGIN",
        content: Column(
          children: <Widget>[
            Image.asset(
              "assets/images/rate.png",
              height: 200,
            ),
            Text('ขอบคุณที่ทำแบบประเมิน'),
            Text(
              val,
              style: TextStyle(
                color: color,
              ),
            ),
            Text(
              'กรุณารอเจ้าหน้าที่ยืนยันการเปลี่ยนสถานะ',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        buttons: [
          DialogButton(
            color: Color(0XFF008C0E),
            onPressed: () {
              var count = 0;
              Navigator.popUntil(context, (route) {
                return count++ == 2;
              });
            },
            child: Text(
              "กลับไปหน้าหลัก",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  _alertFail(context) {
    Alert(
      style: AlertStyle(
        backgroundColor: Colors.white,
        titleStyle: TextStyle(fontSize: 28),
      ),
      buttons: [
        DialogButton(
          color: Color(0XFF008C0E),
          child: Text(
            "OK",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          width: 120,
        ),
      ],
      context: context,
      title: "กรุณาทำแบบประเมินให้ครบ",
      //desc: "Flutter is more awesome with RFlutter Alert.",
    ).show();
  }
}
