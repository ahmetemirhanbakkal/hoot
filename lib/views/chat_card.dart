import 'package:flutter/material.dart';
import 'package:hoot/assets/constants.dart';
import 'package:hoot/assets/globals.dart';
import 'package:hoot/models/chat.dart';
import 'package:hoot/models/hoot_user.dart';

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
  void initState() {
    super.initState();
    _chatName = widget.chat.userIds[0] == widget.loggedUser.id
        ? widget.chat.usernames[1]
        : widget.chat.usernames[0];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          Map args = {
            'chat': widget.chat,
            'logged_user': widget.loggedUser,
          };
          Navigator.pushNamed(homeContext, '/chat', arguments: args);
        },
        child: Padding(
          padding: EdgeInsets.all(smallPadding),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: smallPadding),
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
            ],
          ),
        ),
      ),
    );
  }
}
