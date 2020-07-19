import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AppDrawer extends StatelessWidget {
  Future<void> googleSignOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: <Widget>[
        AppBar(
          backgroundColor: Colors.lightBlueAccent,
          title: Text('Hello Friend'),
          automaticallyImplyLeading: false,
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.home),
          title: Text("Home"),
          onTap: () {},
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.gamepad),
          title: Text("About App"),
          onTap: () {},
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.chat),
          title: Text("Connections"),
          onTap: () {},
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text("Logout"),
          onTap: () {
            googleSignOut();
          },
        )
      ],
    ));
  }
}
