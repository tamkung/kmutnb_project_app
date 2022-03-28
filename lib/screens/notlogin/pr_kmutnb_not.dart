import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:kmutnb_app/config/constant.dart';
import 'package:kmutnb_app/screens/pdf_viewer.dart';

class PRkmutnbNot extends StatefulWidget {
  const PRkmutnbNot({Key? key}) : super(key: key);

  @override
  _PRkmutnbNotState createState() => _PRkmutnbNotState();
}

class _PRkmutnbNotState extends State<PRkmutnbNot> {
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
            'การประชาสัมพันธ์',
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
                query: dbFile,
                itemBuilder: (context, snapshot, animation, index) {
                  return snapshot.value['type'] == "การประชาสัมพันธ์"
                      ? Container(
                          //height: 100,
                          child: Padding(
                            padding: EdgeInsets.all(1.0),
                            child: Card(
                              elevation: 5,
                              child: ListTile(
                                title: Text(
                                  '${snapshot.value['tName']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    //fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  AllFunction().sendURL(
                                      context,
                                      snapshot.value['FileURL'],
                                      snapshot.value['tName']);
                                },
                              ),
                            ),
                          ),
                        )
                      : Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
