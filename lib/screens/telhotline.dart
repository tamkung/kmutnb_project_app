import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:kmutnb_app/config/constant.dart';
import 'package:kmutnb_app/screens/pdf_viewer.dart';

class TelHotline extends StatefulWidget {
  const TelHotline({Key? key}) : super(key: key);

  @override
  _TelHotlineState createState() => _TelHotlineState();
}

class _TelHotlineState extends State<TelHotline> {
  dynamic user = FirebaseAuth.instance.currentUser!;
  bool? emailValid;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: pColor,
          title: Text(
            'เบอร์สายด่วน',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[],
        ),
        body: Column(
          children: [
            Expanded(
              child: FirebaseAnimatedList(
                query: dbTel,
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
                          subtitle: Text('${snapshot.value['Tel']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // IconButton(
                              //   icon: Icon(
                              //     Icons.edit,
                              //     color: Colors.green,
                              //   ),
                              //   onPressed: () {
                              //     print("Delete");
                              //     print(emailValid);
                              //     showMyDialog(
                              //       context,
                              //       snapshot.key,
                              //     );
                              //   },
                              // ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  print("Delete");
                                  print(emailValid);
                                  showMyDialog(
                                    context,
                                    snapshot.key,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showMyDialog(context, key) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'ยืนยันการลบ',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  'คุณแน่ใจใช่ไหมที่จะลบรายการ',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'ยืนยัน',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                print('Confirmed');
                //_delete(imgurl);
                dbTel.child(key).remove();
                //print(key);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'ยกเลิก',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
