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
    CollectionReference users = firestore.collection('users');
    try {
      await users.doc(id).set({
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
    CollectionReference users = firestore.collection('users');
    try {
      DocumentSnapshot document = await users.doc(user.id).get();
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
    CollectionReference users = firestore.collection('users');
    try {
      await users.doc(userId).update({
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

  Future createChat(Chat chat) async {
    CollectionReference chats = firestore.collection('chats');
    try {
      await chats.add({
        'userIds': chat.userIds,
        'usernames': chat.usernames,
        'lastMessage': chat.lastMessage,
        'lastMessageDate': chat.lastMessageDate,
      });
      return null;
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  Stream<List<Chat>> getChatsStream(String userId) {
    CollectionReference chatsCollection = firestore.collection('chats');
    return chatsCollection
        .where('userIds', arrayContains: userId)
        .snapshots()
        .map((event) {
      List<Chat> chats = [];
      for (QueryDocumentSnapshot document in event.docs) {
        Timestamp lastMessageTimestamp = document.get('lastMessageDate');
        chats.add(Chat(
          userIds: document.get('userIds').cast<String>(),
          usernames: document.get('usernames').cast<String>(),
          lastMessage: document.get('lastMessage'),
          lastMessageDate: lastMessageTimestamp.toDate(),
        ));
      }
      return chats;
    });
  }

  Stream<List<Message>> getMessagesStream(String chatId) {
    CollectionReference messagesCollection =
        firestore.collection('chats').doc(chatId).collection('messages');
    return messagesCollection.snapshots().map((event) {
      List<Message> messages = [];
      for (QueryDocumentSnapshot document in event.docs) {
        Timestamp timestamp = document.get('date');
        messages.add(Message(
          senderId: document.get('senderId'),
          content: document.get('usernames').cast<String>(),
          date: timestamp.toDate(),
        ));
      }
      return messages;
    });
  }
}
