import 'package:ConnectWithGames/Models/loggedInUserInfo.dart';
import 'package:ConnectWithGames/Widgets/gameItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DisplayAvailableGames extends StatelessWidget {
  static const routeName = "/DisplayAvailableGames";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Games'),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('Games').snapshots(),
        builder: (ctx, gamesSnapshot) {
          if (gamesSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final gameDocs = gamesSnapshot.data.documents;
          return ListView.builder(
              itemCount: gameDocs.length,
              itemBuilder: (ctx, index) {
                if (gameDocs[index]['userId'] == LoggedInUserInfo.id) {
                  return Container(
                    height: 0,
                    width: 0,
                  );
                }
                return GameItem(
                    userId: gameDocs[index]['userId'],
                    userName: gameDocs[index]['userName'],
                    gameName: gameDocs[index]['gameName'],
                    gameType: gameDocs[index]['gameType'],
                    startTime: gameDocs[index]['startTime'],
                    endTime: gameDocs[index]['endTime']);
              });
        },
      ),
    );
  }
}
