import 'package:flutter/material.dart';
import 'package:hoot/assets/colors.dart';
import 'package:hoot/assets/constants.dart';
import 'package:hoot/models/hoot_user.dart';
import 'package:hoot/services/firestore.dart';

class UserCardView extends StatefulWidget {
  final HootUser loggedUser;
  final HootUser user;

  UserCardView({this.loggedUser, this.user});

  @override
  _UserCardViewState createState() => _UserCardViewState();
}

class _UserCardViewState extends State<UserCardView> {
  final FirestoreService _firestore = FirestoreService.getInstance();
  bool _loading = false;
  bool _alreadyFriend = false;

  @override
  Widget build(BuildContext context) {
    _alreadyFriend = widget.loggedUser.friendIds.contains(widget.user.id);
    RoundedRectangleBorder roundedRectangleBorder = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(largeRadius),
    );
    return Card(
      shape: roundedRectangleBorder,
      child: Container(
        height: 64,
        child: InkWell(
          customBorder: roundedRectangleBorder,
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.all(smallPadding),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: smallPadding),
                    child: Text(
                      widget.user.username,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                ),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: fastAnimDuration),
                  child: _loading
                      ? CircularProgressIndicator()
                      : IconButton(
                          icon: Icon(
                            _alreadyFriend
                                ? Icons.person_remove
                                : Icons.person_add,
                            color: secondaryColor,
                          ),
                          onPressed: () => _addOrRemoveFriend(),
                          tooltip: 'Add friend',
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
      color: primaryColorLight,
    );
  }

  void _addOrRemoveFriend() async {
    setState(() => _loading = true);
    dynamic error = await _firestore.addOrRemoveFriend(
      widget.loggedUser.id,
      widget.user.id,
      _alreadyFriend,
    );
    if (error == null) {
      _alreadyFriend
          ? widget.loggedUser.friendIds.remove(widget.user.id)
          : widget.loggedUser.friendIds.add(widget.user.id);
      _alreadyFriend = !_alreadyFriend;
    }
    setState(() => _loading = false);
  }
}
