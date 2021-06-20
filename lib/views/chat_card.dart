import 'package:flutter/material.dart';
import 'package:hoot/assets/colors.dart';
import 'package:hoot/assets/constants.dart';
import 'package:hoot/assets/globals.dart';
import 'package:hoot/models/chat.dart';
import 'package:hoot/models/hoot_user.dart';
import 'package:hoot/views/profile_image.dart';
import 'package:intl/intl.dart';

class ChatCardView extends StatefulWidget {
  final HootUser loggedUser;
  final Chat chat;

  ChatCardView({this.loggedUser, this.chat});

  @override
  _ChatCardViewState createState() => _ChatCardViewState();
}

class _ChatCardViewState extends State<ChatCardView> {
  HootUser _targetUser;

  @override
  Widget build(BuildContext context) {
    int targetIndex = widget.chat.userIds[0] == widget.loggedUser.id ? 1 : 0;
    _targetUser = HootUser(
      id: widget.chat.userIds[targetIndex],
      username: widget.chat.usernames[targetIndex],
      profileImage: widget.chat.profileImages[targetIndex],
    );

    return Container(
      child: InkWell(
        onTap: () {
          Map args = {
            'chat': widget.chat,
            'logged_user': widget.loggedUser,
            'target_user': _targetUser
          };
          Navigator.pushNamed(homeContext, '/chat', arguments: args);
        },
        child: Row(
          children: [
            SizedBox(width: smallPadding),
            ProfileImageView(imageUrl: _targetUser.profileImage, imageSize: 52),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(largePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _targetUser.username,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.chat.lastMessage,
                      overflow: TextOverflow.ellipsis,
                    ),
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
