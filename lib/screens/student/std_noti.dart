import 'package:flutter/material.dart';

class StudentNoti extends StatefulWidget {
  static const routeName = '/';

  const StudentNoti({Key? key}) : super(key: key);

  @override
  _StudentNotiState createState() => _StudentNotiState();
}

class _StudentNotiState extends State<StudentNoti> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Notification Screen'),
          ],
        ),
      ),
    );
  }
}
