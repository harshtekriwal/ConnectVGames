import 'package:ConnectWithGames/Helpers/Filters.dart';
import 'package:ConnectWithGames/Helpers/location_helper.dart';
import 'package:ConnectWithGames/Models/loggedInUserInfo.dart';
import 'package:ConnectWithGames/Screens/AddGameScreen.dart';
import 'package:ConnectWithGames/Screens/DisplayAvailableGames.dart';
import 'package:ConnectWithGames/Screens/UserGamesScreen.dart';
import 'package:ConnectWithGames/Widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'ChatScreen.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeName = "/WelcomeScreen";

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        drawer: AppDrawer(),
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.message),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (ctx) => ChatScreen()));
                })
          ],
          title: Text("ConnectVGames"),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(LoggedInUserInfo.url)),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Text(
                    LoggedInUserInfo.name,
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
                        width: 250,
                        child: OutlineButton(
                          child: Text("Look for a game"),
                          borderSide: BorderSide(color: Colors.black),
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
                              if (result['gameDate'] != null &&
                                  DateTime.parse(result['gameDate'])
                                      .isBefore(DateTime.now())) {
                                LoggedInUserInfo.userFilters = Filters(
                                    distance: result['distance'],
                                    lat: result['lat'],
                                    lng: result['lng'],
                                    isComputer: result['isComputer'],
                                    isPhysical: result['isPhysical'],
                                    gameDate: null,
                                    address: result['address']);
                                String value =
                                    jsonEncode(LoggedInUserInfo.userFilters);

                                prefs.setString('defaultValues', value);
                              } else {
                                LoggedInUserInfo.userFilters = Filters(
                                    distance: result['distance'],
                                    lat: result['lat'],
                                    lng: result['lng'],
                                    isComputer: result['isComputer'],
                                    isPhysical: result['isPhysical'],
                                    gameDate: result['gameDate'],
                                    address: result['address']);
                              }
                              Navigator.pushNamed(
                                  context, DisplayAvailableGames.routeName);
                            } else {
                              try {
                                final locData = await Location().getLocation();
                                double lat = locData.latitude;
                                double lng = locData.longitude;
                                String address =
                                    await LocationHelper.getPlaceAddress(
                                        lat, lng);
                                Filters filters = Filters(
                                    lat: lat,
                                    lng: lng,
                                    distance: 2,
                                    isComputer: true,
                                    isPhysical: true,
                                    gameDate: null,
                                    address: address);
                                String value = jsonEncode(filters);
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString('defaultValues', value);
                                LoggedInUserInfo.userFilters = Filters(
                                    distance: 2,
                                    lat: lat,
                                    lng: lng,
                                    isComputer: true,
                                    isPhysical: true,
                                    gameDate: null,
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
                  width: 250,
                  child: OutlineButton(
                    child: Text("Add a Game Request"),
                    borderSide: BorderSide(color: Colors.black),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    onPressed: () {
                      Navigator.pushNamed(context, AddGame.routeName);
                    },
                  ),
                ),
                Container(
                  width: 250,
                  child: OutlineButton(
                    child: Text("Your Games"),
                    borderSide: BorderSide(color: Colors.black),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    onPressed: () {
                      Navigator.pushNamed(context, UserGamesScreen.routeName);
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
