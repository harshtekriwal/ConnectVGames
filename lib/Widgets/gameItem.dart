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
  final Timestamp startTime;
  final Timestamp endTime;
  final String gameType;
  final double lat;
  final double lng;
  final double distance;
  GameItem(
      {this.userId,
      this.userName,
      this.gameName,
      this.startTime,
      this.endTime,
      this.gameType,
      this.lat,
      this.lng,
      this.distance});
  Future<void> connectUsers() async {
    String append = userId.compareTo(LoggedInUserInfo.id) > 0
        ? userId + LoggedInUserInfo.id
        : LoggedInUserInfo.id + userId;
    try {
      await Firestore.instance.collection('Chats').document(append).setData({
        'idOne': userId,
        'idTwo': LoggedInUserInfo.id,
        'userNameOne': userName,
        'userNameTwo': LoggedInUserInfo.name
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
    if (endTime.toDate().isBefore(DateTime.now())) {
      return Container(
        height: 0,
        width: 0,
      );
    }
    if (DateTime.parse(LoggedInUserInfo.userFilters.startDate)
        .isAfter(endTime.toDate())) {
      return Container(
        height: 0,
        width: 0,
      );
    }
    if (DateTime.parse(LoggedInUserInfo.userFilters.endDate)
        .isBefore(startTime.toDate())) {
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
      print('$lat wow $lng');
      print(
          '${LoggedInUserInfo.userFilters.lat}wuw ${LoggedInUserInfo.userFilters.lng}');

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
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      'Start Time : ${DateFormat.yMMMd().format(startTime.toDate())}'),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                      'End Time : ${DateFormat.yMMMd().format(endTime.toDate())}'),
                  ListTile(
                    leading: Text(
                      'Game Type : ${this.gameType}',
                      style: TextStyle(fontSize: 17),
                    ),
                    title: Text('Added by : $userName'),
                    trailing: IconButton(
                      icon: Icon(Icons.thumb_up),
                      onPressed: () {
                        connectUsers();
                      },
                      color: Colors.black,
                    ),
                  )
                ]),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.blue.withOpacity(0.2),
                  Colors.black38,
                ], begin: Alignment.topCenter, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(15))),
      ),
      elevation: 4,
      margin: EdgeInsets.all(10),
    );
  }
}
