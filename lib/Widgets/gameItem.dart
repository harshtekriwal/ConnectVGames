import 'package:ConnectWithGames/Models/loggedInUserInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GameItem extends StatelessWidget {
  final String userName;
  final String userId;
  final String gameName;
  final Timestamp startTime;
  final Timestamp endTime;
  final String gameType;
  GameItem(
      {this.userId,
      this.userName,
      this.gameName,
      this.startTime,
      this.endTime,
      this.gameType});
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
                  Text('Start Time ${startTime.toDate().toIso8601String()}'),
                  SizedBox(
                    width: 10,
                  ),
                  Text('End Time ${endTime.toDate().toIso8601String()}'),
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
