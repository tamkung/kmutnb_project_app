import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kmutnb_app/config/constant.dart';
import 'package:kmutnb_app/config/loading.dart';
import 'package:kmutnb_app/screens/login/login_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;
import 'package:sign_button/sign_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  dynamic latitude = "";
  dynamic longitude = "";

  FirebaseStorage storage = FirebaseStorage.instance;
  String? name, imgURL;
  dynamic user;
  dynamic status, help;

  @override
  void initState() {
    super.initState();
    getLocationLogin();

    //user = FirebaseAuth.instance.currentUser!;
    //var size = MediaQuery.of(context).size;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    //dynamic user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer:
          //FirebaseAuth.instance.currentUser == null
          drawerNotLogin(),
      //: drawerLogin(),
      appBar: AppBar(
        backgroundColor: pColor,
        title: Text("Covid App"),
        centerTitle: true,
        actions: [
          /*
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'TestDate');
            },
            icon: Icon(Icons.admin_panel_settings),
          ),
          */
          IconButton(
            onPressed: () async {
              await SignInDemoState().signOutFromGoogle();
            },
            icon: Icon(
              Icons.logout,
              color: pColor,
            ),
          ),
          // IconButton(
          //   onPressed: () {
          //     Navigator.pushNamed(context, 'testpdf');
          //   },
          //   icon: Icon(Icons.upload),
          // ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        color: pColor,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.01,
              ),
              Image.asset(
                "assets/images/logo_kmutnb.png",
                width: size.width * 0.3,
                //height: size.height * 0.4,
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Text(
                homeName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size.height * 0.03,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Image.asset(
                "assets/images/home.png",
                width: size.width * 0.7,
                //height: size.height * 0.4,
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              SignInButton(
                buttonSize: ButtonSize.large,
                buttonType: ButtonType.google,
                onPressed: () async {
                  print('click');
                  print(login);
                  login == false ? login = true : login = false;
                  if (login == true) {
                    await getLocationLogin();

                    await SignInDemoState().signInwithGoogle();

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: Loading(),
                        );
                      },
                    );

                    // EasyLoading.show(status: 'loading...');
                    await chk();
                  } else {
                    print(login);
                  }

                  // login = true;
                  // print('click');
                  // await getLocationLogin();
                  // await SignInDemoState().signInwithGoogle();

                  // new Future.delayed(new Duration(seconds: 3), () async {
                  //   //EasyLoading.dismiss();
                  // });
                  // print('click');
                  // await getLocationLogin();
                  // await SignInDemoState().signInwithGoogle();
                  // await chk();
                  // login = true;
                },
              ),
              /*
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: bColor,
                  padding: EdgeInsets.all(0),
                  shape: StadiumBorder(),
                ),
                child: Image.asset(
                  'assets/images/signin_google.png',
                  height: size.height * 0.065,
                ),
                onPressed: () async {
                  await getLocationLogin();
                  await SignInDemoState().signInwithGoogle();
                  await chk();
                  //Navigator.pushNamed(context, 'Login');
                },
              ),*/
              SizedBox(
                height: size.height * 0.01,
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getLocationLogin() async {
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
          user!.uid, user!.email, user!.displayName, user!.photoURL, "Std");
      Navigator.pop(context);
      await Navigator.pushNamed(context, "Launcher");
      //await SignInDemoState().createData();

    } else if (emailValid2) {
      await createData(
          user!.uid, user!.email, user!.displayName, user!.photoURL, "Off");
      Navigator.pop(context);
      Navigator.pushNamed(context, "OfficerLaun");
    } else if (user!.email == 'tcya30@gmail.com') {
      await createData(
          user!.uid, user!.email, user!.displayName, user!.photoURL, "Off");
      Navigator.pop(context);
      Navigator.pushNamed(context, "OfficerLaun");
    } else if (user!.email == 'hm82529@gmail.com') {
      Navigator.pop(context);
      Navigator.pushNamed(context, "SuperAdmin");
    } else {
      print(emailValid);
      Navigator.pop(context);
      SignInDemoState().signOutFromGoogle();
      _onBasicAlertPressed(context);
    }
  }

  Future<void> createData(uid, email, name, imgURL, auth) async {
    if (auth == "Std") {
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
      for (var i = 3; i <= 4; i++) {
        //print(user!.email[i]);
        n2 = int.parse(email[i]);
        dep.add(n2);
      }
      /*
    'วิศวกรรมศาสตร์',
    'ครุศาสตร์อุตสาหกรรม',
    'วิทยาลัยเทคโนโลยีอุตสาหกรรม',
    'วิทยาศาสตร์ประยุกต์',
    'อุตสาหกรรมเกษตร',
    'เทคโนโลยีและการจัดการอุตสาหกรรม',
    'เทคโนโลยีสารสนเทศและนวัตกรรมดิจิทัล',
    'ศิลปศาสตร์ประยุกต์',
    'บัณฑิตวิทยาลัยวิศวกรรมศาสตร์นานาชาติฯ',
    'บัณฑิตวิทยาลัย',
    'สถาปัตยกรรมและการออกแบบ',
    'วิศวกรรมศาสตร์และเทคโนโลยี',
    'วิทยาศาสตร์ พลังงาน และสิ่งแวดล้อม',
    'บริหารธุรกิจ',
    'วิทยาลัยนานาชาติ',
    'พัฒนาธุรกิจและอุตสาหกรรม',
    'บริหารธุรกิจและอุตสาหกรรมบริการ',
    */
      print(id.join().toString());
      print(dep.join().toString());
      if (int.parse(dep.join()) == 01) {
        dep_name = 'วิศวกรรมศาสตร์';
      } else if (int.parse(dep.join()) == 02) {
        dep_name = 'ครุศาสตร์อุตสาหกรรม';
      } else if (int.parse(dep.join()) == 03) {
        dep_name = 'วิทยาลัยเทคโนโลยีอุตสาหกรรม';
      } else if (int.parse(dep.join()) == 04) {
        dep_name = 'วิทยาศาสตร์ประยุกต์';
      } else if (int.parse(dep.join()) == 05) {
        dep_name = 'อุตสาหกรรมเกษตร';
      } else if (int.parse(dep.join()) == 06) {
        dep_name = 'เทคโนโลยีและการจัดการอุตสาหกรรม';
      } else if (int.parse(dep.join()) == 07) {
        dep_name = 'เทคโนโลยีสารสนเทศและนวัตกรรมดิจิทัล';
      } else if (int.parse(dep.join()) == 08) {
        dep_name = 'ศิลปศาสตร์ประยุกต์';
      } else if (int.parse(dep.join()) == 09) {
        dep_name = 'บัณฑิตวิทยาลัยวิศวกรรมศาสตร์นานาชาติฯ';
      } else if (int.parse(dep.join()) == 10) {
        dep_name = 'บัณฑิตวิทยาลัย';
      } else if (int.parse(dep.join()) == 11) {
        dep_name = 'สถาปัตยกรรมและการออกแบบ';
      } else if (int.parse(dep.join()) == 12) {
        dep_name = 'วิศวกรรมศาสตร์และเทคโนโลยี';
      } else if (int.parse(dep.join()) == 13) {
        dep_name = 'วิทยาศาสตร์ พลังงาน และสิ่งแวดล้อม';
      } else if (int.parse(dep.join()) == 14) {
        dep_name = 'บริหารธุรกิจ';
      } else if (int.parse(dep.join()) == 15) {
        dep_name = 'วิทยาลัยนานาชาติ';
      } else if (int.parse(dep.join()) == 16) {
        dep_name = 'พัฒนาธุรกิจและอุตสาหกรรม';
      } else if (int.parse(dep.join()) == 17) {
        dep_name = 'บริหารธุรกิจและอุตสาหกรรมบริการ';
      } else {
        dep_name = 'ไม่มีข้อมูล';
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
          await dbStd.child(uid).update({
            'Uid': uid,
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
    } else {
      //Off
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
          await dbOff.child(uid).update({
            'Email': email,
            'Name': name,
            'ImgURL': downloadUrl,
          }).then((value) async {
            print("Success");
          }).catchError((onError) {
            print(onError.code);
            print(onError.message);
          });
          final snackBar = SnackBar(content: Text('เข้าสู่ระบบสำเร็จ'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          //setState(() {});
        } else {
          print('Error from image repo ${snapshot.state.toString()}');
          throw ('This file is not an image');
        }
      } on FirebaseException catch (error) {
        print(error);
      }
    }
    //dynamic user = FirebaseAuth.instance.currentUser;
  }

  Future<void> getData(uid) async {
    dbStd.child(uid).once().then((DataSnapshot snapshot) async {
      //print('Status');
      //print(snapshot.value['Status']);

      //print(values.toString());
      status = snapshot.value['Status'];
      help = snapshot.value['Help'];
      // values.forEach((k, v) async {
      //   setState(() {
      //     //print(db.get());
      //     //print('Name : ' + v["Name"]);
      //     status = snapshot.value['Status'];
      //   });
      // });
      if (status == null) {
        await dbStd.child(uid).update({
          'Status': 'ปกติ',
        }).then((value) {
          print("Success");
        }).catchError((onError) {
          print(onError.code);
          print(onError.message);
        });
      }
      if (help == null) {
        await dbStd.child(uid).update({
          'Help': 'ไม่มี',
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

  Widget drawerNotLogin() {
    var size = MediaQuery.of(context).size;
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: pColor,
            ),
            child: Center(
              child: Text(
                'ไม่ได้เข้าสู่ระบบ',
                style: TextStyle(
                  fontSize: size.height * 0.019,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          menu1(context, 'คู่มือโควิด', 'Manual1'),
          sizeBoxDrawer(),
          menu1(context, 'คู่มือการกักตัว', 'Manual2'),
          sizeBoxDrawer(),
          menu1(context, 'สถานที่ตรวจเชื้อ', 'Hospital'),
          sizeBoxDrawer(),
          menu1(context, 'โรงพบาบาลใกล้ฉัน', 'Map'),
          sizeBoxDrawer(),
          menu1(context, 'การประชาสัมพันธ์', 'PR'),
          sizeBoxDrawer(),
        ],
      ),
    );
  }

  //dynamic user = FirebaseAuth.instance.currentUser!;
  Widget drawerLogin() {
    user = FirebaseAuth.instance.currentUser!;
    var size = MediaQuery.of(context).size;
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: pColor,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.01,
                ),
                CircleAvatar(
                  radius: size.height * 0.055,
                  backgroundImage: NetworkImage(user.photoURL!),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Text(
                  user.displayName!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size.height * 0.019,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          menu1(context, 'คู่มือโควิด', 'Manual1'),
          sizeBoxDrawer(),
          menu1(context, 'คู่มือการกักตัว', 'Manual2'),
          sizeBoxDrawer(),
          menu1(context, 'สถานที่ตรวจเชื้อ', 'Hospital'),
          sizeBoxDrawer(),
          menu1(context, 'โรงพยาบาลใกล้ฉัน', 'Map'),
          sizeBoxDrawer(),
          menu1(context, 'การประชาสัมพันธ์', 'PR'),
          sizeBoxDrawer(),
        ],
      ),
    );
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
