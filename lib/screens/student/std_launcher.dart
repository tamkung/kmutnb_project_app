import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kmutnb_app/config/constant.dart';
import 'package:kmutnb_app/screens/student/notifirebase.dart';
import 'package:kmutnb_app/screens/login/login_screen.dart';
import 'package:kmutnb_app/screens/student/std_help.dart';
import 'package:kmutnb_app/screens/student/std_home.dart';
import 'package:kmutnb_app/screens/student/std_map.dart';
import 'package:kmutnb_app/screens/student/std_noti.dart';
import 'package:kmutnb_app/screens/student/std_profile.dart';

class Launcher extends StatefulWidget {
  static const routeName = '/';

  const Launcher({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LauncherState();
  }
}

class _LauncherState extends State<Launcher> {
  bool isMount = true;
  dynamic user = FirebaseAuth.instance.currentUser!;
  late Timer timer;
  dynamic status = '';
  dynamic help = '';
  int _selectedIndex = 0;
  String titles = "นักศึกษา";

  dynamic latitude = "";
  dynamic longitude = "";

  final List<Widget> _pageWidget = <Widget>[
    const StudentHome(),
    const StudentMap(),
    const StudentHelp(),
    //const StudentNoti(),
    const StudentProfile(),
  ];
  final List<BottomNavigationBarItem> _menuBar = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.mapMarked),
      label: 'Map',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.live_help),
      label: 'Help',
    ),
    // BottomNavigationBarItem(
    //   icon: Icon(Icons.notifications),
    //   label: 'Notification',
    // ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        titles = "นักศึกษา";
      } else if (_selectedIndex == 1) {
        titles = "แผนที่";
      } else if (_selectedIndex == 2) {
        titles = "ขอเปลี่ยนสถานะ";
        // } else if (_selectedIndex == 3) {
        //   titles = "การแจ้งเตือน";
      } else if (_selectedIndex == 3) {
        titles = "โปรไฟล์";
      }
    });
  }

  @override
  void initState() {
    EasyLoading.dismiss();
    super.initState();
    //getStatus();
    //getData();
    if (isMount) {
      setState(() {
        timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
          getLocation();
          getStatus();
        });
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    isMount = false;
    timer.cancel();
    super.dispose();
  }

  // void setStateIfMounted(f) {
  //   if (mounted) setState(f);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawerAppBarLogin(context),
      appBar: AppBar(
        actions: [
          // IconButton(
          //   onPressed: () {
          //     _noti(user.displayName!);
          //   },
          //   icon: Icon(Icons.notifications),
          // ),
          IconButton(
            onPressed: () async {
              await SignInDemoState().signOutFromGoogle();
              Navigator.pop(context);
            },
            icon: Icon(Icons.logout),
          ),
        ],
        title: Text(
          titles,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _pageWidget.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: _menuBar,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget drawerAppBarLogin(context) {
    var size = MediaQuery.of(context).size;
    List<int> id = [];
    List<int> dep = [];
    int n1, n2;
    var dep_name;
    //print(user!.email.length);
    for (var i = 1; i <= 13; i++) {
      //print(user!.email[i]);
      n1 = int.parse(user!.email[i]);
      id.add(n1);
    }
    for (var i = 3; i <= 4; i++) {
      //print(user!.email[i]);
      n2 = int.parse(user!.email[i]);
      dep.add(n2);
    }

    //print(id.join().toString());
    //print(dep.join().toString());
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
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: pColor,
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: CircleAvatar(
                    radius: 35.0,
                    backgroundImage: NetworkImage(user.photoURL!),
                  ),
                ),
                Positioned(
                  top: -15,
                  left: 100,
                  child: Row(
                    children: [
                      Text(
                        'สถานะ : ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      txtState(status),
                    ],
                  ),
                ),
                Positioned(
                  top: 45,
                  left: 75,
                  child: Row(
                    children: [
                      help != null
                          ? Text(
                              'ช่วยเหลือ : ' + '$help',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Text(
                              'ช่วยเหลือ : ' + 'ไม่มี',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 45,
                  left: 0,
                  child: Row(
                    children: [
                      Text(
                        'รหัสนักศึกษา : ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        id.join().toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 23,
                  left: 0,
                  child: Row(
                    children: [
                      Text(
                        'ชื่อ-นามสกุล : ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user.displayName!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Row(
                    children: [
                      Text(
                        'คณะ : ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        dep_name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          status == '' || status == 'ปกติ' || status == 'รอยืนยัน'
              ? Column(
                  children: [
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
                )
              : chk(),

          //chk(),
          /*
          status != 'ปกติ'
              ? menu1(context, 'ขอความช่วยเหลือ', 'HelpMenu')
              : Container(),
          status != 'ปกติ' ? sizeBoxDrawer() : Container(),*/
        ],
      ),
    );
  }

  Widget txtState(val) {
    var color = Colors.white;
    if (val == "ปกติ") {
      color = Colors.green;
    } else if (val == "กักตัว") {
      color = Colors.amber;
    } else if (val == "ติดเชื้อ") {
      color = Colors.red;
    } else if (val == "รอยืนยัน") {
      color = Colors.pink.shade400;
    } else if (val == "รักษาหายแล้ว") {
      color = Colors.blue;
    }
    return Container(
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(width: 3.0, color: color),
        borderRadius: BorderRadius.all(
            Radius.circular(8.0) //                 <--- border radius here
            ),
      ),
      child: Text(
        val,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget chk() {
    dynamic value;
    if (status == 'กักตัว') {
      value = Column(
        children: [
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
          menu1(context, 'ขอความช่วยเหลือ', 'HelpMenu'),
          sizeBoxDrawer(),
        ],
      );
    } else if (status == 'ติดเชื้อ') {
      value = Column(
        children: [
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
          menu1(context, 'ขอความช่วยเหลือ', 'HelpMenu'),
          sizeBoxDrawer(),
          menu1(context, 'ประวัติไทม์ไลน์ย้อนหลัง', 'Timeline'),
          sizeBoxDrawer(),
        ],
      );
    }
    return value;
  }

  Future _noti(String name2) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NotiFire(
          name2: name2,
        ),
      ),
    );
    print(name2);
  }

  Future<void> getLocation() async {
    var location = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      latitude = '${location.latitude}';
      longitude = '${location.longitude}';
    });
    await dbStd.child(user!.uid).update({
      'latitude': latitude,
      'longitude': longitude,
    }).then((value) {
      print("Success");
      print(location);
    }).catchError((onError) {
      print(onError.code);
      print(onError.message);
    });
  }

  Future<void> getStatus() async {
    dbStd.child(user.uid!).once().then((DataSnapshot snapshot) async {
      //print('Status');
      //print(snapshot.value['Status']);
      status = snapshot.value['Status'];
      help = snapshot.value['Help'];
      allState = snapshot.value['Status'];
      print(status);
      print(help);
      /*
      Map<dynamic, dynamic> values = snapshot.value;
      //print(values.toString());
      values.forEach((k, v) async {
        // if (this.mounted) {
        //   // check whether the state object is in tree
        //   setState(() {
        //     status = snapshot.value['Status'];
        //     print(status);
        //   });
        // }
        setState(() {
          //print(db.get());
          //print('Name : ' + v["Name"]);
          status = snapshot.value['Status'];
          print(status);
        });
      });
      */
      // status = snapshot.value['Status'];
    });
  }
}
