import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kmutnb_app/backend/recommend.dart';
import 'package:kmutnb_app/config/constant.dart';
import 'package:kmutnb_app/models/slide.dart';
import 'package:kmutnb_app/screens/student/notifirebase.dart';
import 'package:kmutnb_app/screens/student/help/keep.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:path/path.dart' as path;

class StudentHelp extends StatefulWidget {
  static const routeName = '/';

  const StudentHelp({Key? key}) : super(key: key);

  @override
  _StudentHelpState createState() => _StudentHelpState();
}

class _StudentHelpState extends State<StudentHelp> {
  bool isMount = true;
  dynamic user = FirebaseAuth.instance.currentUser!;
  late Timer timer;
  dynamic status = '';
  late FirebaseMessaging messaging;
  String? msg;
  FirebaseStorage storage = FirebaseStorage.instance;

  var ct;
  List<Slide> slide = getSlideList();

  final formKey = GlobalKey<FormState>();
  var file;
  final picker = ImagePicker();
  File? imageFile;
  String? fileName;
  String? fileVal;

  @override
  void initState() {
    super.initState();
    if (isMount) {
      setState(() {
        timer = Timer.periodic(Duration(seconds: 3), (Timer t) {
          getStatus();
          // print(mounted.toString());
        });
      });
    }
    @override
    void dispose() {
      isMount = false;
      timer.cancel();
      super.dispose();
    }

    //timer = Timer.periodic(Duration(seconds: 5), (Timer t) => getStatus());
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      print(value);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      print('Message clicked!');
      await Navigator.pushNamed(context, 'Login');
    });
    /*
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification!.body);
      print(event.data.values);
      msg = event.notification!.body.toString();
      print('tes' + '$msg');
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Notification"),
              content: Text(event.notification!.body!),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });*/
    messaging.subscribeToTopic("messaging");
    //FirebaseMessaging.onBackgroundMessage(_messageHandler);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      color: pColor,
      child: status != ''
          ? Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(20),
                      //   boxShadow: [
                      //     BoxShadow(
                      //          color: Colors.black.withOpacity(0.7),
                      //         )
                      //   ],
                      // ),
                      child: Container(
                        height: 100,
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          children: buildSlide(),
                        ),
                      ),
                      //color: Colors.amber,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        //color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      //height: 50,
                      child: Column(
                        children: [
                          Text(
                            'ขอเปลี่ยนสถานะ : ' + '$status',
                            style: TextStyle(
                              fontSize: size.height * 0.03,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: status != ''
                                ? SingleChildScrollView(
                                    child: chk(),
                                  )
                                : Center(
                                    child: txtload,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
          : Center(
              child: txtload,
            ),
    );
  }

  Widget chk() {
    dynamic contain;
    if (status == "ปกติ") {
      contain = Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          sizeBox02(),
          image("assets/images/keep.png"),
          sizeBox02(),
          btn('สถานะกักตัว', Color(0xFFFFC56D), 'StdRateKeep'),
          sizeBox02(),
          image("assets/images/infect.png"),
          sizeBox02(),
          btn('สถานะติดเชื้อ', Color(0xFFFF5454), 'StdRateInfect'),
          sizeBox02(),
        ],
      );
    } else if (status == "กักตัว") {
      contain = Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          sizeBox02(),
          image("assets/images/normal.png"),
          sizeBox02(),
          btn('สถานะปกติ', Color(0xFF008C0E), 'normal'),
          sizeBox02(),
          image("assets/images/infect.png"),
          sizeBox02(),
          btn('สถานะติดเชื้อ', Color(0xFFFF5454), 'StdRateInfect'),
          sizeBox02(),
        ],
      );
    } else if (status == "ติดเชื้อ") {
      contain = Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          sizeBox02(),
          image("assets/images/normal.png"),
          sizeBox02(),
          fileName == null ? Text('ไม่มีไฟล์แนบ') : Text(fileVal!),
          sizeBox02(),
          btn('สถานะปกติ', Color(0xFF008C0E), 'normalImg'),
          sizeBox02(),
        ],
      );
    } else if (status == "รอยืนยัน") {
      contain = Text('กรุณารอการยืนยันจากเจ้าหน้าที่');
    }

    return contain;
  }

  Widget btn(name, color, tap) {
    var size = MediaQuery.of(context).size;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: color,
        padding: EdgeInsets.fromLTRB(45, 13, 45, 13),
        shape: StadiumBorder(),
      ),
      child: Text(
        name,
        style: TextStyle(
          fontSize: size.height * 0.026,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () async {
        print(status);
        if (tap == 'normal') {
          _onAlertButtonPressed(context);
        } else if (tap == 'normalImg') {
          btn_img();
        } else if (fileVal == 'แนบไฟล์เรียบร้อย') {
          AllFunction().postRequest(user.displayName, 'ปกติ');
          await createDataNormal();
        } else {
          Navigator.pushNamed(context, tap);
        }
        //_onAlertButtonPressed(context);
        // postRequest('ปกติ');
        // await createData('ปกติ');
      },
    );
  }

  Widget image(url) {
    var size = MediaQuery.of(context).size;
    return Image.asset(
      url,
      width: size.width * 0.22,
      //height: size.height * 0.4,
    );
  }

  Widget sizeBox02() {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.02,
    );
  }

  Future<void> getStatus() async {
    dbStd.child(user.uid!).once().then((DataSnapshot snapshot) async {
      //print('Status');
      //print(snapshot.value['Status']);
      setState(() {
        status = snapshot.value['Status'];
        print(status);
      });

      // Map<dynamic, dynamic> values = snapshot.value;
      // //print(values.toString());
      // values.forEach((k, v) async {
      //   setState(() {
      //     //print(db.get());
      //     //print('Name : ' + v["Name"]);
      //     status = snapshot.value['Status'];
      //     print(status);
      //   });
      // });
      // status = snapshot.value['Status'];
    });
  }

  // Future<http.Response> postRequest(val) async {
  //   var url = 'https://fcm.googleapis.com/fcm/send';
  //   var token =
  //       'AAAAe_-6loo:APA91bHk4ZRhBGeUjKSKxqOAc1eHD0r2ucEBs7MvB20hbpw6uga2Gm_sWV1P7xVkDumIcX7RNuL9nwvc4RK4ZZzqvH_OgHLO2WA-PLA2HNu_SlRVqHI0yHEPS3elKZATyB4dr-H2XF_S';

  //   Map data = {
  //     "to": "/topics/messaging",
  //     "notification": {"title": "${user.displayName}", "body": "$val"},
  //     "data": {"msgId": "msg_12342"}
  //   };
  //   //encode Map to JSON
  //   var body = json.encode(data);

  //   var response = await http.post(
  //     Uri.parse(url),
  //     headers: {
  //       "Content-Type": "application/json",
  //       'Authorization': 'Bearer $token',
  //     },
  //     body: body,
  //   );
  //   print("${response.statusCode}");
  //   print("${response.body}");
  //   return response;
  // }

  Future<void> createData(val) async {
    try {
      await dbAlert.push().set({
        'uid': user.uid!,
        'Name': user.displayName,
        'currentType': status,
        'type': val,
        'status': 'รอยืนยัน',
      }).then((value) {
        print("Success");
      }).catchError((onError) {
        print(onError.code);
        print(onError.message);
      });

      await dbStd.child(user.uid!).update({
        'Status': 'รอยืนยัน',
      }).then((value) {
        print("Success");
      }).catchError((onError) {
        print(onError.code);
        print(onError.message);
      });

      final snackBar = SnackBar(content: Text('อัปเดตสำเร็จ'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      setState(() {});
    } on FirebaseException catch (error) {
      print(error);
    }
  }

  _onAlertButtonPressed(context) {
    Alert(
      context: context,
      type: AlertType.info,
      title: "ต้องการเปลี่ยนสถานะเป็นปกติ\nใช่หรือไม่",
      buttons: [
        DialogButton(
          child: Text(
            "ใช่",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          onPressed: () async {
            AllFunction().postRequest(user.displayName, 'ปกติ');
            await createData('ปกติ');
            Navigator.pop(context);
          },
          color: Colors.green,
        ),
        DialogButton(
          child: Text(
            "ไม่ใช่",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () => Navigator.pop(context),
          color: Colors.red,
        )
      ],
    ).show();
  }

  void btn_img() {
    var size = MediaQuery.of(context).size;

    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Center(child: const Text('อัปโหลดรูปภาพ')),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    _upload('camera');
                  },
                  icon: Icon(
                    Icons.camera,
                    size: size.height * 0.05,
                  ),
                ),
                Text('กล้องถ่ายรูป'),
              ],
            ),
            SizedBox(
              width: size.width * 0.1,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    _upload('gallery');
                  },
                  icon: Icon(
                    Icons.folder_open,
                    size: size.height * 0.05,
                  ),
                ),
                Text('ไฟล์ภายใน'),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              onPressed: () async {
                if (file != null) {
                  Navigator.pop(context);
                  AllFunction().postRequest(user.displayName, 'ปกติ');
                  await createDataNormal();
                } else {
                  _alertFail(context, 'กรุณาเพิ่มรูปภาพ');
                }
              },
              child: const Text('อัปโหลด'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _upload(String inputSource) async {
    PickedFile? pickedImage;
    try {
      // ignore: deprecated_member_use
      pickedImage = await picker.getImage(
          source: inputSource == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery);

      fileName = path.basename(pickedImage!.path);
      setState(() {
        file = File(pickedImage!.path);
        fileVal = 'แนบไฟล์เรียบร้อย';
      });

      imageFile = File(pickedImage.path);
      print(fileName);
      // AllFunction().postRequest(user.displayName, 'ปกติ');
      // await createDataNormal();
      // Navigator.pop(context);
    } catch (err) {
      print(err);
    }
  }

  Future<void> createDataNormal() async {
    //if (_value1==1)

    try {
      TaskSnapshot snapshot =
          await storage.ref().child("Image/$fileName").putFile(file);
      if (snapshot.state == TaskState.success) {
        final String downloadUrl = await snapshot.ref.getDownloadURL();

        await dbAlert.push().set({
          'uid': user.uid!,
          'Name': user!.displayName,
          'currentType': allState,
          'type': 'ปกติ',
          'img': downloadUrl,
          'status': 'รอยืนยัน',
        }).then((value) {
          print("Success");
        }).catchError((onError) {
          print(onError.code);
          print(onError.message);
        });

        await dbStd.child(user.uid!).update({
          'Status': 'รอยืนยัน',
        }).then((value) {
          print("Success");
        }).catchError((onError) {
          print(onError.code);
          print(onError.message);
        });
        fileName = null;
        imageFile = null;
        file = null;
        final snackBar = SnackBar(content: Text('อัปเดตสำเร็จ'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        print('Error from image repo ${snapshot.state.toString()}');
        throw ('This file is not an image');
      }

      //setState(() {});

    } on FirebaseException catch (error) {
      print(error);
    }

    //dynamic user = FirebaseAuth.instance.currentUser;
  }

  _alertFail(context, title) {
    Alert(
      style: AlertStyle(
        backgroundColor: Colors.white,
        titleStyle: TextStyle(fontSize: 28),
      ),
      buttons: [
        DialogButton(
          color: Color(0XFF008C0E),
          child: Text(
            "OK",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          width: 120,
        ),
      ],
      context: context,
      title: title,
      //desc: "Flutter is more awesome with RFlutter Alert.",
    ).show();
  }

  List<Widget> buildSlide() {
    List<Widget> list = [];
    for (var i = 0; i < slide.length; i++) {
      list.add(buildSlideList(slide[i], ct));
    }
    return list;
  }
}
