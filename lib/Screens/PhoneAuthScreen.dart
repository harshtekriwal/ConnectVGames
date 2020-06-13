import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

class PhoneAuthScreen extends StatefulWidget {
  static const routeName = "/PhoneAuthentication";
  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  var _isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static final _formkey = GlobalKey<FormState>();
  String _phoneNo;
  final _codeController = TextEditingController();

  Future<void> _verifyPhoneNo(String phoneNo, BuildContext context) async {
    final _isValid = _formkey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (!_isValid) {
      return;
    }
    _formkey.currentState.save();
    final PhoneVerificationCompleted verified =
        (AuthCredential credential) async {
      try {
        await FirebaseAuth.instance.signInWithCredential(credential);

        Navigator.of(context).pop();
        Navigator.pop(context);
      } on PlatformException catch (err) {
        var message = 'An error occured!!';
        if (err.message != null) {
          message = err.message;
        }
        _scaffoldKey.currentState.hideCurrentSnackBar();

        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            message,
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).errorColor,
        ));
      } on AuthException catch (err) {
        var message = 'An error occured!!';
        if (err.message != null) {
          message = err.message;
        }
        _scaffoldKey.currentState.hideCurrentSnackBar();

        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            message,
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).errorColor,
        ));
      } catch (err) {
        _scaffoldKey.currentState.hideCurrentSnackBar();

        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            "Something went wrong. Please try again!",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).errorColor,
        ));
      }
    };
    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      _scaffoldKey.currentState.hideCurrentSnackBar();

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          authException.message,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).errorColor,
      ));
    };
    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      print("woah");
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text('Please enter the verification code!'),
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[TextField(controller: _codeController)]),
              actions: <Widget>[
                FlatButton(
                  child: Text("Confirm"),
                  textColor: Colors.white,
                  color: Colors.blue,
                  onPressed: () async {
                    try {
                      AuthCredential credential =
                          PhoneAuthProvider.getCredential(
                              verificationId: verId,
                              smsCode: _codeController.text.trim());

                      await FirebaseAuth.instance
                          .signInWithCredential(credential);
                          Navigator.of(context).pop();
                          Navigator.pop(context);
                    } on PlatformException catch (err) {
                      Toast.show(err.message, context,
                          duration: 10, gravity: Toast.BOTTOM);
                    } on AuthException catch (err) {
                      _scaffoldKey.currentState.hideCurrentSnackBar();
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(
                            err.message,
                            textAlign: TextAlign.center,
                          ),
                          backgroundColor: Theme.of(context).errorColor));
                    } catch (err) {
                      _scaffoldKey.currentState.hideCurrentSnackBar();

                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(
                            err.message,
                            textAlign: TextAlign.center,
                          ),
                          backgroundColor: Theme.of(context).errorColor));
                    }
                  },
                ),
              ],
            );
          });
    };
    try {
      setState(() {
        _isLoading = true;
        print("wow");
      });
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNo,
          timeout: const Duration(seconds: 60),
          verificationCompleted: verified,
          verificationFailed: verificationFailed,
          codeSent: smsSent,
          codeAutoRetrievalTimeout: null);
      setState(() {
        print("here");
        _isLoading = false;
      });
    } on PlatformException catch (err) {
      setState(() {
        print("yo");
        _isLoading = false;
      });
      var message = 'An error occured!!';
      if (err.message != null) {
        message = err.message;
      }
      _scaffoldKey.currentState.hideCurrentSnackBar();

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).errorColor,
      ));
    } on AuthException catch (err) {
      setState(() {
        _isLoading = false;
      });
      var message = 'An error occured!!';
      if (err.message != null) {
        message = err.message;
      }
      _scaffoldKey.currentState.hideCurrentSnackBar();

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).errorColor,
      ));
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
      _scaffoldKey.currentState.hideCurrentSnackBar();

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          "Something went wrong. Please try again!",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).errorColor,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
            Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Center(
          child: Card(
            margin: EdgeInsets.all(20),
            child: SingleChildScrollView(
                child: Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formkey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Phone Number'),
                      keyboardType: TextInputType.phone,
                      onChanged: (val) {
                        _phoneNo = val;
                      },
                      validator: (val) {
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    _isLoading
                        ? CircularProgressIndicator()
                        : RaisedButton(
                            child: Center(
                              child: Text("Login"),
                            ),
                            onPressed: () {
                              _verifyPhoneNo(_phoneNo.trim(), context);
                            },
                          )
                  ],
                ),
              ),
            )),
          ),
        ),
      ),
    );
  }
}
