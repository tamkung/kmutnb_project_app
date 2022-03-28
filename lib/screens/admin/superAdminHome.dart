import 'package:flutter/material.dart';

class SuperAdminHome extends StatefulWidget {
  const SuperAdminHome({Key? key}) : super(key: key);

  @override
  _SuperAdminHomeState createState() => _SuperAdminHomeState();
}

class _SuperAdminHomeState extends State<SuperAdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Center(
          child: Text('Admin'),
        ),
      ),
    );
  }
}
