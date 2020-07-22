import 'package:ConnectWithGames/Screens/IndividualChatScreen.dart';
import 'package:flutter/material.dart';

class ChatItem extends StatelessWidget {
  final String chatPartner;
  final String chatPartnerId;
  ChatItem(this.chatPartner, this.chatPartnerId);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      height: 70,
      child: InkWell(
        splashColor: Colors.blueAccent,
        onTap: () {
          Navigator.of(context).pushNamed(IndividualChatScreen.routeName,
              arguments: chatPartnerId);
        },
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.blue.withOpacity(0.2),
                  Colors.black38,
                ], begin: Alignment.topCenter, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    'Chatting with : $chatPartner',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
