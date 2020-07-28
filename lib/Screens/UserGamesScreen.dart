import 'package:ConnectWithGames/Models/loggedInUserInfo.dart';
import 'package:ConnectWithGames/Widgets/user_game.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserGamesScreen extends StatelessWidget {
  static const routeName = "/UserGamesScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Games'),
        ),
        body: StreamBuilder(
            stream: Firestore.instance
                .collection('Games')
                .where('userId', isEqualTo: LoggedInUserInfo.id)
                .snapshots(),
            builder: (ctx, gamesSnapshot) {
              if (gamesSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              List gameDocs = gamesSnapshot.data.documents;
              return ListView.builder(
                  itemCount: gameDocs.length,
                  itemBuilder: (ctx, index) {
                    return UserGameItem(
                      gameId: gameDocs[index].documentID,
                      gameName: gameDocs[index]['gameName'],
                      gameType: gameDocs[index]['gameType'],
                      playDate: gameDocs[index]['playDate'],
                      distanceRange: gameDocs[index]['distanceRange'],
                      lat: gameDocs[index]['latitude'],
                      lng: gameDocs[index]['longitude'],
                    );
                  });
            }));
  }
}
