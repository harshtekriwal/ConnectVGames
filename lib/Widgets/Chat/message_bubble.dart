import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String username;
  final String message;
  final bool isMe;
  final Key key;
  final userImage;
  MessageBubble(
      this.username, this.message, this.userImage, this.isMe, this.key);
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.6),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(12)),
            ),
            width: 140,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: <Widget>[
                Text(username,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isMe
                            ? Colors.black
                            : Theme.of(context)
                                .accentTextTheme
                                .headline1
                                .color)),
                SizedBox(
                  height: 3,
                ),
                Text(
                  message,
                  style: TextStyle(
                      color: isMe
                          ? Colors.black
                          : Theme.of(context).accentTextTheme.headline1.color),
                  textAlign: isMe ? TextAlign.end : TextAlign.start,
                ),
              ],
            ),
          ),
        ],
      ),
      Positioned(
          top: 0,
          left: isMe ? null : 120,
          right: isMe ? 120 : null,
          child: CircleAvatar(
            backgroundImage: NetworkImage(userImage),
          )),
    ], overflow: Overflow.visible);
  }
}
