import 'package:ConnectWithGames/Helpers/location_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserGameItem extends StatelessWidget {
  final gameId;
  final gameName;
  final gameType;
  final playDate;
  final distanceRange;
  final lat;
  final lng;
  String address;

  UserGameItem(
      {this.gameId,
      this.gameName,
      this.gameType,
      this.playDate,
      this.distanceRange,
      this.lat,
      this.lng});
  Future<void> _getAddress() async {
    if (lat != null && lng != null) {
      address = await LocationHelper.getPlaceAddress(lat, lng);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (DateTime.now().isAfter(playDate.toDate())) {
      return Container(
        height: 0,
        width: 0,
      );
    }
    return FutureBuilder(
        future: _getAddress(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: 0,
              width: 0,
            );
          }
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: InkWell(
              onTap: () {},
              splashColor: Theme.of(context).primaryColor,
              child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          this.gameName,
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        Divider(
                          thickness: 1,
                          color: Colors.black45,
                        ),
                        Text(
                          this.address,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Date : ${DateFormat.yMMMd().format(playDate.toDate())}',
                          style: TextStyle(fontSize: 16),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              'Type : ${this.gameType}',
                              style: TextStyle(fontSize: 17),
                            ),
                            Text(
                              'Range : ${this.distanceRange} KM',
                              style: TextStyle(fontSize: 17),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () async {
                                await Firestore.instance
                                    .collection('Games')
                                    .document(gameId)
                                    .delete();
                              },
                            )
                          ],
                        )
                      ]),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15))),
            ),
            elevation: 4,
            margin: EdgeInsets.all(10),
          );
        });
  }
}
