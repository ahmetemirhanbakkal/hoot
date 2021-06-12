import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hoot/models/hoot_user.dart';

class FirestoreService {
  static FirestoreService _instance;

  static FirestoreService getInstance() {
    if (_instance == null) _instance = FirestoreService();
    return _instance;
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> createUser(String id, String username) async {
    CollectionReference users = firestore.collection('users');
    try {
      await users.doc(id).set({
        'username': username,
        'friends': [],
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
      user.friendIds = document.get('friends').cast<String>();
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
          friendIds: document.get('friends').cast<String>(),
        ));
      }
      return users;
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  Future addOrRemoveFriend(
      String userId, String friendId, bool alreadyFriend) async {
    CollectionReference users = firestore.collection('users');
    try {
      await users.doc(userId).update({
        'friends': alreadyFriend
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
    CollectionReference usersCollection = firestore.collection('users');
    try {
      QuerySnapshot querySnapshot = await usersCollection
          .where(FieldPath.documentId, whereIn: loggedUser.friendIds)
          .get();
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        users.add(HootUser(
          id: document.id,
          username: document.get('username'),
          friendIds: document.get('friends').cast<String>(),
        ));
      }
      loggedUser.friends = users;
      return null;
    } on FirebaseException catch (e) {
      return e.message;
    }
  }
}
