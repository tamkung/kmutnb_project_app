import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:kmutnb_app/config/constant.dart';
import 'package:kmutnb_app/screens/pdf_viewer.dart';

class PRkmutnb extends StatefulWidget {
  const PRkmutnb({Key? key}) : super(key: key);

  @override
  _PRkmutnbState createState() => _PRkmutnbState();
}

class _PRkmutnbState extends State<PRkmutnb> {
  dynamic user;
  bool? emailValid = true;

  @override
  void initState() {
    if (login == false) {
      user = '';
    } else {
      user = FirebaseAuth.instance.currentUser!;
      emailValid = RegExp(r"^[a-zA-Z0-9]+@email+\.+kmutnb+\.ac+\.th")
          .hasMatch(user!.email);
    }
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
                                trailing: emailValid != true
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          print("Delete");
                                          print(emailValid);
                                          AllFunction().showMyDialog(
                                            context,
                                            snapshot.key,
                                            '${snapshot.value['imgURL']}',
                                          );
                                        },
                                      )
                                    : Text(''),
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
