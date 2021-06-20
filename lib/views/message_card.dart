import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:hoot/assets/colors.dart';
import 'package:hoot/assets/constants.dart';
import 'package:hoot/assets/globals.dart';
import 'package:hoot/models/hoot_user.dart';
import 'package:hoot/models/message.dart';
import 'package:hoot/services/firestore.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageCardView extends StatelessWidget {
  final FirestoreService _firestore = FirestoreService.getInstance();
  final HootUser loggedUser;
  final Message message;
  final bool includeDate;
  final String chatId;

  MessageCardView({
    this.loggedUser,
    this.message,
    this.includeDate,
    this.chatId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (includeDate) buildDate(),
        message.senderId == loggedUser.id
            ? buildLoggedUserMessage(context)
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
              getDateString(message.date),
              style: TextStyle(color: secondaryColor),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLoggedUserMessage(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        print('long');
        AlertDialog dialog = AlertDialog(
          title: Text('Do you want to delete this message?'),
          actions: [
            TextButton(
              onPressed: () {
                _firestore.deleteMessage(chatId, message.id);
                Navigator.pop(context);
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('No'),
            ),
          ],
        );
        showDialog(context: context, builder: (context) => dialog);
      },
      child: Row(
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
                  child: Linkify(
                    onOpen: (link) async => await launch(link.url),
                    text: message.content,
                    style: TextStyle(
                      color: primaryColorDarker,
                      fontWeight: FontWeight.w500,
                    ),
                    linkStyle: TextStyle(
                      color: primaryColorLight,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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
                child: Linkify(
                  text: message.content,
                  linkStyle: TextStyle(color: secondaryColor),
                  onOpen: (link) async => await launch(link.url),
                ),
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
