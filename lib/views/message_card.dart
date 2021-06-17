import 'package:flutter/material.dart';
import 'package:hoot/assets/colors.dart';
import 'package:hoot/assets/constants.dart';
import 'package:hoot/models/hoot_user.dart';
import 'package:hoot/models/message.dart';
import 'package:intl/intl.dart';

class MessageCardView extends StatelessWidget {
  final HootUser loggedUser;
  final Message message;

  MessageCardView({this.loggedUser, this.message});

  @override
  Widget build(BuildContext context) {
    return message.senderId == loggedUser.id
        ? buildLoggedUserMessage()
        : buildTargetUserMessage();
  }

  Widget buildLoggedUserMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(width: hugePadding),
        Text(
          DateFormat.Hm('en').format(message.date),
          style: TextStyle(fontSize: 12),
        ),
        SizedBox(width: smallPadding),
        Flexible(
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(largeRadius),
              bottomLeft: Radius.circular(largeRadius),
              bottomRight: Radius.circular(largeRadius),
            ),
            child: Container(
              color: secondaryColor,
              child: Padding(
                padding: EdgeInsets.all(smallPadding),
                child: Text(
                  message.content,
                  style: TextStyle(
                    color: primaryColorDarker,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTargetUserMessage() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(largeRadius),
              bottomLeft: Radius.circular(largeRadius),
              bottomRight: Radius.circular(largeRadius),
            ),
            child: Container(
              color: primaryColorDarker,
              child: Padding(
                padding: EdgeInsets.all(smallPadding),
                child: Text(message.content),
              ),
            ),
          ),
        ),
        SizedBox(width: smallPadding),
        Text(
          DateFormat.Hm('en').format(message.date),
          style: TextStyle(fontSize: 12),
        ),
        SizedBox(width: hugePadding),
      ],
    );
  }
}
