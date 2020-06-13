import 'package:ConnectWithGames/Screens/PhoneAuthScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_signin_buttons/social_signin_buttons.dart';

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  bool _isLoading = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _submitAuthForm() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await GoogleSignIn().signOut();
      GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

       await _auth.signInWithCredential(credential);

      setState(() {
        _isLoading = false;
      });
    } on PlatformException catch (err) {
      setState(() {
        _isLoading = false;
      });
      var message = 'An error occured, please check your credentials!';
      if (err.message != null) {
        message = err.message;
      }
      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).errorColor,
      ));
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                "Join Us",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              SignInButton(Buttons.Google, onPressed: () {
                _submitAuthForm();
              }),
              SizedBox(
                height: 10,
              ),
              Container(
                  width: 220,
                  child: FlatButton.icon(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(PhoneAuthScreen.routeName);
                    },
                    icon: Icon(Icons.phone),
                    label: Text("Sign in with phone"),
                    color: Colors.white,
                  )),
              SizedBox(height: 20),
            ],
          );
  }
}
