import 'package:hoot/models/message.dart';

class Chat {
  List<String> userIds;
  List<String> usernames;
  List<Message> messages;
  String lastMessage;
  DateTime lastMessageDate;

  Chat({
    this.userIds,
    this.usernames,
    this.messages,
    this.lastMessage,
    this.lastMessageDate,
  });
}
