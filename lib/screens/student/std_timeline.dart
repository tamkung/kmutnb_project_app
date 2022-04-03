import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kmutnb_app/config/constant.dart';

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
      ),
      body: Container(
        child: Form(
          key: formKey,
          child: chk == false ? showDate() : showDate2(),
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

  Widget showDate2() {
    var size = MediaQuery.of(context).size;
    final children = <Widget>[];
    for (var i = 1; i <= 3; i++) {
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
          status = k;
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
}
