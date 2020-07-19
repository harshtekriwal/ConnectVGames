import 'package:ConnectWithGames/Helpers/location_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final lat;
  final lng;
  MapScreen(this.lat, this.lng);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _pickedLocation;

  void _selectPlace(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
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
        body: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.lat, widget.lng),
            zoom: 16,
          ),
          onTap: _selectPlace,
          markers: _pickedLocation == null
              ? null
              : {Marker(markerId: MarkerId('m1'), position: _pickedLocation)},
        ));
  }
}
