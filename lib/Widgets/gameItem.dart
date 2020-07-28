import 'package:ConnectWithGames/Models/loggedInUserInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:great_circle_distance/great_circle_distance.dart';
import 'package:intl/intl.dart';

class GameItem extends StatelessWidget {
  final String userName;
  final String userId;
  final String gameName;
  final Timestamp gameTime;
  final String gameType;
  final double lat;
  final double lng;
  final double distance;
  GameItem(
      {this.userId,
      this.userName,
      this.gameName,
      this.gameTime,
      this.gameType,
      this.lat,
      this.lng,
      this.distance});
  Future<void> connectUsers() async {
    String append = userId.compareTo(LoggedInUserInfo.id) > 0
        ? userId + LoggedInUserInfo.id
        : LoggedInUserInfo.id + userId;
    try {
      final image =
          await Firestore.instance.collection('users').document(userId).get();
      final imageUrl = image.data['image_url'];
      await Firestore.instance.collection('Chats').document(append).setData({
        'idOne': userId,
        'idTwo': LoggedInUserInfo.id,
        'userNameOne': userName,
        'userNameTwo': LoggedInUserInfo.name,
        'imageOne': imageUrl,
        'imageTwo': LoggedInUserInfo.url
      });
      print("sucess");
    } on PlatformException catch (err) {
      print(err);
    } on AuthException catch (err) {
      print(err);
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (gameTime.toDate().isBefore(DateTime.now())) {
      return Container(
        height: 0,
        width: 0,
      );
    }
    if (gameType == 'Physical' &&
        LoggedInUserInfo.userFilters.isPhysical == false) {
      return Container(
        height: 0,
        width: 0,
      );
    }
    if (gameType == 'Computer' &&
        LoggedInUserInfo.userFilters.isComputer == false) {
      return Container(
        height: 0,
        width: 0,
      );
    }
    if (gameType == 'Physical') {
      print("wow");
      var distanceBetweenPlaces = GreatCircleDistance.fromDegrees(
          latitude1: lat,
          latitude2: LoggedInUserInfo.userFilters.lat,
          longitude1: lng,
          longitude2: LoggedInUserInfo.userFilters.lng);
      double maxDistance = distanceBetweenPlaces.vincentyDistance() / 1000;
      print(maxDistance);
      print(LoggedInUserInfo.userFilters.distance);
      if (maxDistance > distance ||
          maxDistance > LoggedInUserInfo.userFilters.distance) {
        return Container(
          height: 0,
          width: 0,
        );
      }
    }
    if (LoggedInUserInfo.userFilters.gameDate != null) {
      DateTime date1 = gameTime.toDate();
      DateTime date2 = DateTime.parse(LoggedInUserInfo.userFilters.gameDate);
      print(date1);
      print(date2);
      if (date1.year != date2.year ||
          date1.month != date2.month ||
          date1.day != date2.day) {
        return Container(
          height: 0,
          width: 0,
        );
      }
    }
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Text(
                      'Date : ${DateFormat.yMMMd().format(gameTime.toDate())}'),
                  ListTile(
                    leading: Text(
                      'Type : ${this.gameType}',
                      style: TextStyle(fontSize: 17),
                    ),
                    title: Text('Added by : $userName'),
                    trailing: OutlineButton.icon(
                      borderSide: BorderSide(color: Colors.black),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0)),
                      label: Text("Play"),
                      onPressed: () {
                        connectUsers();
                      },
                      icon: Icon(Icons.thumb_up),
                    ),
                  )
                ]),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15))),
      ),
      elevation: 4,
      margin: EdgeInsets.all(10),
    );
  }
}
