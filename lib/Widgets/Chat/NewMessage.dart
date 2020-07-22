import 'package:ConnectWithGames/Models/loggedInUserInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NewMessage extends StatefulWidget {
  String chatPartnerId;
  NewMessage(this.chatPartnerId);
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  String chatDocument;
  final _controller = new TextEditingController();
  var _enteredMessage = '';

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    if (widget.chatPartnerId.compareTo(LoggedInUserInfo.id) > 0) {
      chatDocument = widget.chatPartnerId + LoggedInUserInfo.id;
    } else {
      chatDocument = LoggedInUserInfo.id + widget.chatPartnerId;
    }
    Firestore.instance
        .collection('Chats')
        .document(chatDocument)
        .collection('Messages')
        .add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': LoggedInUserInfo.id,
      'username': LoggedInUserInfo.name
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
              child: TextField(
            textCapitalization: TextCapitalization.sentences,
            autocorrect: false,
            enableSuggestions: false,
            controller: _controller,
            decoration: InputDecoration(labelText: 'Send a message...'),
            onChanged: (value) {
              setState(() {
                _enteredMessage = value;
              });
            },
          )),
          IconButton(
            icon: Icon(Icons.send),
            color: Theme.of(context).primaryColor,
            onPressed: _enteredMessage.trim().isEmpty
                ? null
                : () {
                    _sendMessage();
                  },
          )
        ],
      ),
    );
  }
}
