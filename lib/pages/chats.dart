import 'package:flutter/material.dart';
import 'package:hoot/models/chat.dart';
import 'package:hoot/models/hoot_user.dart';
import 'package:hoot/services/firestore.dart';
import 'package:hoot/views/chat_card.dart';

class ChatsPage extends StatefulWidget {
  final HootUser loggedUser;

  ChatsPage({this.loggedUser});

  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  FirestoreService _firestore = FirestoreService.getInstance();
  List<Chat> _chats = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore.getChatsStream(widget.loggedUser.id),
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
  }
}
