import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dateTime = DateTime.now();
  }

  Future<void> sendData() async {
    //for (int i = 0; i < 10; i++) {}
    try {
      await dbTimeline.child(user!.uid).child(user!.displayName).update({
        // 'ชื่อ-นามสกุล': user!.displayName,
        'วันที่ 1 : ${dateList[0]}': textList[0],
        'วันที่ 2 : ${dateList[1]}': textList[1],
        'วันที่ 3 : ${dateList[2]}': textList[2],
      }).then((value) async {
        textList = [];
        formKey.currentState!.reset();
        print("Success");
        final snackBar = SnackBar(content: Text('สำเร็จ'));
        await ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
        actions: [
          IconButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                //updateData();
                sendData();
                // file == null ? updateData2() : updateData();
                //formKey.currentState!.reset();
              }
              print(textList);
              //textList = [];
            },
            icon: Icon(
              Icons.send,
            ),
          ),
        ],
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
    final children = <Widget>[];
    for (var i = 1; i <= 3; i++) {
      var newDate = DateTime(dateTime.year, dateTime.month, dateTime.day - i);
      String formattedDate = DateFormat('dd - MM - yyyy').format(newDate);
      dateList.add(formattedDate);
      children.add(
        txtAddr('วันที่ $i : ' + formattedDate),
      );
    }
    return new ListView(
      children: children,
    );
  }

  Widget txtAddr(date) {
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
}
