import 'package:flutter/material.dart';
import 'package:hoot/assets/colors.dart';
import 'package:hoot/assets/constants.dart';
import 'package:hoot/models/chat.dart';
import 'package:hoot/models/hoot_user.dart';
import 'package:hoot/models/message.dart';
import 'package:hoot/services/firestore.dart';
import 'package:hoot/views/message_card.dart';
import 'package:hoot/views/profile_image.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  FirestoreService _firestore = FirestoreService.getInstance();
  HootUser _loggedUser, _targetUser;
  Chat _chat;
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
      if (!_chatRetrieved) getChat();
    }

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            ProfileImageView(imageUrl: _targetUser.profileImage, imageSize: 40),
            SizedBox(width: smallPadding),
            Flexible(child: Text(_targetUser.username)),
            SizedBox(width: smallPadding),
          ],
        ),
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
          return ListView.separated(
            padding: EdgeInsets.all(smallPadding),
            reverse: true,
            itemBuilder: (context, index) {
              Message message = _messages[index];
              Message prevMessage =
                  message == _messages.last ? null : _messages[index + 1];
              return MessageCardView(
                loggedUser: _loggedUser,
                message: message,
                includeDate: prevMessage == null ||
                    !isSameDate(prevMessage.date, message.date),
              );
            },
            separatorBuilder: (context, index) => SizedBox(
              height: smallPadding,
            ),
            itemCount: _messages.length,
          );
        },
      );
    }
  }

  bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
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
                  onSubmitted: (message) => onSendMessage(),
                  textInputAction: TextInputAction.send,
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
        profileImages: [_loggedUser.profileImage, _targetUser.profileImage],
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
    setState(() {});
  }
}
