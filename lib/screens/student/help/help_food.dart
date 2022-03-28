import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:kmutnb_app/config/constant.dart';

class HelpFood extends StatefulWidget {
  const HelpFood({Key? key}) : super(key: key);

  @override
  State<HelpFood> createState() => _HelpFoodState();
}

class _HelpFoodState extends State<HelpFood> {
  dynamic user = FirebaseAuth.instance.currentUser!;
  dynamic addr, currentHelp;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("อาหาร"),
        centerTitle: true,
      ),
      body: Container(
        height: size.height,
        padding: EdgeInsets.all(5),
        color: pColor,
        child: Container(
          margin: EdgeInsets.all(5),
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
          child: SingleChildScrollView(
            child: Column(
              //mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: size.height * 0.025,
                ),
                Text(
                  'คุณต้องการขอความช่วยเหลืออาหาร',
                  style: TextStyle(
                    fontSize: size.height * 0.025,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Image.asset(
                  "assets/images/food_screen.png",
                  height: 200,
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(5),
                  height: size.height * 0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    //color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0XFFD7D7D7),
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: FirebaseAnimatedList(
                    query: dbStd.orderByKey().equalTo(user.uid!),
                    itemBuilder: (context, snapshot, animation, index) {
                      addr = snapshot.value['Address'];
                      currentHelp = snapshot.value['Help'];
                      return Container(
                        alignment: Alignment.center,
                        //color: pColor,
                        //height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: size.height * 0.005,
                            ),
                            contain(
                                'ชื่อ-นามสกุล :', '${snapshot.value['Name']}'),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            contain(
                                'เบอร์โทรศัพท์ :', '${snapshot.value['Tel']}'),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            contain(
                                'ที่อยู่ :', '${snapshot.value['Address']}'),
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _btn('ยืนยัน', Color(0xFF008C0E)),
                    SizedBox(
                      width: size.width * 0.05,
                    ),
                    _btn('ยกเลิก', Color(0xFFBA2100)),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _btn(name, color) {
    var size = MediaQuery.of(context).size;
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          color,
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              color: color,
              //width: 2.0,
            ),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          name,
          style: TextStyle(
            fontSize: size.height * 0.026,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onPressed: () async {
        if (name == "ยืนยัน") {
          AllFunction().postRequest(user.displayName, 'ต้องการอาหาร');
          await createData('ต้องการอาหาร');
          print(name);
        } else {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget contain(name, val) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      //color: Colors.amberAccent,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              //color: Colors.blue,
              alignment: Alignment.centerRight,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(name),
                ],
              ),
            ),
          ),
          SizedBox(
            width: size.width * 0.02,
          ),
          Expanded(
            flex: 4,
            child: Container(
              //color: Colors.pink,
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  Text(val),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> createData(val) async {
    try {
      await dbAlert.push().set({
        'uid': user.uid!,
        'Name': user.displayName,
        'Help': val,
        'Addr': addr,
        'status': 'รอยืนยัน',
        'currentHelp': currentHelp,
      }).then((value) async {
        //formKey.currentState!.reset();
        print("Success");
        await dbStd.child(user.uid!).update({
          'Help': 'รอยืนยัน',
        }).then((value) async {
          print("Success");
          var count = 0;
          Navigator.popUntil(context, (route) {
            return count++ == 1;
          });
        }).catchError((onError) {
          print(onError.code);
          print(onError.message);
        });
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
}
