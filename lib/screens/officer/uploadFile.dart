import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:kmutnb_app/config/constant.dart';
import 'package:path/path.dart' as path;
import 'package:rflutter_alert/rflutter_alert.dart';

class UploadFire extends StatefulWidget {
  const UploadFire({Key? key}) : super(key: key);

  @override
  _UploadFireState createState() => _UploadFireState();
}

class _UploadFireState extends State<UploadFire> {
  FirebaseStorage storage = FirebaseStorage.instance;
  final formKey = GlobalKey<FormState>();

  File? file;
  String? fileName, name;
  List<String> _type = [
    'คู่มือโควิด',
    'คู่มือการกักตัว',
    'การประชาสัมพันธ์',
  ];
  String? _selectedType;
  Future upload() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc'],
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
        /*
      await storage.ref('Image').child(fileName!).putFile(
            imageFile!,
            SettableMetadata(
              customMetadata: {
                'uploaded_by': 'Admin',
                'description': 'Some description...'
              },
            ),
          );
      */
        TaskSnapshot snapshot =
            await storage.ref().child("File/$name").putFile(file!);
        if (snapshot.state == TaskState.success) {
          final String downloadUrl = await snapshot.ref.getDownloadURL();
          await dbFile.push().set({
            'tName': name,
            'type': _selectedType,
            'FileURL': downloadUrl,
          }).then((value) {
            formKey.currentState!.reset();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              upload();
            },
            icon: Icon(Icons.file_copy),
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            txtName(),
            Center(
              child: DropdownButton(
                hint: Text('กรุณาเลือกประเภท'), // Not necessary for Option 1
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
            Center(
              child: _selectedType == null
                  ? Text('No Type')
                  : Text(_selectedType!),
            ),
            Center(
              child: fileName == null ? Text('No File') : Text(fileName!),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            createData();
            /*
            setState(() {
              fileName = null;
              _selectedType = null;
              //_locations = null;
            });*/

          }
          //createData();
        },
        child: Icon(Icons.upload),
      ),
    );
  }

  Widget txtName() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 15, 15, 10),
      child: TextFormField(
        style: TextStyle(
          fontSize: 20,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          labelText: 'ชื่อไฟล์ :',
          icon: Icon(Icons.file_upload),
          hintText: 'Input your file name',
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
}
