import 'package:ConnectWithGames/Models/loggedInUserInfo.dart';
import 'package:ConnectWithGames/Widgets/chatItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Connections'),
        ),
        body: StreamBuilder(
            stream: Firestore.instance.collection('Chats').snapshots(),
            builder: (ctx, chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              final chatDocs = chatSnapshot.data.documents;
              return ListView.builder(
                  itemCount: chatDocs.length,
                  itemBuilder: (ctx, index) {
                    if (chatDocs[index]['idOne'] == LoggedInUserInfo.id) {
                      return ChatItem(chatDocs[index]['userNameTwo'],
                          chatDocs[index]['idTwo']);
                    } else if (chatDocs[index]['idTwo'] ==
                        LoggedInUserInfo.id) {
                      return ChatItem(chatDocs[index]['userNameOne'],
                          chatDocs[index]['idOne']);
                    } else {
                      return Container(
                        height: 0,
                        width: 0,
                      );
                    }
                  });
            }));
  }
}
