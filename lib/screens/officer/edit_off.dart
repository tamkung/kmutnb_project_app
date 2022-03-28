import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kmutnb_app/config/constant.dart';

class EditProfileOff extends StatefulWidget {
  final dynamic off_key, name, email, tel, address;
  const EditProfileOff(
      {required this.off_key, this.name, this.email, this.tel, this.address})
      : super();

  @override
  _EditProfileOffState createState() => _EditProfileOffState();
}

class _EditProfileOffState extends State<EditProfileOff> {
  String? tel, line;
  final formKey = GlobalKey<FormState>();

  Future<void> updateData() async {
    try {
      await dbOff.child(widget.off_key).update({
        'Tel': tel,
        'Line': line,
      }).then((value) {
        print("Success");
        formKey.currentState!.reset();
        Navigator.of(context).pop();
      }).catchError((onError) {
        print(onError.code);
        print(onError.message);
      });
      final snackBar = SnackBar(content: Text('แก้ไขสำเร็จ'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "แก้ไขข้อมูลส่วนตัว",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage("asset/image/bg1.png"),
          //     fit: BoxFit.cover,
          //   ),
          // ),
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        txtID('ชื่อ-นามสกุล', widget.name),
                        txtID('อีเมล', widget.email),
                        txtTel('เบอร์โทรศัพท์', widget.tel),
                        txtAddr('ไอดีไลน์', widget.address),
                        SizedBox(
                          height: 20,
                        ),
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
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget txtID(key, val) {
    //loadData();
    return Container(
      margin: EdgeInsets.fromLTRB(10, 15, 15, 10),
      child: TextFormField(
        enabled: false,
        style: TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: key,
          icon: Icon(Icons.not_interested),
          hintText: val,
        ),
        initialValue: val,
      ),
    );
  }

  Widget txtTel(key, val) {
    //loadData();
    return Container(
      margin: EdgeInsets.fromLTRB(10, 15, 15, 10),
      child: TextFormField(
        enabled: true,
        style: TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: key,
          icon: Icon(Icons.call),
          hintText: key,
        ),
        initialValue: widget.tel != 'null' ? val : '',
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณาป้อนข้อมูล';
          }
        },
        onSaved: (value) {
          tel = value!.trim();
        },
      ),
    );
  }

  Widget txtAddr(key, val) {
    //loadData();
    return Container(
      margin: EdgeInsets.fromLTRB(10, 15, 15, 10),
      child: TextFormField(
        enabled: true,
        style: TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: key,
          icon: Icon(Icons.location_on),
          hintText: key,
        ),
        initialValue: widget.tel != 'null' ? val : '',
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณาป้อนข้อมูล';
          }
        },
        onSaved: (value) {
          line = value!;
        },
      ),
    );
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
            updateData();
            // file == null ? updateData2() : updateData();
            // formKey.currentState!.reset();
            // file = null;
          }
        } else {
          Navigator.pop(context);
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
