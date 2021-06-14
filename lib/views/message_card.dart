import 'package:flutter/material.dart';
import 'package:hoot/assets/constants.dart';
import 'package:hoot/models/hoot_user.dart';
import 'package:hoot/models/message.dart';

class MessageCardView extends StatelessWidget {
  final HootUser loggedUser;
  final Message message;

  MessageCardView({this.loggedUser, this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(smallPadding),
      child: Text(message.content),
    );
  }
}
