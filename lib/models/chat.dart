import 'package:hoot/models/message.dart';

class Chat {
  String id;
  List<String> userIds;
  List<String> usernames;
  List<String> profileImages;
  List<Message> messages;
  String lastMessage;
  DateTime lastMessageDate;

  Chat({
    this.id,
    this.userIds,
    this.usernames,
    this.messages,
    this.lastMessage,
    this.lastMessageDate,
    this.profileImages,
  });
}
