import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kmutnb_app/screens/login/login_control.dart';

class TestLogin extends StatefulWidget {
  const TestLogin({Key? key}) : super(key: key);

  @override
  _TestLoginState createState() => _TestLoginState();
}

class _TestLoginState extends State<TestLogin> {
  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Login"),
      ),
      body: Column(
        children: [
          Center(
            child: Obx(() {
              if (controller.googleAccount.value == null)
                return btnlogin();
              else
                return profileView();
            }),
            //btnlogin(),
          ),
        ],
      ),
    );
  }

/*
  Future loginWithGoogle(BuildContext context) async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    GoogleSignInAccount user = await _googleSignIn.signIn();
    GoogleSignInAuthentication userAuth = await user.authentication;

    await _auth.signInWithCredential(GoogleAuthProvider.getCredential(
        idToken: userAuth.idToken, accessToken: userAuth.accessToken));
    checkAuth(context); // after success route to home.
  }
*/
  Column profileView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundImage:
              Image.network(controller.googleAccount.value?.photoUrl ?? '')
                  .image,
          radius: 100,
        ),
        SizedBox(
          height: 20,
        ),
        Text(controller.googleAccount.value?.displayName ?? ''),
        SizedBox(
          height: 20,
        ),
        Text(controller.googleAccount.value?.email ?? ''),
        SizedBox(
          height: 20,
        ),
        Text(controller.googleAccount.value?.id ?? ''),
        SizedBox(
          height: 20,
        ),
        ActionChip(
          avatar: Icon(Icons.logout),
          label: Text('Logout'),
          onPressed: () {
            controller.logout();
          },
        )
      ],
    );
  }

  FloatingActionButton btnlogin() {
    return FloatingActionButton.extended(
      onPressed: () {
        controller.login();
      },
      label: Text('Test'),
    );
  }
}
