import 'package:flutter/material.dart';
import 'package:hoot/assets/colors.dart';
import 'package:hoot/assets/constants.dart';
import 'package:hoot/models/hoot_user.dart';
import 'package:hoot/models/message.dart';
import 'package:intl/intl.dart';

class MessageCardView extends StatelessWidget {
  final HootUser loggedUser;
  final Message message;
  final bool includeDate;

  MessageCardView({this.loggedUser, this.message, this.includeDate});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (includeDate) buildDate(),
        message.senderId == loggedUser.id
            ? buildLoggedUserMessage()
            : buildTargetUserMessage(),
      ],
    );
  }

  Widget buildDate() {
    return Padding(
      padding: EdgeInsets.only(bottom: smallPadding),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(largeRadius),
        child: Container(
          color: primaryColorDark.withOpacity(0.5),
          child: Padding(
            padding: EdgeInsets.all(smallPadding),
            child: Text(
              DateFormat.MMMMd('en').format(message.date),
              style: TextStyle(color: secondaryColor),
            ),
          ),
        ),
      ),
    );
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
