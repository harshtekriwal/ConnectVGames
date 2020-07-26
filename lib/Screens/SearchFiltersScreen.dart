import 'dart:convert';

import 'package:ConnectWithGames/Helpers/Filters.dart';
import 'package:ConnectWithGames/Helpers/location_helper.dart';
import 'package:ConnectWithGames/Models/loggedInUserInfo.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'map_screen.dart';

class SearchFiltersScreen extends StatefulWidget {
  @override
  _SearchFiltersScreenState createState() => _SearchFiltersScreenState();
}

class _SearchFiltersScreenState extends State<SearchFiltersScreen> {
  var _isPhysical;
  var _isComputer;
  var _hasDefaultDate;
  DateTime gameDate;
  final format = DateFormat("yyyy-MM-dd");
  double maxDistanceRadius;
  double lat;
  double lng;
  String address;
  String newAddress;
  static final _formkey = GlobalKey<FormState>();
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _isPhysical = LoggedInUserInfo.userFilters.isPhysical;
    _isComputer = LoggedInUserInfo.userFilters.isComputer;
    gameDate = LoggedInUserInfo.userFilters.gameDate == null
        ? null
        : DateTime.parse(LoggedInUserInfo.userFilters.gameDate);
    maxDistanceRadius = LoggedInUserInfo.userFilters.distance;
    lat = LoggedInUserInfo.userFilters.lat;
    lng = LoggedInUserInfo.userFilters.lng;
    address = LoggedInUserInfo.userFilters.address;
    newAddress = LoggedInUserInfo.userFilters.address;
    _hasDefaultDate =
        LoggedInUserInfo.userFilters.gameDate == null ? false : true;
    _controller.text = address;
    super.initState();
  }

  void _updateAddress(String add) {
    setState(() {
      newAddress = add;
      _controller.text = newAddress;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _selectOnMap() async {
    try {
      final selectedLocation = await Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => MapScreen(lat, lng, address)));
      if (selectedLocation == null) {
        return;
      } else {
        lat = selectedLocation[0];
        lng = selectedLocation[1];
        final address = await LocationHelper.getPlaceAddress(
            selectedLocation[0], selectedLocation[1]);
        _updateAddress(address);
      }
    } on PlatformException catch (err) {
      print(err);
    } catch (err) {
      print(err);
    }
  }

  Widget switchFilterBuilder(
      String title, String subtitle, bool currentValue, Function onSwitched) {
    return SwitchListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        value: currentValue,
        onChanged: onSwitched);
  }

  Future<void> _saveFilters() async {
    if (!_formkey.currentState.validate()) {
      return;
    }
    _formkey.currentState.save();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    Filters filters = Filters(
        lat: lat,
        lng: lng,
        distance: maxDistanceRadius,
        isComputer: _isComputer,
        isPhysical: _isPhysical,
        gameDate: _hasDefaultDate ? gameDate.toIso8601String() : null,
        address: _isPhysical ? newAddress : address);
    String value = jsonEncode(filters);
    prefs.setString('defaultValues/${LoggedInUserInfo.id}', value);
    LoggedInUserInfo.userFilters.isPhysical = _isPhysical;
    LoggedInUserInfo.userFilters.isComputer = _isComputer;
    LoggedInUserInfo.userFilters.gameDate =
        _hasDefaultDate ? gameDate.toIso8601String() : null;
    LoggedInUserInfo.userFilters.distance = maxDistanceRadius;
    LoggedInUserInfo.userFilters.lat = lat;
    LoggedInUserInfo.userFilters.lng = lng;
    LoggedInUserInfo.userFilters.address = _isPhysical ? newAddress : address;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Search Filters'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.save),
                onPressed: () async {
                  await _saveFilters();
                })
          ],
        ),
        body: Form(
            key: _formkey,
            child: Card(
              margin: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(children: <Widget>[
                  switchFilterBuilder('Physical-Game', "", _isPhysical, (val) {
                    setState(() {
                      _isPhysical = val;
                    });
                  }),
                  switchFilterBuilder('Computer-Game', "", _isComputer, (val) {
                    setState(() {
                      _isComputer = val;
                    });
                  }),
                  switchFilterBuilder('Choose a Date', "", _hasDefaultDate,
                      (val) {
                    setState(() {
                      _hasDefaultDate = val;
                    });
                  }),
                  if (_hasDefaultDate)
                    Text(
                      'Date(${format.pattern})',
                      textAlign: TextAlign.center,
                    ),
                  if (_hasDefaultDate)
                    DateTimeField(
                      initialValue: gameDate,
                      validator: (value) {
                        if (value == null) {
                          return 'Please enter a date';
                        }
                        gameDate = value;
                        return null;
                      },
                      onSaved: (value) {
                        gameDate = value;
                      },
                      format: format,
                      onShowPicker: (context, currentValue) async {
                        final date = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                        return date;
                      },
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  if (_isPhysical)
                    RaisedButton.icon(
                      icon: Icon(Icons.location_on),
                      label: Text("Changed Default Location"),
                      onPressed: () {
                        _selectOnMap();
                      },
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  if (_isPhysical)
                    TextField(
                      readOnly: true,
                      controller: _controller,
                    ),
                  if (_isPhysical)
                    TextFormField(
                      keyboardType: TextInputType.number,
                      initialValue:
                          LoggedInUserInfo.userFilters.distance.toString(),
                      validator: (value) {
                        if (value.length <= 0) {
                          return "Please enter a distance";
                        }
                        if (double.parse(value) < 0 ||
                            double.parse(value) > 12756) {
                          return "Please enter a valid distance";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        maxDistanceRadius = double.parse(val);
                      },
                      decoration:
                          InputDecoration(labelText: "Maximum Distance in KM"),
                    )
                ]),
              ),
            )));
  }
}
