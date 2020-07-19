import 'package:ConnectWithGames/Screens/AddGameScreen.dart';
import 'package:ConnectWithGames/Widgets/app_drawer.dart';
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
        backgroundColor: Colors.white,
        drawer: AppDrawer(),
        appBar: AppBar(
            title: Text("ConnectVGames"),
            backgroundColor: Colors.lightBlueAccent,
            actions: <Widget>[
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              child: Text(
                'Looking for a buddy to play along with?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontFamily: 'Anton',
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Container(
              width: 300,
              child: OutlineButton(
                child: Text("Search"),
                color: Colors.pink,
                borderSide: BorderSide(color: Colors.blue),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                onPressed: () {},
              ),
            ),
            Container(
              width: 300,
              child: OutlineButton(
                child: Text("Find a buddy"),
                borderSide: BorderSide(color: Colors.blue),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                onPressed: () {
                  Navigator.pushNamed(context, AddGame.routeName);
                },
              ),
            )
          ],
        ));
  }
}
