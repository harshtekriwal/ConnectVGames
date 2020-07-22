import 'package:ConnectWithGames/Helpers/location_helper.dart';
import 'package:ConnectWithGames/Models/loggedInUserInfo.dart';
import 'package:ConnectWithGames/Screens/map_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class AddGame extends StatefulWidget {
  static const routeName = "/AddGame";

  @override
  _AddGameState createState() => _AddGameState();
}

class _AddGameState extends State<AddGame> {
  var _isLoading = false;
  TextEditingController _controller = TextEditingController();
  String gameName = "";
  int selectedRadioTile = 1;
  double lat;
  double lng;
  int maxDistanceRadius;
  DateTime startDate;
  DateTime endDate;
  static final _formkey = GlobalKey<FormState>();
  final format = DateFormat("yyyy-MM-dd HH:mm");
  String address;
  void _updateAddress(String add) {
    setState(() {
      address = add;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
    });
    if (address == null) {
      address = '';
    }
    if (!_formkey.currentState.validate()) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    _formkey.currentState.save();

    try {
      int totalGamesRequests = 0;
      await Firestore.instance
          .collection('Games')
          .where('userId', isEqualTo: LoggedInUserInfo.id)
          .getDocuments()
          .then((value) {
        totalGamesRequests = value.documents.length;
      });
      print(totalGamesRequests);
      if (totalGamesRequests >= 2) {
        print("Cant add data");
        throw Exception();
      }
      List<String> splitList = gameName.split(" ");
      List<String> indexList = [];
      for (int i = 0; i < splitList.length; i++) {
        for (int j = 1; j <= splitList[i].length; j++) {
          indexList.add(splitList[i].substring(0, j).toLowerCase());
        }
      }
      await Firestore.instance.collection('Games').add({
        'gameName': gameName,
        'gameType': selectedRadioTile == 1 ? 'Physical' : 'Computer',
        'userId': LoggedInUserInfo.id,
        'userName': LoggedInUserInfo.name,
        'latitude': lat,
        'longitude': lng,
        'distanceRange': maxDistanceRadius,
        'startTime': startDate,
        'endTime': endDate,
        'searchindex': indexList
      });
      setState(() {
        _isLoading = false;
      });
    } on AuthException catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getCurrentUserLocation() async {
    final locData = await Location().getLocation();
    lat = locData.latitude;
    lng = locData.longitude;
    final address = await LocationHelper.getPlaceAddress(
        locData.latitude, locData.longitude);
    _updateAddress(address);
    _controller.text = address;
  }

  Future<void> _selectOnMap() async {
    final locData = await Location().getLocation();
    final selectedLocation = await Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => MapScreen(locData.latitude, locData.longitude)));
    if (selectedLocation == null) {
      return;
    } else {
      lat = selectedLocation[0];
      lng = selectedLocation[1];
      final address = await LocationHelper.getPlaceAddress(
          selectedLocation[0], selectedLocation[1]);
      _updateAddress(address);
      _controller.text = address;
    }
  }

  void setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Game Details"),
        ),
        body: Card(
          margin: EdgeInsets.all(10),
          elevation: 20,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Form(
              key: _formkey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      validator: (value) {
                        if (value.length < 3) {
                          return "Please enter atleast 3 characters.";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        gameName = val;
                      },
                      decoration: InputDecoration(labelText: "Game Name"),
                    ),
                    RadioListTile(
                        value: 1,
                        groupValue: selectedRadioTile,
                        title: Text("Physical"),
                        selected: false,
                        activeColor: Colors.red,
                        onChanged: (val) {
                          setSelectedRadioTile(val);
                        }),
                    RadioListTile(
                        value: 2,
                        groupValue: selectedRadioTile,
                        title: Text("Computer"),
                        selected: false,
                        activeColor: Colors.red,
                        onChanged: (val) {
                          setSelectedRadioTile(val);
                        }),
                    if (selectedRadioTile == 1)
                      Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              RaisedButton.icon(
                                icon: Icon(Icons.map),
                                label: Text("Select on Map"),
                                onPressed: () {
                                  _selectOnMap();
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              RaisedButton.icon(
                                icon: Icon(Icons.location_on),
                                label: Text("Current Location"),
                                onPressed: () {
                                  _getCurrentUserLocation();
                                },
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            readOnly: true,
                            controller: _controller,
                            decoration: InputDecoration(
                              labelText: 'Enter Location',
                              errorText: address == ''
                                  ? 'Please enter a location'
                                  : null,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value.length <= 0) {
                                return "Please enter a distance";
                              }
                              if (int.parse(value) < 0) {
                                return "Please enter a valid distance";
                              }
                              return null;
                            },
                            onSaved: (val) {
                              maxDistanceRadius = int.parse(val);
                            },
                            decoration: InputDecoration(
                                labelText: "Maximum Distance in KM"),
                          )
                        ],
                      ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'StartTime (${format.pattern})',
                          ),
                          DateTimeField(
                            validator: (value) {
                              if (value == null) {
                                return 'Please enter a date';
                              }
                              startDate = value;
                              return null;
                            },
                            onSaved: (value) {
                              startDate = value;
                            },
                            format: format,
                            onShowPicker: (context, currentValue) async {
                              final date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now(),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(2100));
                              if (date != null) {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(
                                      currentValue ?? DateTime.now()),
                                );
                                return DateTimeField.combine(date, time);
                              } else {
                                return currentValue;
                              }
                            },
                          ),
                          SizedBox(height: 20),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('End Time (${format.pattern})'),
                                DateTimeField(
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please enter a date';
                                    } else if (startDate != null &&
                                        value.isBefore(startDate)) {
                                      return 'End Date must be after start Date';
                                    } else
                                      return null;
                                  },
                                  onSaved: (value) {
                                    endDate = value;
                                  },
                                  format: format,
                                  onShowPicker: (context, currentValue) async {
                                    final date = await showDatePicker(
                                        context: context,
                                        firstDate: DateTime.now(),
                                        initialDate:
                                            currentValue ?? DateTime.now(),
                                        lastDate: DateTime(2100));
                                    if (date != null) {
                                      final time = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.fromDateTime(
                                            currentValue ?? DateTime.now()),
                                      );

                                      return DateTimeField.combine(date, time);
                                    } else {
                                      return currentValue;
                                    }
                                  },
                                ),
                              ])
                        ]),
                    SizedBox(
                      height: 20,
                    ),
                    _isLoading == true
                        ? CircularProgressIndicator()
                        : RaisedButton(
                            child: Text("Submit"),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.blueAccent)),
                            onPressed: () {
                              _submit();
                            },
                          )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
