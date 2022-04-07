import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kmutnb_app/config/constant.dart';
import 'package:kmutnb_app/screens/login/login_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class OfficerHome extends StatefulWidget {
  static const routeName = '/';

  const OfficerHome({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _OfficerHomeState();
  }
}

class _OfficerHomeState extends State<OfficerHome> {
  //dynamic dbfirebase = FirebaseDatabase.instance.reference().child('Student');

  List<String> _dep = [
    'วิศวกรรมศาสตร์',
    'ครุศาสตร์อุตสาหกรรม',
    'เทคโนโลยีและการจัดการอุตสาหกรรม',
    'วิทยาศาสตร์ประยุกต์',
    'วิทยาลัยเทคโนโลยีอุตสาหกรรม',
    'สถาปัตยกรรมและการออกแบบ',
    'อุตสาหกรรมเกษตร',
    'พัฒนาธุรกิจและอุตสาหกรรม',
    'บริหารธุรกิจและอุตสาหกรรมบริการ',
    'วิศวกรรมศาสตร์และเทคโนโลยี',
    'วิทยาศาสตร์ พลังงาน และสิ่งแวดล้อม',
    'บริหารธุรกิจ',
  ];
  String? _selectedDep;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            DropdownButton(
              hint: Text(
                'คณะ',
                textAlign: TextAlign.center,
                style: TextStyle(),
              ), // Not necessary for Option 1
              value: _selectedDep,
              onChanged: (newValue) {
                setState(() {
                  _selectedDep = newValue.toString();
                  //getData();
                });
              },
              items: _dep.map((type) {
                return DropdownMenuItem(
                  child: new Text(type),
                  value: type,
                );
              }).toList(),
            ),
            Expanded(
              child: _selectedDep == null ? readData2() : readData(),
            ),
          ],
        ),
      ),
    );
  }

  Widget readData() {
    return FirebaseAnimatedList(
      query: dbStd,
      itemBuilder: (context, snapshot, animation, index) {
        return snapshot.value['Dep'] == '$_selectedDep'
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
                            Text(
                              '${snapshot.value['Dep']}',
                              style: TextStyle(
                                fontSize: 16,
                                //fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          snapshot.value['Status'] == 'ติดเชื้อ'
                              ? IconButton(
                                  onPressed: () {
                                    getStatus(snapshot.key);
                                  },
                                  icon: Icon(
                                    Icons.timeline,
                                    color: Colors.blue[700],
                                  ),
                                )
                              : Container(),
                          txtState(
                            snapshot.value['Status'],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Container();
      },
    );
  }

  Widget readData2() {
    return FirebaseAnimatedList(
      query: dbStd,
      itemBuilder: (context, snapshot, animation, index) {
        return Container(
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
                      Text(
                        '${snapshot.value['Dep']}',
                        style: TextStyle(
                          fontSize: 16,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    snapshot.value['Status'] == 'ติดเชื้อ'
                        ? IconButton(
                            onPressed: () {
                              getStatus(snapshot.key);
                            },
                            icon: Icon(
                              Icons.timeline,
                              color: Colors.blue[700],
                            ),
                          )
                        : Container(),
                    txtState(
                      snapshot.value['Status'],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget txtState(val) {
    var size = MediaQuery.of(context).size;
    val == null ? val = "ปกติ" : val = val;
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
      width: size.width * 0.2,
      //margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(4.0),
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

  dynamic _listKey, _listVal;
  _viewAddr(context) {
    var size = MediaQuery.of(context).size;

    Alert(
        context: context,
        title: "ไทม์ไลน์",
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            txtTimeLine(0),
            txtTimeLine(6),
            txtTimeLine(7),
            txtTimeLine(8),
            txtTimeLine(9),
            txtTimeLine(10),
            txtTimeLine(11),
            txtTimeLine(12),
            txtTimeLine(13),
            txtTimeLine(1),
            txtTimeLine(2),
            txtTimeLine(3),
            txtTimeLine(4),
            txtTimeLine(5),
          ],
        ),
        buttons: [
          DialogButton(
            color: Color(0XFF008C0E),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  Widget txtTimeLine(i) {
    return Text('วันที่ ' + _listKey[i] + ' : ' + _listVal[i]);
  }

  Future<void> getStatus(id) async {
    try {
      await dbTimeline.child(id).once().then((DataSnapshot snapshot) async {
        //print('Status');
        //print(snapshot.value['Status']);
        // setState(() {
        //   status = snapshot.key;
        //   print(status);
        // });

        Map<dynamic, dynamic> values = snapshot.value;
        //print(values.toString());
        //status.add(values);
        _listKey = values.keys.toList();
        _listVal = values.values.toList();
        print(_listKey);
        print(_listVal);
        values.forEach((k, v) async {
          setState(() {
            //print('Name : ' + v["Name"]);

            //print(status);
          });
        });
      });
      _viewAddr(context);
    } catch (e) {
      print(e);

      Alert(context: context, content: Text('ไม่มีข้อมูล'), buttons: [
        DialogButton(
          color: Color(0XFF008C0E),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ]).show();
    }
  }
}
