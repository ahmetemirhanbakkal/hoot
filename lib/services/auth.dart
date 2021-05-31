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
    return user == null ? null : HootUser(id: user.uid, email: user.email);
  }

  Future signIn(
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
      return e.message;
    }
  }

  Future signUp(
    String email,
    String password,
  ) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _toHootUser(credential.user);
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future signOut() async {
    try {
      await auth.signOut();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  HootUser getUser() {
    User user = auth.currentUser;
    return user == null ? null : _toHootUser(user);
  }
}
