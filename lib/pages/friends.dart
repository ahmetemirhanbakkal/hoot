import 'package:flutter/material.dart';
import 'package:hoot/assets/styles.dart';
import 'package:hoot/models/hoot_user.dart';
import 'package:hoot/services/firestore.dart';
import 'package:hoot/views/user_list.dart';

class FriendsPage extends StatefulWidget {
  final HootUser loggedUser;

  FriendsPage({this.loggedUser});

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final FirestoreService _firestore = FirestoreService.getInstance();

  void _getFriends() async {
    dynamic error = await _firestore.getFriends(widget.loggedUser);
    if (error == null)
      setState(() {});
    else
      buildErrorSnackBar(error, context);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.loggedUser.friends == null) _getFriends();

    return UserListView(
      loggedUser: widget.loggedUser,
      users: widget.loggedUser?.friends ?? [],
    );
  }
}
