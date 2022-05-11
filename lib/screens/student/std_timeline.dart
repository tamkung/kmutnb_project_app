import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kmutnb_app/config/constant.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Timeline extends StatefulWidget {
  const Timeline({Key? key}) : super(key: key);

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  dynamic user = FirebaseAuth.instance.currentUser!;
  final formKey = GlobalKey<FormState>();
  var dateTime = new DateTime.now();
  bool chk = false;
  List<String> dateList = [];
  List<String> textList = [];
  late Timer timer;
  dynamic status = '';

  @override
  void initState() {
    setState(() {
      timer = Timer.periodic(Duration(seconds: 3), (Timer t) {
        getStatus();
        // print(mounted.toString());
      });
    });
    super.initState();
    dateTime = DateTime.now();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<void> sendData() async {
    //for (int i = 0; i < 10; i++) {}
    try {
      await dbTimeline.child(user!.uid).remove();
      await dbTimeline.child(user!.uid).update({
        // 'ชื่อ-นามสกุล': user!.displayName,
        '1 : ${dateList[0]}': textList[0],
        '2 : ${dateList[1]}': textList[1],
        '3 : ${dateList[2]}': textList[2],
        '4 : ${dateList[3]}': textList[3],
        '5 : ${dateList[4]}': textList[4],
        '6 : ${dateList[5]}': textList[5],
        '7 : ${dateList[6]}': textList[6],
        '8 : ${dateList[7]}': textList[7],
        '9 : ${dateList[8]}': textList[8],
        '10 : ${dateList[9]}': textList[9],
        '11 : ${dateList[10]}': textList[10],
        '12 : ${dateList[11]}': textList[11],
        '13 : ${dateList[12]}': textList[12],
        '14 : ${dateList[13]}': textList[13],
      }).then((value) async {
        textList = [];
        formKey.currentState!.reset();
        print("Success");
        final snackBar = SnackBar(content: Text('สำเร็จ'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pop(context);
      }).catchError((onError) {
        print(onError.code);
        print(onError.message);
      });

      // print(fileName);
      // print(imageFile);
      // print("URL" + downloadUrl.toString());
      //setState(() {});

    } on FirebaseException catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ไทม์ไลน์ย้อนหลัง 14 วัน'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              getStatus2();
            },
            icon: Icon(Icons.remove_red_eye),
          )
        ],
      ),
      body: Container(
        child: Form(
          key: formKey,
          child: chk == false ? showDate() : showDateChoose(),
        ),
      ),
    );
  }

  Widget showDate() {
    return Card(
      elevation: 5,
      child: ListTile(
        leading: Icon(Icons.date_range),
        title: Text('${dateTime.day} / ${dateTime.month} / ${dateTime.year}'),
        trailing: Icon(Icons.keyboard_arrow_down),
        onTap: () {
          chooseDate();
        },
      ),
    );
  }

  Widget showDateChoose() {
    var size = MediaQuery.of(context).size;
    final children = <Widget>[];
    for (var i = 1; i <= 14; i++) {
      var newDate = DateTime(dateTime.year, dateTime.month, dateTime.day - i);
      String formattedDate = DateFormat('dd-MM-yyyy').format(newDate);
      dateList.add(formattedDate);
      children.add(
        txtTimeLine('วันที่ $i : ' + formattedDate),
      );
    }
    children.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          btnSubmit('บันทึก', Colors.green),
          SizedBox(
            width: size.width * 0.15,
          ),
          btnSubmit('ยกเลิก', Colors.red),
        ],
      ),
    );
    return new ListView(
      children: children,
    );
  }

  Widget txtTimeLine(date) {
    //loadData();
    return Container(
      margin: EdgeInsets.fromLTRB(10, 15, 15, 10),
      child: TextFormField(
        enabled: true,
        style: TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: date,
          hintText: 'ป้อนข้อมูลไทม์ไลน์',
        ),
        //initialValue: '',
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณาป้อนข้อมูล';
          }
        },
        onSaved: (value) {
          textList.add(value!);
        },
      ),
    );
  }

  Future<void> chooseDate() async {
    DateTime? chooseDateTime = await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (chooseDateTime != null) {
      setState(() {
        dateTime = chooseDateTime;
        chk = true;
      });
    }
  }

  Future<void> getStatus() async {
    dbTimeline.child(user.uid!).once().then((DataSnapshot snapshot) async {
      //print('Status');
      //print(snapshot.value['Status']);
      // setState(() {
      //   status = snapshot.key;
      //   print(status);
      // });

      Map<dynamic, dynamic> values = snapshot.value;
      //print(values.toString());
      values.forEach((k, v) async {
        setState(() {
          //print('Name : ' + v["Name"]);
          status = v;
          print(status);
        });
      });
    });
  }

  Widget btnSubmit(val, color) {
    var size = MediaQuery.of(context).size;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: color,
      ),
      onPressed: () {
        if (val == 'บันทึก') {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            //updateData();
            sendData();
            // file == null ? updateData2() : updateData();
            //formKey.currentState!.reset();
          }
          print(textList);
        } else {
          chk = false;
          // Navigator.pop(context);
        }
      },
      child: Text(
        val,
        style: TextStyle(
          fontSize: size.width * 0.05,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  //////////
  dynamic _listKey, _listVal;
  _viewAddr(context) {
    var size = MediaQuery.of(context).size;

    Alert(
        context: context,
        title: "ไทม์ไลน์",
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            txtTimeLine2(0),
            txtTimeLine2(6),
            txtTimeLine2(7),
            txtTimeLine2(8),
            txtTimeLine2(9),
            txtTimeLine2(10),
            txtTimeLine2(11),
            txtTimeLine2(12),
            txtTimeLine2(13),
            txtTimeLine2(1),
            txtTimeLine2(2),
            txtTimeLine2(3),
            txtTimeLine2(4),
            txtTimeLine2(5),
          ],
        ),
        buttons: [
          DialogButton(
            color: Color(0XFF008C0E),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  Widget txtTimeLine2(i) {
    return Text('วันที่ ' + _listKey[i] + ' : ' + _listVal[i]);
  }

  Future<void> getStatus2() async {
    try {
      await dbTimeline
          .child(user.uid!)
          .once()
          .then((DataSnapshot snapshot) async {
        //print('Status');
        //print(snapshot.value['Status']);
        // setState(() {
        //   status = snapshot.key;
        //   print(status);
        // });

        Map<dynamic, dynamic> values = snapshot.value;
        //print(values.toString());
        //status.add(values);
        _listKey = values.keys.toList();
        _listVal = values.values.toList();
        print(_listKey);
        print(_listVal);
        values.forEach((k, v) async {
          setState(() {
            //print('Name : ' + v["Name"]);

            //print(status);
          });
        });
      });
      await _viewAddr(context);
    } catch (e) {
      print(e);

      Alert(context: context, content: Text('ไม่มีข้อมูล'), buttons: [
        DialogButton(
          color: Color(0XFF008C0E),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ]).show();
    }
  }
}
