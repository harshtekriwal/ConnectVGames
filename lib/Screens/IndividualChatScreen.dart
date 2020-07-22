import 'package:ConnectWithGames/Widgets/Chat/Messages.dart';
import 'package:ConnectWithGames/Widgets/Chat/NewMessage.dart';
import 'package:flutter/material.dart';

class IndividualChatScreen extends StatelessWidget {
  static const routeName = "/IndividualChatScreen";
  @override
  Widget build(BuildContext context) {
    String chatPartnerId = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(title: Text('Chat Screen')),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(child: Messages(chatPartnerId)),
            NewMessage(chatPartnerId),
          ],
        ),
      ),
    );
  }
}
