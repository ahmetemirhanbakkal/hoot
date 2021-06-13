import 'package:flutter/material.dart';
import 'package:hoot/assets/colors.dart';
import 'package:hoot/assets/constants.dart';
import 'package:hoot/models/hoot_user.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  HootUser _loggedUser, _targetUser;

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments;
    _loggedUser = args['logged_user'];
    _targetUser = args['target_user'];

    return Scaffold(
      appBar: AppBar(
        title: Text(_targetUser.username),
      ),
      body: Column(
        children: [
          Expanded(child: Container()),
          buildMessageBar(),
        ],
      ),
    );
  }

  Widget buildMessageBar() {
    return Container(
      color: primaryColorDark,
      child: Material(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: primaryColor,
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(smallRadius),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.all(largePadding),
                  ),
                ),
              ),
              SizedBox(width: 4),
              IconButton(onPressed: () {}, icon: Icon(Icons.send)),
            ],
          ),
        ),
      ),
    );
  }
}
