import 'package:cloud_firestore/cloud_firestore.dart';

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
}
