import 'package:flutter/material.dart';
import 'package:hoot/assets/colors.dart';
import 'package:hoot/assets/constants.dart';
import 'package:hoot/models/chat.dart';
import 'package:hoot/models/hoot_user.dart';
import 'package:hoot/services/firestore.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  FirestoreService _firestore = FirestoreService.getInstance();
  HootUser _loggedUser, _targetUser;
  Chat _chat;
  String _chatName;

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments;
    _loggedUser = args['logged_user'];
    _targetUser = args['target_user'];
    _chat = args['chat'];

    if (_chat == null) {
      _chatName = _targetUser.username;
    } else {
      _chatName = _chat.userIds[0] == _loggedUser.id
          ? _chat.usernames[1]
          : _chat.usernames[0];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_chatName),
      ),
      body: Column(
        children: [
          Expanded(child: buildMessages()),
          buildMessageBar(),
        ],
      ),
    );
  }

  Widget buildMessages() {
    /*
    return StreamBuilder(
      stream: _firestore.getMessagesStream(widget.loggedUser.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) _chats = snapshot.data;
        return ListView.builder(
          itemBuilder: (context, index) {
            return ChatCardView(
              loggedUser: widget.loggedUser,
              chat: _chats[index],
            );
          },
          itemCount: _chats.length,
        );
      },
    );
    */
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
              IconButton(
                onPressed: () => onSendMessage(),
                icon: Icon(Icons.send),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSendMessage() {
    Chat chat = Chat(
      userIds: [_loggedUser.id, _targetUser.id],
      usernames: [_loggedUser.username, _targetUser.username],
      lastMessage: 'test',
      lastMessageDate: DateTime.now(),
    );
    _firestore.createChat(chat);
  }
}
