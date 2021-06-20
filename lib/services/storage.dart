import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static StorageService _instance;

  static StorageService getInstance() {
    if (_instance == null) _instance = StorageService();
    return _instance;
  }

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future uploadProfileImage(String userId, File image) async {
    Reference reference = _storage.ref('profiles/$userId');

    try {
      await reference.putFile(image);
      return null;
    } on FirebaseException catch (e) {
      return e.message;
    }
  }

  Future getProfileImageUrl(String userId) async {
    if (userId == null) return null;
    Reference reference = _storage.ref('profiles/$userId');

    try {
      return await reference.getDownloadURL();
    } on FirebaseException catch (e) {
      print(e.message);
      return null;
    }
  }
}
