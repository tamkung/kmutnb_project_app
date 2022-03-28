import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:kmutnb_app/config/constant.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class OfficerNoti extends StatefulWidget {
  static const routeName = '/';

  const OfficerNoti({Key? key}) : super(key: key);

  @override
  _OfficerNotiState createState() => _OfficerNotiState();
}

class _OfficerNotiState extends State<OfficerNoti> {
  String? datetime;
  Future<void> updateAlert(key, uid, state, name, op) async {
    await timeStamp();
    try {
      await dbAlert.child(key).remove();
      /*
      await dbAlert.child(key).update({'status': op}).then((value) {
        print("Success");
      }).catchError((onError) {
        print(onError.code);
        print(onError.message);
      });*/

      await dbHis.child(name).push().set({
        'tName': name,
        'type': state,
        'timestamp': DateTime.now().toString(),
        'status': 'ยืนยันแล้ว',
      }).then((value) {
        print("Success");
      }).catchError((onError) {
        print(onError.code);
        print(onError.message);
      });
      if (op != 'ช่วยเหลือแล้ว') {
        await dbStd.child(uid).update({
          'Status': state,
        }).then((value) {
          print("Success");
        }).catchError((onError) {
          print(onError.code);
          print(onError.message);
        });
      } else {
        await dbStd.child(uid).update({
          'Help': op,
        }).then((value) {
          print("Success");
        }).catchError((onError) {
          print(onError.code);
          print(onError.message);
        });
      }

      final snackBar = SnackBar(content: Text('สำเร็จ'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      //print(fileName);
      //print(imageFile);
      //print(downloadUrl);
    } on FirebaseException catch (error) {
      print(error);
    }
  }

  // Future<void> history(id, uid, state) async {
  //   try {
  //     final snackBar = SnackBar(content: Text('เพิ่มสำเร็จ'));
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //     //print(fileName);
  //     //print(imageFile);
  //     //print(downloadUrl);
  //     setState(() {});
  //   } on FirebaseException catch (error) {
  //     print(error);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FirebaseAnimatedList(
        query: dbAlert,
        itemBuilder: (context, snapshot, animation, index) {
          return snapshot.value['status'] != "ยืนยันแล้ว"
              ? Container(
                  //height: 100,
                  child: Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Card(
                      elevation: 5,
                      child: ListTile(
                        title: Text(
                          '${snapshot.value['Name']}',
                          style: TextStyle(
                            fontSize: 16,
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  snapshot.value['type'] != null
                                      ? Text(
                                          '${snapshot.value['type']}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            //fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : Text(
                                          '${snapshot.value['Help']}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            //fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                  Text(
                                    '${snapshot.value['status']}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      //fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            snapshot.value['img'] != null
                                ? IconButton(
                                    onPressed: () {
                                      _view(context, snapshot.value['img']);
                                    },
                                    icon: Icon(
                                      Icons.image,
                                      color: Colors.blue[700],
                                    ),
                                  )
                                : Container(),
                            snapshot.value['Addr'] != null
                                ? IconButton(
                                    onPressed: () {
                                      _viewAddr(
                                          context, snapshot.value['Addr']);
                                    },
                                    icon: Icon(
                                      Icons.location_on,
                                      color: Colors.blue[700],
                                    ),
                                  )
                                : Container(),
                            IconButton(
                              onPressed: () {
                                if (snapshot.value['type'] != null) {
                                  updateAlert(
                                      snapshot.key,
                                      '${snapshot.value['uid']}',
                                      '${snapshot.value['type']}',
                                      '${snapshot.value['Name']}',
                                      "ยืนยันแล้ว");
                                } else if (snapshot.value['Help'] ==
                                    'ต้องการอุปกรณ์') {
                                  updateAlert(
                                      snapshot.key,
                                      '${snapshot.value['uid']}',
                                      '${snapshot.value['Help']}',
                                      '${snapshot.value['Name']}',
                                      "ช่วยเหลือแล้ว");
                                } else {
                                  updateAlert(
                                      snapshot.key,
                                      '${snapshot.value['uid']}',
                                      '${snapshot.value['Help']}',
                                      '${snapshot.value['Name']}',
                                      "ช่วยเหลือแล้ว");
                                }
                              },
                              icon: Icon(
                                Icons.check_circle_rounded,
                                color: Colors.lightGreen[700],
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                if (snapshot.value['currentType'] != null) {
                                  await dbStd
                                      .child('${snapshot.value['uid']}')
                                      .update({
                                    'Status': snapshot.value['currentType'],
                                  }).then((value) {
                                    print("Success");
                                    dbAlert.child('${snapshot.key}').remove();
                                  }).catchError((onError) {
                                    print(onError.code);
                                    print(onError.message);
                                  });
                                } else if (snapshot.value['currentHelp'] !=
                                    null) {
                                  await dbStd
                                      .child('${snapshot.value['uid']}')
                                      .update({
                                    'Help': snapshot.value['currentHelp'],
                                  }).then((value) {
                                    print("Success");
                                    dbAlert.child('${snapshot.key}').remove();
                                  }).catchError((onError) {
                                    print(onError.code);
                                    print(onError.message);
                                  });
                                }
                              },
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : Container();
        },
      ),
    );
  }

  _view(context, img) {
    var size = MediaQuery.of(context).size;
    Alert(
        context: context,
        title: "ไฟล์แนบ",
        content: Column(
          children: <Widget>[
            img != ''
                ? Image.network(
                    img,
                    height: size.height * 0.5,
                  )
                : Text('กำลังโหลดรูป')
          ],
        ),
        buttons: [
          DialogButton(
            color: Color(0XFF008C0E),
            onPressed: () {
              var count = 0;
              Navigator.popUntil(context, (route) {
                return count++ == 1;
              });
            },
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  _viewAddr(context, addr) {
    var size = MediaQuery.of(context).size;
    Alert(context: context, title: "ที่อยู่", content: Text(addr), buttons: [
      DialogButton(
        color: Color(0XFF008C0E),
        onPressed: () {
          var count = 0;
          Navigator.popUntil(context, (route) {
            return count++ == 1;
          });
        },
        child: Text(
          "OK",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      )
    ]).show();
  }

  Future timeStamp() async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    datetime = tsdate.day.toString() +
        "/" +
        tsdate.month.toString() +
        "/" +
        tsdate.year.toString();
    print(datetime);
    return datetime;
  }
}
