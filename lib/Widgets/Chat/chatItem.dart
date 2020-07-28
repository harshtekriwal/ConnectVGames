import 'package:ConnectWithGames/Screens/IndividualChatScreen.dart';
import 'package:flutter/material.dart';

class ChatItem extends StatelessWidget {
  final String chatPartner;
  final String chatPartnerId;
  final String chatPartnerImageUrl;
  ChatItem(this.chatPartner, this.chatPartnerId, this.chatPartnerImageUrl);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(15.0),
              topRight: const Radius.circular(15.0))),
      margin: EdgeInsets.all(5),
      height: 70,
      width: double.infinity,
      child: InkWell(
        splashColor: Colors.pink,
        onTap: () {
          Navigator.of(context).pushNamed(IndividualChatScreen.routeName,
              arguments: chatPartnerId);
        },
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(chatPartnerImageUrl),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    '$chatPartner',
                    style: TextStyle(fontSize: 15),
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
