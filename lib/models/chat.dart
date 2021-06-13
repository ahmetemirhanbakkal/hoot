import 'package:hoot/models/message.dart';

class Chat {
  List<String> userIds;
  List<Message> messages;

  Chat({this.userIds, this.messages});
}
