import 'package:ConnectWithGames/Models/loggedInUserInfo.dart';
import 'package:ConnectWithGames/Screens/SearchFiltersScreen.dart';
import 'package:ConnectWithGames/Widgets/gameItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DisplayAvailableGames extends StatefulWidget {
  static const routeName = "/DisplayAvailableGames";

  @override
  _DisplayAvailableGamesState createState() => _DisplayAvailableGamesState();
}

class _DisplayAvailableGamesState extends State<DisplayAvailableGames> {
  String searchString;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Available Games'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.settings),
                onPressed: () async {
                  final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (ctx) => SearchFiltersScreen()));
                  if (result == null) {
                  } else {
                    setState(() {});
                  }
                })
          ],
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchString = value.toLowerCase();
                        });
                      },
                    ),
                  ),
                  IconButton(icon: Icon(Icons.search), onPressed: () {}),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: (searchString == null || searchString.trim() == "")
                    ? Firestore.instance.collection('Games').snapshots()
                    : Firestore.instance
                        .collection('Games')
                        .where("searchindex",
                            arrayContains: searchString.toLowerCase())
                        .snapshots(),
                builder: (ctx, gamesSnapshot) {
                  if (gamesSnapshot.connectionState ==
                      ConnectionState.waiting) {
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
                            gameTime: gameDocs[index]['playDate'],
                            lat: gameDocs[index]['latitude'],
                            lng: gameDocs[index]['longitude'],
                            distance: gameDocs[index]['distanceRange']);
                      });
                },
              ),
            ),
          ],
        ));
  }
}
