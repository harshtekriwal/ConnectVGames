import 'dart:io';
import 'package:ConnectWithGames/Models/loggedInUserInfo.dart';
import 'package:ConnectWithGames/Pickers/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
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
  var imageURL = '';
  File _userImageFile;
  void _pickedImage(PickedFile image) {
    _userImageFile = File(image.path);
  }

  Future<void> _submitUserInformation(
      String firstName, String lastName, File image, BuildContext ctx) async {
    try {
      setState(() {
        _isLoading = true;
      });
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child(widget._uid + '.jpg');
      await ref.putFile(image).onComplete;
      final url = await ref.getDownloadURL();
      imageURL = url;
      await Firestore.instance
          .collection('users')
          .document(widget._uid)
          .setData(
              {'firstName': firstName, 'lastName': lastName, 'image_url': url});
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
      if (_userImageFile == null) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Please pick an image.'),
          backgroundColor: Theme.of(context).errorColor,
        ));
        return;
      }
      if (isValid) {
        _formKey.currentState.save();
        _submitUserInformation(
            _firstname.trim(), _lastname.trim(), _userImageFile, context);
      } else {
        return;
      }
    }

    Widget userInfoForm = Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
          Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
        ], begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      child: Center(
        child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            elevation: 5,
            margin: EdgeInsets.all(25),
            child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          UserImagePicker(_pickedImage),
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
                            height: 12,
                          ),
                          _isLoading
                              ? CircularProgressIndicator()
                              : RaisedButton(
                                  color: Colors.blueGrey[100],
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

    if (_hasUserDataAlready) {
      LoggedInUserInfo.id = widget._uid;
      LoggedInUserInfo.name = _firstname;
      LoggedInUserInfo.url = imageURL;
      return WelcomeScreen();
    } else {
      return userInfoForm;
    }
  }
}
