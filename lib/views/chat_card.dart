import 'package:flutter/material.dart';
import 'package:hoot/assets/colors.dart';
import 'package:hoot/assets/constants.dart';
import 'package:hoot/assets/globals.dart';
import 'package:hoot/models/chat.dart';
import 'package:hoot/models/hoot_user.dart';
import 'package:intl/intl.dart';

class ChatCardView extends StatefulWidget {
  final HootUser loggedUser;
  final Chat chat;

  ChatCardView({this.loggedUser, this.chat});

  @override
  _ChatCardViewState createState() => _ChatCardViewState();
}

class _ChatCardViewState extends State<ChatCardView> {
  String _chatName;

  @override
  Widget build(BuildContext context) {
    _chatName = widget.chat.userIds[0] == widget.loggedUser.id
        ? widget.chat.usernames[1]
        : widget.chat.usernames[0];

    return Container(
      child: InkWell(
        onTap: () {
          Map args = {
            'chat': widget.chat,
            'logged_user': widget.loggedUser,
          };
          Navigator.pushNamed(homeContext, '/chat', arguments: args);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(largePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _chatName,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(height: 4),
                    Text(widget.chat.lastMessage),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(largePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    DateFormat.MMMMd('en').format(widget.chat.lastMessageDate),
                    style: TextStyle(color: secondaryColor),
                  ),
                  SizedBox(height: 4),
                  Text(
                    DateFormat.Hm('en').format(widget.chat.lastMessageDate),
                    style: TextStyle(
                      color: secondaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
