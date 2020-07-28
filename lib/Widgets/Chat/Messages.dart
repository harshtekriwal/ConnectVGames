import 'package:ConnectWithGames/Models/loggedInUserInfo.dart';
import 'package:ConnectWithGames/Widgets/Chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Messages extends StatelessWidget {
  final String chatPartnerId;
  String chatDocument;
  Messages(this.chatPartnerId);
  @override
  Widget build(BuildContext context) {
    if (chatPartnerId.compareTo(LoggedInUserInfo.id) > 0) {
      chatDocument = chatPartnerId + LoggedInUserInfo.id;
    } else {
      chatDocument = LoggedInUserInfo.id + chatPartnerId;
    }
    return StreamBuilder(
        stream: Firestore.instance
            .collection('Chats')
            .document(chatDocument)
            .collection('Messages')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final chatDocs = chatSnapshot.data.documents;
          return ListView.builder(
            reverse: true,
            itemCount: chatDocs.length,
            itemBuilder: (ctx, index) => MessageBubble(
                chatDocs[index]['username'],
                chatDocs[index]['text'],
                chatDocs[index]['userImage'],
                chatDocs[index]['userId'] == LoggedInUserInfo.id,
                ValueKey(chatDocs[index].documentID)),
          );
        });
  }
}
