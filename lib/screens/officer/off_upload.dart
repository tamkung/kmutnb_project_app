import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:kmutnb_app/config/constant.dart';
import 'package:path/path.dart' as path;
import 'package:rflutter_alert/rflutter_alert.dart';

class OfficerUpload extends StatefulWidget {
  static const routeName = '/';

  const OfficerUpload({Key? key}) : super(key: key);

  @override
  _OfficerUploadState createState() => _OfficerUploadState();
}

class _OfficerUploadState extends State<OfficerUpload> {
  FirebaseStorage storage = FirebaseStorage.instance;
  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();

  File? file;
  String? fileName, name;
  String? telName, tel;
  List<String> _type = [
    'คู่มือโควิด',
    'คู่มือการกักตัว',
    'การประชาสัมพันธ์',
  ];
  String? _selectedType;
  Future upload() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      file = File(result.files.single.path!);
      setState(() {
        fileName = path.basename(file!.path);
      });
    } else {
      // User canceled the picker
    }
  }

  Future<void> createData() async {
    if (file != null && _selectedType != null) {
      try {
        TaskSnapshot snapshot =
            await storage.ref().child("File/$name").putFile(file!);
        if (snapshot.state == TaskState.success) {
          final String downloadUrl = await snapshot.ref.getDownloadURL();
          await dbFile.push().set({
            'tName': name,
            'type': _selectedType,
            'FileURL': downloadUrl,
          }).then((value) {
            formKey1.currentState!.reset();
            file = null;
            fileName = null;
            _selectedType = null;
            print("Success");
          }).catchError((onError) {
            print(onError.code);
            print(onError.message);
          });
          final snackBar = SnackBar(content: Text('เพิ่มสำเร็จ'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          print(fileName);
          //print(imageFile);
          print(downloadUrl);
          setState(() {});
        } else {
          print('Error from image repo ${snapshot.state.toString()}');
          throw ('This file is not an image');
        }
      } on FirebaseException catch (error) {
        print(error);
      }
    } else {
      _onBasicAlertPressed(context);
    }
  }

  Future<void> createDataTel() async {
    try {
      await dbTel.push().set({
        'Name': telName,
        'Tel': tel,
      }).then((value) {
        formKey2.currentState!.reset();
        telName = null;
        tel = null;
        print("Success");
      }).catchError((onError) {
        print(onError.code);
        print(onError.message);
      });
      final snackBar = SnackBar(content: Text('เพิ่มสำเร็จ'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on FirebaseException catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          Form(
            key: formKey1,
            child: Column(
              children: [
                txtName(),
                Center(
                  child: DropdownButton(
                    hint:
                        Text('กรุณาเลือกประเภท'), // Not necessary for Option 1
                    value: _selectedType,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedType = newValue.toString();
                      });
                    },
                    items: _type.map((type) {
                      return DropdownMenuItem(
                        child: new Text(type),
                        value: type,
                      );
                    }).toList(),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        upload();
                      },
                      icon: Icon(
                        Icons.upload_file,
                        size: size.height * 0.05,
                      ),
                    ),
                    fileName == null
                        ? Text('ไม่มีไฟล์แนบ')
                        : Flexible(child: Text(fileName!)),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.023,
                ),
                btn('อัปโหลดไฟล์'),
                SizedBox(
                  height: size.height * 0.023,
                ),
              ],
            ),
          ),
          Container(
            color: Colors.black,
            width: size.width,
            height: 1,
          ),
          Form(
            key: formKey2,
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.023,
                ),
                Text(
                  'เพิ่มเบอร์สายด่วน',
                  style: TextStyle(
                    fontSize: size.width * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.023,
                ),
                txtTelName(),
                SizedBox(
                  height: size.height * 0.023,
                ),
                txtTel(),
                SizedBox(
                  height: size.height * 0.023,
                ),
                btn('อัปโหลดเบอร์'),
                SizedBox(
                  height: size.height * 0.023,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget txtName() {
    var size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.fromLTRB(10, 15, 15, 10),
      child: TextFormField(
        style: TextStyle(
          fontSize: size.width * 0.05,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          labelText: 'ชื่อไฟล์ :',
          icon: Icon(Icons.file_upload),
          hintText: 'ป้อนชื่อไฟล์',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณาป้อนข้อมูล';
          }
        },
        onSaved: (value) {
          name = value!.trim();
        },
      ),
    );
  }

  Widget txtTelName() {
    var size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.fromLTRB(10, 15, 15, 10),
      child: TextFormField(
        style: TextStyle(
          fontSize: size.width * 0.05,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          labelText: 'ชื่อสายด่วน :',
          icon: Icon(Icons.file_upload),
          hintText: 'ป้อนชื่อสายด่วน',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณาป้อนข้อมูล';
          }
        },
        onSaved: (value) {
          telName = value!.trim();
        },
      ),
    );
  }

  Widget txtTel() {
    var size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.fromLTRB(10, 15, 15, 10),
      child: TextFormField(
        style: TextStyle(
          fontSize: size.width * 0.05,
        ),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          labelText: 'ชื่อเบอร์สายด่วน :',
          icon: Icon(Icons.file_upload),
          hintText: 'ป้อนชื่อเบอร์สายด่วน',
        ),
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

  _onBasicAlertPressed(context) {
    Alert(
      style: AlertStyle(
        backgroundColor: pColor,
        titleStyle: TextStyle(fontSize: 32),
      ),
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          color: tColor,
          onPressed: () => Navigator.pop(context),
          width: 120,
        ),
      ],
      context: context,
      title: "กรุณาเพิ่มไฟล์",
      //desc: "Flutter is more awesome with RFlutter Alert.",
    ).show();
  }

  Widget btn(name) {
    var size = MediaQuery.of(context).size;
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          padding: EdgeInsets.all(12),
          shape: StadiumBorder(),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.upload),
            Text(
              name,
              style: TextStyle(
                fontSize: size.height * 0.02,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        onPressed: () async {
          print(name);
          if (name == 'อัปโหลดไฟล์') {
            if (formKey1.currentState!.validate()) {
              formKey1.currentState!.save();
              createData();
            }
          } else {
            if (formKey2.currentState!.validate()) {
              formKey2.currentState!.save();
              createDataTel();
            }
          }
        });
  }
}
