import 'package:ConnectWithGames/Models/loggedInUserInfo.dart';
import 'package:ConnectWithGames/Screens/AuthScreen.dart';
import 'package:ConnectWithGames/Screens/DisplayAvailableGames.dart';
import 'package:ConnectWithGames/Screens/IndividualChatScreen.dart';
import 'package:ConnectWithGames/Screens/IntermediateMainScreen.dart';
import 'package:ConnectWithGames/Screens/PhoneAuthScreen.dart';
import 'package:ConnectWithGames/Screens/WelcomeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Providers/Auth.dart';
import 'Screens/AddGameScreen.dart';
import 'Screens/SplashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.lightBlue,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.onAuthStateChanged,
            builder: (ctx, AsyncSnapshot<FirebaseUser> userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return SplashScreen();
              }

              if (userSnapshot.hasData) {
                return FutureBuilder(
                    future: Firestore.instance
                        .collection('users')
                        .document(userSnapshot.data.uid)
                        .get(),
                    builder: (context, AsyncSnapshot<DocumentSnapshot> ss) {
                      if (ss.connectionState == ConnectionState.waiting) {
                        return SplashScreen();
                      } else if (ss.hasError) {
                        return Scaffold(
                            body: Center(
                                child: Text(
                                    "Something went wrong! Please try again!")));
                      } else {
                        if (ss.data.data != null) {
                          LoggedInUserInfo.id = userSnapshot.data.uid;
                          LoggedInUserInfo.name = ss.data.data['firstName'];
                          return WelcomeScreen(
                            userSnapshot.data.uid,
                            ss.data.data['firstName'],
                          );
                        } else {
                          return IntermediateMainScreen(userSnapshot.data.uid);
                        }
                      }
                    });
              }

              return AuthScreen();
            },
          ),
          initialRoute: '/',
          routes: {
            PhoneAuthScreen.routeName: (ctx) => PhoneAuthScreen(),
            AddGame.routeName: (ctx) => AddGame(),
            DisplayAvailableGames.routeName: (ctx) => DisplayAvailableGames(),
            IndividualChatScreen.routeName: (ctx) => IndividualChatScreen(),
          }),
    );
  }
}
