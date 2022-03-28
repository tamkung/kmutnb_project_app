import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kmutnb_app/config/constant.dart';
import 'package:kmutnb_app/screens/pdf_viewer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class CovidManual1Not extends StatefulWidget {
  const CovidManual1Not({Key? key}) : super(key: key);

  @override
  _CovidManual1NotState createState() => _CovidManual1NotState();
}

class _CovidManual1NotState extends State<CovidManual1Not> {
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
            'คู่มือโควิด',
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
                  return snapshot.value['type'] == "คู่มือโควิด"
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
