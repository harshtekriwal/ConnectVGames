import 'dart:io';
import 'package:ConnectWithGames/Models/loggedInUserInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'WelcomeScreen.dart';

class IntermediateMainScreen extends StatefulWidget {
  static const routeName = "/UserInformation";
  final String _uid;
  IntermediateMainScreen(this._uid);

  @override
  _IntermediateMainScreenState createState() => _IntermediateMainScreenState();
}

class _IntermediateMainScreenState extends State<IntermediateMainScreen> {
  bool _hasUserDataAlready = false;
  var _isLoading = false;
  static final _formKey = GlobalKey<FormState>();
  var _firstname = ' ';
  var _lastname = ' ';
  Future<void> _submitUserInformation(
      String firstName, String lastName, BuildContext ctx) async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Firestore.instance
          .collection('users')
          .document(widget._uid)
          .setData({'firstName': firstName, 'lastName': lastName});
      setState(() {
        _isLoading = false;
        _hasUserDataAlready = true;
      });
    } on PlatformException catch (err) {
      setState(() {
        _isLoading = false;
      });
      var message = 'An error occured, please check your credentials!';
      if (err.message != null) {
        message = err.message;
      }
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).errorColor,
      ));
    } on HttpException catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
            "Please check your Internet Connection",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).errorColor));
    } on AuthException catch (err) {
      setState(() {
        _isLoading = false;
      });
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          err.message,
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
    void _trySubmit() {
      final isValid = _formKey.currentState.validate();
      FocusScope.of(context).unfocus();

      if (isValid) {
        _formKey.currentState.save();
        _submitUserInformation(_firstname, _lastname, context);
      } else {
        return;
      }
    }

    Widget userInfoForm = Scaffold(
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),
            child: Center(
              child: Card(
                  margin: EdgeInsets.all(20),
                  child: SingleChildScrollView(
                      child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  decoration:
                                      InputDecoration(labelText: 'FirstName'),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please Enter your First Name';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _firstname = value;
                                  },
                                  key: ValueKey('firstName'),
                                ),
                                TextFormField(
                                  decoration:
                                      InputDecoration(labelText: 'LastName'),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please Enter your Last Name';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _lastname = value;
                                  },
                                  key: ValueKey('lastName'),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                _isLoading
                                    ? CircularProgressIndicator()
                                    : RaisedButton(
                                        child: Text('Submit'),
                                        onPressed: () {
                                          _trySubmit();
                                        },
                                      ),
                              ],
                            ),
                          )))),
            )));

    if (_hasUserDataAlready) {
      LoggedInUserInfo.id = widget._uid;
      LoggedInUserInfo.name = _firstname;
      return WelcomeScreen(widget._uid, _firstname);
    } else {
      return userInfoForm;
    }
  }
}
