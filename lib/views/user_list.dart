import 'package:flutter/material.dart';
import 'package:hoot/models/hoot_user.dart';
import 'package:hoot/views/user_card.dart';

class UserListView extends StatefulWidget {
  final HootUser loggedUser;
  final List<HootUser> users;

  UserListView({this.loggedUser, this.users});

  @override
  _UserListViewState createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        HootUser user = widget.users[index];
        return UserCardView(loggedUser: widget.loggedUser, targetUser: user);
      },
      separatorBuilder: (context, index) => SizedBox(height: 4),
      itemCount: widget.users.length,
    );
  }
}
