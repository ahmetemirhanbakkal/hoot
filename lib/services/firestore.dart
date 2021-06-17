import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hoot/models/chat.dart';
import 'package:hoot/models/hoot_user.dart';
import 'package:hoot/models/message.dart';

class FirestoreService {
  static FirestoreService _instance;

  static FirestoreService getInstance() {
    if (_instance == null) _instance = FirestoreService();
    return _instance;
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> createUser(String id, String username, String email) async {
    CollectionReference usersCollection = firestore.collection('users');
    try {
      await usersCollection.doc(id).set({
        'username': username,
        'email': email,
        'friendIds': [],
      });
      return null;
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  Future getUserDetails(HootUser user) async {
    CollectionReference usersCollection = firestore.collection('users');
    try {
      DocumentSnapshot document = await usersCollection.doc(user.id).get();
      user.username = document.get('username');
      user.friendIds = document.get('friendIds').cast<String>();
      return null;
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  Future searchUsers(String query, String loggedUserId) async {
    List<HootUser> users = [];
    if (query.length < 3) return users;
    CollectionReference usersCollection = firestore.collection('users');
    try {
      QuerySnapshot querySnapshot = await usersCollection
          .where('username', isGreaterThanOrEqualTo: query)
          .where('username', isLessThanOrEqualTo: query + '\uf8ff')
          .get();
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        if (document.id == loggedUserId) continue;
        users.add(HootUser(
          id: document.id,
          username: document.get('username'),
          email: document.get('email'),
          friendIds: document.get('friendIds').cast<String>(),
        ));
      }
      return users;
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  Future addOrRemoveFriend(
    String userId,
    String friendId,
    bool alreadyFriend,
  ) async {
    CollectionReference usersCollection = firestore.collection('users');
    try {
      await usersCollection.doc(userId).update({
        'friendIds': alreadyFriend
            ? FieldValue.arrayRemove([friendId])
            : FieldValue.arrayUnion([friendId]),
      });
      return null;
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  Future getFriends(HootUser loggedUser) async {
    List<HootUser> users = [];
    loggedUser.friends = users;
    if (loggedUser.friendIds.isEmpty) return null;
    CollectionReference usersCollection = firestore.collection('users');
    try {
      QuerySnapshot querySnapshot = await usersCollection
          .where(FieldPath.documentId, whereIn: loggedUser.friendIds)
          .get();
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        users.add(HootUser(
          id: document.id,
          username: document.get('username'),
          email: document.get('email'),
          friendIds: document.get('friendIds').cast<String>(),
        ));
      }
      return null;
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  Future createChat(Chat chat, String userId) async {
    CollectionReference chatsCollection = firestore.collection('chats');
    try {
      await chatsCollection.add({
        'userIds': chat.userIds,
        'usernames': chat.usernames,
        'lastMessage': chat.lastMessage,
        'lastMessageSenderId': userId,
        'lastMessageDate': Timestamp.now(),
      });
      return null;
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  Future updateChat(String chatId, String lastMessage, String userId) async {
    CollectionReference chatsCollection = firestore.collection('chats');
    try {
      await chatsCollection.doc(chatId).update({
        'lastMessage': lastMessage,
        'lastMessageSenderId': userId,
        'lastMessageDate': Timestamp.now(),
      });
      return null;
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  Chat _chatFromSnapshot(DocumentSnapshot document) {
    Timestamp lastMessageTimestamp = document.get('lastMessageDate');
    return Chat(
      id: document.id,
      userIds: document.get('userIds').cast<String>(),
      usernames: document.get('usernames').cast<String>(),
      lastMessage: document.get('lastMessage'),
      lastMessageDate: lastMessageTimestamp.toDate(),
    );
  }

  Stream<List<Chat>> getChatsStream(String userId) {
    CollectionReference chatsCollection = firestore.collection('chats');
    return chatsCollection
        .where('userIds', arrayContains: userId)
        .orderBy('lastMessageDate', descending: true)
        .snapshots()
        .map((event) {
      List<Chat> chats = [];
      for (QueryDocumentSnapshot document in event.docs) {
        chats.add(_chatFromSnapshot(document));
      }
      return chats;
    });
  }

  Future getChat(String loggedUserId, String targetUserId) async {
    CollectionReference chatsCollection = firestore.collection('chats');
    try {
      QuerySnapshot querySnapshot = await chatsCollection
          .where('userIds', arrayContains: loggedUserId)
          .get();
      if (querySnapshot.docs.isEmpty) return null;
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        List<String> userIds = document.get('userIds').cast<String>();
        if (userIds.contains(targetUserId)) return _chatFromSnapshot(document);
      }
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  Stream<List<Message>> getMessagesStream(String chatId) {
    CollectionReference messagesCollection =
        firestore.collection('chats').doc(chatId).collection('messages');
    return messagesCollection
        .orderBy('date', descending: true)
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (QueryDocumentSnapshot document in event.docs) {
        Timestamp timestamp = document.get('date');
        messages.add(Message(
          id: document.id,
          senderId: document.get('senderId'),
          content: document.get('content'),
          date: timestamp.toDate(),
        ));
      }
      return messages;
    });
  }

  Future sendMessage(String chatId, Message message) async {
    CollectionReference messagesCollection =
        firestore.collection('chats').doc(chatId).collection('messages');
    try {
      await messagesCollection.add({
        'senderId': message.senderId,
        'content': message.content,
        'date': message.date,
      });
      return null;
    } on FirebaseException catch (e) {
      return e.message;
    }
  }
}
