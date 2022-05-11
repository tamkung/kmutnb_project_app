import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:kmutnb_app/config/constant.dart';
import 'package:kmutnb_app/screens/pdf_viewer.dart';

class CovidManual2Not extends StatefulWidget {
  const CovidManual2Not({Key? key}) : super(key: key);

  @override
  _CovidManual2NotState createState() => _CovidManual2NotState();
}

class _CovidManual2NotState extends State<CovidManual2Not> {
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
            'คู่มือการกักตัว',
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
                  return snapshot.value['type'] == "คู่มือการกักตัว"
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
