import 'package:firebase_auth/firebase_auth.dart';
import 'package:hoot/models/hoot_user.dart';

class AuthService {
  static AuthService _instance;

  static AuthService getInstance() {
    if (_instance == null) _instance = AuthService();
    return _instance;
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  HootUser _toHootUser(User user) {
    return user == null ? null : HootUser(uid: user.uid, email: user.email);
  }

  Future<HootUser> signIn(
    String email,
    String password,
  ) async {
    try {
      UserCredential credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _toHootUser(credential.user);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          print('No user found for that email.');
          break;
        case 'wrong-password':
          print('Wrong password provided for that user.');
          break;
      }
    }
    return null;
  }

  Future<HootUser> signUp(
    String email,
    String username,
    String password,
  ) async {
    UserCredential credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _toHootUser(credential.user);
  }
}
