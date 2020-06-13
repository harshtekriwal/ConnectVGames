
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class WelcomeScreen extends StatelessWidget {
    static const routeName = "/WelcomeScreen";

  Future<void> googleSignOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: <Widget>[
        DropdownButton(
          underline: Container(),
          icon: Icon(Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color),
          items: [
            DropdownMenuItem(
              child: Container(
                  child: Row(
                children: <Widget>[
                  Icon(Icons.exit_to_app),
                  SizedBox(
                    width: 8,
                  ),
                  Text('Logout'),
                ],
              )),
              value: 'logout',
            ),
          ],
          onChanged: (itemIdentifier) {
            if (itemIdentifier == 'logout') {
              googleSignOut();
            }
          },
        )
      ]),
      body: Center(child: Text("Welcome"),),
      
    );
  }
}
