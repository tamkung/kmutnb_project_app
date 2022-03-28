import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kmutnb_app/config/constant.dart';
import 'package:kmutnb_app/screens/login/login_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  //final controller = Get
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  dynamic latitude = "";
  dynamic longitude = "";

  FirebaseStorage storage = FirebaseStorage.instance;
  String? name, imgURL;
  final dbfirebase = FirebaseDatabase.instance.reference().child('Student');

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              SignInDemoState().signOutFromGoogle();
            },
            icon: Icon(
              Icons.logout,
              color: pColor,
            ),
          ),
        ],
        backgroundColor: pColor,
        title: Text("Login"),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        color: pColor,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
                width: size.width * 1,
              ),
              SizedBox(
                height: 15,
              ),
              Stack(
                children: [
                  Positioned(
                    child: Image.asset(
                      "assets/images/bg_login.png",
                      width: size.width * 0.8,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 0,
                    child: Image.asset(
                      "assets/images/bg_login2.png",
                      width: size.width * 0.8,
                      //height: size.height * 0.4,
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    left: 30,
                    right: 30,
                    child: IconButton(
                      icon: Image.asset('assets/images/signin_google.png'),
                      iconSize: 50,
                      onPressed: () async {
                        //GoogleSignIn().signOut();

                        await SignInDemoState().signInwithGoogle();
                        await chk();
                        //createData('uid', 'email', 'name', 'imgURL');

                        //await Navigator.pushNamed(context, "Launcher");
                        //processSignInWithGoogle();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 35.5,
              ),
              Stack(
                children: [
                  Positioned(
                    child: Image.asset(
                      "assets/images/bg_login3.png",
                      width: size.width * 1,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> chk() async {
    dynamic user = FirebaseAuth.instance.currentUser!;
    print(user!.email);
    //print('object');
    bool emailValid = RegExp(r"^[a-zA-Z0-9]+@email+\.+kmutnb+\.ac+\.th")
        .hasMatch(user!.email);
    bool emailValid2 =
        RegExp(r"^[a-zA-Z0-9]+.[a-zA-z]+@[a-zA-z]+\.+kmutnb+\.ac+\.th")
            .hasMatch(user!.email);
    if (emailValid) {
      print(emailValid);
      print(user!.uid);
      print(user!.email);
      print(user!.displayName);
      print(user!.photoURL);
      await createData(
          user!.uid, user!.email, user!.displayName, user!.photoURL);
      await Navigator.pushNamed(context, "Launcher");
      //await SignInDemoState().createData();

    } else if (user!.email == 'tamkung489@gmail.com') {
      Navigator.pushNamed(context, "OfficerLaun");
    } else {
      print(emailValid);
      SignInDemoState().signOutFromGoogle();
      _onBasicAlertPressed(context);
    }
  }

  //dynamic user = FirebaseAuth.instance.currentUser!;
  dynamic status;
  Future<void> getData(uid) async {
    dbStd.child(uid).once().then((DataSnapshot snapshot) async {
      //  print('Status');
      //  print(snapshot.value['Status']);
      Map<dynamic, dynamic> values = snapshot.value;
      //print(values.toString());
      values.forEach((k, v) async {
        setState(() {
          //print(db.get());
          //print('Name : ' + v["Name"]);
          status = snapshot.value['Status'];
        });
      });
      if (status == null) {
        await dbfirebase.child(uid).update({
          'Status': 'ปกติ',
        }).then((value) {
          print("Success");
        }).catchError((onError) {
          print(onError.code);
          print(onError.message);
        });
      }
      //await _order(widget.tableName);
    });
  }

  Future<void> getLocation() async {
    //คำสั่งดึง Location
    var location = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    print(location);
    print(location.latitude);
    print(location.longitude);

    setState(() {
      latitude = '${location.latitude}';
      longitude = '${location.longitude}';
    });

    // แปลง ละติจูด และลองจิจูด เป็น สถานที่จริง
    var address =
        await placemarkFromCoordinates(location.latitude, location.longitude);
    print(address);
  }

  Future<void> createData(uid, email, name, imgURL) async {
    //dynamic user = FirebaseAuth.instance.currentUser;
    List<int> id = [];
    List<int> dep = [];
    int n1, n2;
    var dep_name;
    //print(user!.email.length);
    for (var i = 1; i <= 13; i++) {
      //print(user!.email[i]);
      n1 = int.parse(email[i]);
      id.add(n1);
    }
    for (var i = 4; i <= 6; i++) {
      //print(user!.email[i]);
      n2 = int.parse(email[i]);
      dep.add(n2);
    }

    print(id.join().toString());
    print(dep.join().toString());
    if (int.parse(dep.join()) == 204) {
      dep_name = 'ครุศาสตร์อุตสาหกรรม';
    }
    var url = Uri.parse(imgURL);
    final http.Response responseData = await http.get(url);
    Uint8List uint8list = responseData.bodyBytes;
    var buffer = uint8list.buffer;
    ByteData byteData = ByteData.view(buffer);
    var tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/img').writeAsBytes(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    try {
      TaskSnapshot snapshot =
          await storage.ref().child("Image/$name").putFile(file);
      if (snapshot.state == TaskState.success) {
        final String downloadUrl = await snapshot.ref.getDownloadURL();
        await dbfirebase.child(uid).update({
          'Email': email,
          'Name': name,
          'ImgURL': downloadUrl,
          'Dep': dep_name,
          'Std_ID': id.join().toString(),
          'latitude': latitude,
          'longitude': longitude,
        }).then((value) async {
          print("Success");
          await getData(uid);
        }).catchError((onError) {
          print(onError.code);
          print(onError.message);
        });
        final snackBar = SnackBar(content: Text('เข้าสู่ระบบสำเร็จ'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        print(downloadUrl);
        print(latitude);
        print(longitude);
        //setState(() {});
      } else {
        print('Error from image repo ${snapshot.state.toString()}');
        throw ('This file is not an image');
      }
    } on FirebaseException catch (error) {
      print(error);
    }
  }

  _onBasicAlertPressed(context) {
    Alert(
      style: AlertStyle(
        backgroundColor: Colors.white,
        titleStyle: TextStyle(fontSize: 28),
      ),
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          color: bColor,
          onPressed: () => Navigator.pop(context),
          width: 120,
        ),
      ],
      context: context,
      title: "กรุณาใช้อีเมลของ มจพ.",
      //desc: "Flutter is more awesome with RFlutter Alert.",
    ).show();
  }
}
