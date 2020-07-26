import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart';
import 'package:ConnectWithGames/Helpers/location_helper.dart';

class MapScreen extends StatefulWidget {
  double lat;
  double lng;
  String address;

  MapScreen(this.lat, this.lng, this.address);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  TextEditingController _controller = TextEditingController();
  LatLng _pickedLocation;
  String searchAddress;
  GoogleMapController mapController;
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: Gkey.GOOGLE_API_KEY);
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    _pickedLocation = LatLng(widget.lat, widget.lng);
    _controller.text = widget.address;
    super.initState();
  }

  Future<void> _selectPlace(LatLng position) async {
    widget.address = await LocationHelper.getPlaceAddress(
        position.latitude, position.longitude);
    setState(() {
      _controller.text = widget.address;
      _pickedLocation = position;
      widget.lat = _pickedLocation.latitude;
      widget.lng = _pickedLocation.longitude;
      mapController
          .moveCamera(CameraUpdate.newLatLng(LatLng(widget.lat, widget.lng)));
    });
  }

  Future<Null> displayPrediction(Prediction p) async {
    try {
      if (p != null) {
        PlacesDetailsResponse detail =
            await _places.getDetailsByPlaceId(p.placeId);

        final lt = detail.result.geometry.location.lat;
        final lg = detail.result.geometry.location.lng;
        LatLng position = LatLng(lt, lg);
        widget.address = await LocationHelper.getPlaceAddress(
            position.latitude, position.longitude);

        setState(() {
          _controller.text = widget.address;
          _pickedLocation = position;
          widget.lat = _pickedLocation.latitude;
          widget.lng = _pickedLocation.longitude;
          mapController.moveCamera(
              CameraUpdate.newLatLng(LatLng(widget.lat, widget.lng)));
        });
      }
    } on PlatformException catch (err) {
      print(err);
    } on ClientException catch (err) {
      print(err);
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Map"),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.check,
              ),
              onPressed: _pickedLocation == null
                  ? null
                  : () {
                      var ar = [
                        _pickedLocation.latitude,
                        _pickedLocation.longitude
                      ];
                      Navigator.of(context).pop(ar);
                    },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                  readOnly: true,
                  onTap: () async {
                    try {
                      Prediction p = await PlacesAutocomplete.show(
                        context: context,
                        apiKey: Gkey.GOOGLE_API_KEY,
                        onError: (value) {
                          print("err");
                        },
                        mode: Mode.fullscreen,
                        language: "en",
                        components: [
                          Component(Component.country, "in"),
                        ],
                      );
                      await displayPrediction(p);
                    } on PlatformException catch (err) {
                      print(err);
                    } catch (err) {
                      print(err + "lol");
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Choose a Location!',
                    contentPadding: EdgeInsets.only(left: 3, top: 15),
                  )),
              Container(
                height: 250,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _pickedLocation,
                    zoom: 16,
                  ),
                  onTap: _selectPlace,
                  markers: _pickedLocation == null
                      ? null
                      : {
                          Marker(
                              markerId: MarkerId('m1'),
                              position: _pickedLocation)
                        },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: _controller,
                  readOnly: true,
                ),
              )
            ],
          ),
        ));
  }
}
