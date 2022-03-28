import 'package:flutter/material.dart';
import 'package:kmutnb_app/config/constant.dart';

class StdKeep extends StatefulWidget {
  const StdKeep({Key? key}) : super(key: key);

  @override
  _StdKeepState createState() => _StdKeepState();
}

class _StdKeepState extends State<StdKeep> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('ต้องการกักตัว'),
        centerTitle: true,
      ),
      body: Container(
        color: pColor,
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.7),
                      )
                    ],
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
                    //mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('ขอความช่วยเหลือ'),
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.black.withOpacity(0.5),
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(
                                    color: Color(0xFF8B4513),
                                    width: 2.0,
                                  ),
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                              child: Column(
                                children: [
                                  Icon(Icons.ac_unit),
                                  Text(
                                    'อุปกรณ์',
                                    style: TextStyle(
                                      fontSize: 28,
                                      color: sColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {
                              //_order('โต๊ะที่ : 1');
                            },
                          ),
                          SizedBox(
                            width: size.width * 0.04,
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.black.withOpacity(0.5),
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(
                                    color: Color(0xFF8B4513),
                                    width: 2.0,
                                  ),
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                              child: Column(
                                children: [
                                  Icon(Icons.ac_unit_outlined),
                                  Text(
                                    'อาหาร',
                                    style: TextStyle(
                                      fontSize: 28,
                                      color: sColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {
                              //_order('โต๊ะที่ : 1');
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.black.withOpacity(0.5),
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(
                                    color: Color(0xFF8B4513),
                                    width: 2.0,
                                  ),
                                ),
                              ),
                            ),
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Icon(Icons.ac_unit),
                                  Text(
                                    'ยารักษา',
                                    style: TextStyle(
                                      fontSize: 28,
                                      color: sColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {
                              //_order('โต๊ะที่ : 1');
                            },
                          ),
                          SizedBox(
                            width: size.width * 0.04,
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.black.withOpacity(0.5),
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(
                                    color: Color(0xFF8B4513),
                                    width: 2.0,
                                  ),
                                ),
                              ),
                            ),
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Icon(Icons.ac_unit_outlined),
                                  Text(
                                    'เบอร์ติดต่อ',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: sColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, 'Contact');
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
