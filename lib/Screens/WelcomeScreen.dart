import 'package:ConnectWithGames/Helpers/Filters.dart';
import 'package:ConnectWithGames/Helpers/location_helper.dart';
import 'package:ConnectWithGames/Models/loggedInUserInfo.dart';
import 'package:ConnectWithGames/Screens/AddGameScreen.dart';
import 'package:ConnectWithGames/Screens/DisplayAvailableGames.dart';
import 'package:ConnectWithGames/Widgets/app_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WelcomeScreen extends StatefulWidget {
  final userId;
  final name;
  WelcomeScreen(this.userId, this.name);
  static const routeName = "/WelcomeScreen";

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isLoading = false;
  Future<void> googleSignOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    LoggedInUserInfo.id = null;
    LoggedInUserInfo.name = null;
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
                'Hey ${widget.name} looking for a buddy to play along with?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontFamily: 'Anton',
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            _isLoading
                ? CircularProgressIndicator()
                : Container(
                    width: 300,
                    child: OutlineButton(
                      child: Text("Search"),
                      color: Colors.pink,
                      borderSide: BorderSide(color: Colors.blue),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        if (prefs.containsKey(
                            'defaultValues/${LoggedInUserInfo.id}')) {
                          setState(() {
                            _isLoading = false;
                          });
                          Map<String, dynamic> result = jsonDecode(
                              prefs.getString(
                                  'defaultValues/${LoggedInUserInfo.id}'));
                          LoggedInUserInfo.userFilters = Filters(
                              distance: result['distance'],
                              endDate: result['endDate'],
                              startDate: result['startDate'],
                              lat: result['lat'],
                              lng: result['lng'],
                              isComputer: result['isComputer'],
                              isPhysical: result['isPhysical'],
                              address: result['address']);
                          Navigator.pushNamed(
                              context, DisplayAvailableGames.routeName);
                        } else {
                          try {
                            final locData = await Location().getLocation();
                            double lat = locData.latitude;
                            double lng = locData.longitude;
                            String address =
                                await LocationHelper.getPlaceAddress(lat, lng);
                            Filters filters = Filters(
                                lat: lat,
                                lng: lng,
                                distance: 12756,
                                isComputer: true,
                                isPhysical: true,
                                startDate: DateTime.now().toIso8601String(),
                                endDate: DateTime(2100).toIso8601String(),
                                address: address);
                            String value = jsonEncode(filters);
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setString('defaultValues', value);
                            LoggedInUserInfo.userFilters = Filters(
                                distance: 12756,
                                lat: lat,
                                lng: lng,
                                isComputer: true,
                                isPhysical: true,
                                startDate: DateTime.now().toIso8601String(),
                                endDate: DateTime(2100).toIso8601String(),
                                address: address);
                            setState(() {
                              _isLoading = false;
                            });
                            Navigator.pushNamed(
                                context, DisplayAvailableGames.routeName);
                          } on PlatformException catch (err) {
                            print(err);
                            setState(() {
                              _isLoading = false;
                            });
                          } catch (err) {
                            print(err);
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        }
                      },
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
