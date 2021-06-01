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
      });
      return null;
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  Future searchUsers(String query) async {
    List<HootUser> users = [];
    if (query.length < 3) return users;
    CollectionReference usersCollection = firestore.collection('users');
    try {
      QuerySnapshot querySnapshot = await usersCollection
          .where('username', isGreaterThanOrEqualTo: query)
          .where('username', isLessThanOrEqualTo: query + '\uf8ff')
          .get();
      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        users.add(HootUser(
          id: document.id,
          username: document.get('username'),
        ));
      }
      return users;
    } on FirebaseException catch (e) {
      return e.message;
    }
  }
}
