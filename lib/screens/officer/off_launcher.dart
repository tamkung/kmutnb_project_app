import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kmutnb_app/config/constant.dart';
import 'package:kmutnb_app/screens/login/login_screen.dart';
import 'package:kmutnb_app/screens/officer/off_home.dart';
import 'package:kmutnb_app/screens/officer/off_map.dart';
import 'package:kmutnb_app/screens/officer/off_noti.dart';
import 'package:kmutnb_app/screens/officer/off_upload.dart';
import 'package:kmutnb_app/screens/officer/off_profile.dart';

class OfficerLauncher extends StatefulWidget {
  static const routeName = '/';

  const OfficerLauncher({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _OfficerLauncherState();
  }
}

class _OfficerLauncherState extends State<OfficerLauncher> {
  int _selectedIndex = 0;
  String titles = "เจ้าหน้าที่";
  final List<Widget> _pageWidget = <Widget>[
    const OfficerHome(),
    const OfficerMap(),
    const OfficerUpload(),
    const OfficerNoti(),
    const OfficerProfile(),
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
      icon: Icon(Icons.upload_file),
      label: 'Upload',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.notifications),
      label: 'Notification',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (_selectedIndex == 0) {
        titles = "รายชื่อนักศึกษา";
      } else if (_selectedIndex == 1) {
        titles = "แผนที่";
      } else if (_selectedIndex == 2) {
        titles = "อัปโหลดเอกสาร";
      } else if (_selectedIndex == 3) {
        titles = "การแจ้งเตือน";
      } else if (_selectedIndex == 4) {
        titles = "โปรไฟล์";
      }

      print(titles);
    });
  }

  @override
  void initState() {
    EasyLoading.dismiss();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: drawerAppBarLogin(context),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              SignInDemoState().signOutFromGoogle();
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

  dynamic user = FirebaseAuth.instance.currentUser!;

  Widget drawerAppBarLogin(context) {
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
          menu1(context, 'เบอร์สายด่วน', 'Tel'),
          sizeBoxDrawer(),
        ],
      ),
    );
  }
}
