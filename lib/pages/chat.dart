import 'package:flutter/material.dart';
import 'package:hoot/assets/colors.dart';
import 'package:hoot/assets/constants.dart';
import 'package:hoot/models/chat.dart';
import 'package:hoot/models/hoot_user.dart';
import 'package:hoot/models/message.dart';
import 'package:hoot/services/firestore.dart';
import 'package:hoot/views/message_card.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  FirestoreService _firestore = FirestoreService.getInstance();
  HootUser _loggedUser, _targetUser;
  Chat _chat;
  String _chatName;
  bool _chatRetrieved = false;
  String _inputContent = '';
  TextEditingController _inputController = TextEditingController();

  List<Message> _messages = [];

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments;
    _loggedUser ??= args['logged_user'];
    _targetUser ??= args['target_user'];
    _chat ??= args['chat'];

    if (_chat == null) {
      _chatName = _targetUser.username;
      if (!_chatRetrieved) getChat();
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
    if (_chat == null) {
      return Container();
    } else {
      return StreamBuilder(
        stream: _firestore.getMessagesStream(_chat.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) _messages = snapshot.data;
          return ListView.builder(
            itemBuilder: (context, index) {
              return MessageCardView(
                loggedUser: _loggedUser,
                message: _messages[index],
              );
            },
            itemCount: _messages.length,
          );
        },
      );
    }
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
                  controller: _inputController,
                  onChanged: (value) => _inputContent = value,
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

  void getChat() async {
    dynamic result = await _firestore.getChat(_loggedUser.id, _targetUser.id);
    if (result is String)
      print(result);
    else
      _chat = result;
    setState(() => _chatRetrieved = true);
  }

  void onSendMessage() async {
    String messageContent = _inputContent.trim();
    if (messageContent.isEmpty) return;
    if (_chat == null && !_chatRetrieved) return;

    if (_chat == null && _chatRetrieved) {
      _chat = Chat(
        userIds: [_loggedUser.id, _targetUser.id],
        usernames: [_loggedUser.username, _targetUser.username],
        lastMessage: messageContent,
        lastMessageDate: DateTime.now(),
      );
      String error = await _firestore.createChat(_chat, _loggedUser.id);
      if (error != null) {
        print(error);
        return;
      }
    } else {
      String error = await _firestore.updateChat(
        _chat.id,
        messageContent,
        _loggedUser.id,
      );
      if (error != null) {
        print(error);
        return;
      }
    }

    _inputController.clear();

    Message message = Message(
      senderId: _loggedUser.id,
      content: messageContent,
      date: DateTime.now(),
    );
    await _firestore.sendMessage(_chat.id, message);
  }
}
