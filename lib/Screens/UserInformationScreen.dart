import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserInformationScreen extends StatefulWidget {
  static const routeName = "/UserInformation";

  @override
  _UserInformationScreenState createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  var _isLoading = false;
  Future<void> _submitUserInformation(AuthCredential credential, String mail,
      String firstName, String lastName, BuildContext ctx) async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Firestore.instance
          .collection('users')
          .document(mail)
          .setData({'firstName': firstName, 'lastName': lastName});
      final _auth = FirebaseAuth.instance;
      final AuthResult result = await _auth.signInWithCredential(credential);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(ctx).pop();
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
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginInfo =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;
    final _formKey = GlobalKey<FormState>();
    var _firstname = ' ';
    var _lastname = ' ';
    void _trySubmit() {
      final isValid = _formKey.currentState.validate();
      FocusScope.of(context).unfocus();

      if (isValid) {
        _formKey.currentState.save();
        final AuthCredential credential = loginInfo['credential'];
        final String mail = loginInfo['userMail'];
        _submitUserInformation(
            credential, mail, _firstname, _lastname, context);
      }
    }

    return Scaffold(
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
                            decoration: InputDecoration(labelText: 'FirstName'),
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
                            decoration: InputDecoration(labelText: 'LastName'),
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
      ),
    ));
  }
}
