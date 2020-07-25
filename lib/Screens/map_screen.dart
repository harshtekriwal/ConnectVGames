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
  String searchAddress;
  GoogleMapController mapController;

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
        body: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                  hintText: 'Enter Address',
                  contentPadding: EdgeInsets.only(left: 15, top: 15),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {},
                  )),
              onChanged: (val) {
                setState(() {
                  searchAddress = val;
                });
              },
            ),
            Container(
              height: 250,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(widget.lat, widget.lng),
                  zoom: 16,
                ),
                onTap: _selectPlace,
                markers: _pickedLocation == null
                    ? null
                    : {
                        Marker(
                            markerId: MarkerId('m1'), position: _pickedLocation)
                      },
              ),
            ),
          ],
        ));
  }
}
