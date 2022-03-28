import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kmutnb_app/config/constant.dart';
import 'package:kmutnb_app/screens/officer/off_launcher.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class OfficerLogin extends StatefulWidget {
  const OfficerLogin({Key? key}) : super(key: key);

  @override
  _OfficerLoginState createState() => _OfficerLoginState();
}

class _OfficerLoginState extends State<OfficerLogin> {
  var email, password;
  final formKey = GlobalKey<FormState>();

  Future<void> checkUser() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        print('Success');
        Navigator.pushNamed(context, 'OfficerLaun');
      }).catchError((onError) {
        print("Error : " + onError.toString());
        if (onError.toString() ==
            "[firebase_auth/unknown] Given String is empty or null") {
          print("true");
        } else {
          _onBasicAlertPressed(context);
          final snackBar =
              SnackBar(content: Text('ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "เข้าสู่ระบบ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Form(
        key: formKey,
        child: Container(
          color: pColor,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                /* Container(
                  width: size.width * 0.9,
                  height: size.height * 0.1,
                  //  color: sColor,
                  alignment: Alignment.center,
                  child: Text(
                    'เข้าสู่ระบบ',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),*/
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white.withOpacity(0.3),
                  ),
                  //color: pColor,
                  child: Column(
                    children: [
                      Icon(
                        Icons.person,
                        size: size.width * 0.5,
                      ),
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      Container(
                        width: size.width * 0.9,
                        //height: size.height * 0.12,
                        // color: Colors.black87,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'ชื่อผู้ใช้ : ',
                              style: TextStyle(
                                fontSize: size.width * 0.05,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.04,
                            ),
                            Container(
                              width: size.width * 0.55,
                              child: TextFormField(
                                style: TextStyle(
                                    fontSize: size.width * 0.05,
                                    color: Colors.white),
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: "Email",
                                  hintStyle:
                                      TextStyle(color: Colors.grey.shade700),
                                  filled: true,
                                  fillColor: Color(0xff161d27).withOpacity(0.9),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(color: sColor)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(color: sColor)),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    final snackBar = SnackBar(
                                        content: Text('กรุณาป้อนอีเมล'));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                },
                                onSaved: (value) {
                                  email = value!.trim();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      Container(
                        width: size.width * 0.9,
                        //height: size.height * 0.10,
                        //color: Colors.black87,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'รหัสผ่าน : ',
                              style: TextStyle(
                                fontSize: size.width * 0.05,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.01,
                            ),
                            Container(
                              width: size.width * 0.55,
                              child: TextFormField(
                                style: TextStyle(
                                  fontSize: size.width * 0.05,
                                  color: Colors.white,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  hintStyle:
                                      TextStyle(color: Colors.grey.shade700),
                                  filled: true,
                                  fillColor: Color(0xff161d27).withOpacity(0.9),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(color: sColor)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(color: sColor)),
                                ),
                                obscureText: true,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    final snackBar = SnackBar(
                                        content: Text('กรุณาป้อนรหัสผ่าน'));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                },
                                onSaved: (value) {
                                  password = value!.trim();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      Container(
                        width: size.width * 0.9,
                        height: size.height * 0.12,
                        //  color: Colors.black87,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: ElevatedButton.icon(
                                icon: Icon(
                                  Icons.login,
                                  color: Colors.white,
                                  size: 32,
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: bColor,
                                  padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
                                  shape: StadiumBorder(),
                                  side: BorderSide(
                                    color: bColor,
                                  ),
                                ),
                                label: Text(
                                  'เข้าสู่ระบบ',
                                  style: TextStyle(
                                    fontSize: size.width * 0.05,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    formKey.currentState!.save();
                                    checkUser();
                                  }
                                  print(email);
                                  print(password);

                                  //  Navigator.pushNamed(context, 'MainMenu');
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onBasicAlertPressed(context) {
    Alert(
      style: AlertStyle(
        backgroundColor: Colors.white,
        titleStyle: TextStyle(fontSize: 32),
      ),
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          color: bColor,
          onPressed: () => Navigator.pop(context),
          width: 120,
        ),
      ],
      context: context,
      title: "ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง",
      //desc: "Flutter is more awesome with RFlutter Alert.",
    ).show();
  }
}
