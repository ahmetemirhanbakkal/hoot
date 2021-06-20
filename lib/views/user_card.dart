import 'package:flutter/material.dart';
import 'package:hoot/assets/colors.dart';
import 'package:hoot/assets/constants.dart';
import 'package:hoot/assets/globals.dart';
import 'package:hoot/models/hoot_user.dart';
import 'package:hoot/services/firestore.dart';
import 'package:hoot/views/profile_image.dart';

class UserCardView extends StatefulWidget {
  final HootUser loggedUser;
  final HootUser targetUser;

  UserCardView({this.loggedUser, this.targetUser});

  @override
  _UserCardViewState createState() => _UserCardViewState();
}

class _UserCardViewState extends State<UserCardView> {
  final FirestoreService _firestore = FirestoreService.getInstance();
  bool _loading = false;
  bool _alreadyFriend = false;

  @override
  Widget build(BuildContext context) {
    _alreadyFriend = widget.loggedUser.friendIds.contains(widget.targetUser.id);

    return Container(
      child: InkWell(
        onTap: () {
          Map args = {
            'logged_user': widget.loggedUser,
            'target_user': widget.targetUser,
          };
          Navigator.pushNamed(homeContext, '/chat', arguments: args);
        },
        child: Row(
          children: [
            SizedBox(width: smallPadding),
            ProfileImageView(
              imageUrl: widget.targetUser.profileImage,
              imageSize: 52,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(largePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.targetUser.username,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(height: 4),
                    Text(widget.targetUser.email),
                  ],
                ),
              ),
            ),
            Container(
              height: 56,
              width: 56,
              child: AnimatedSwitcher(
                duration: fastAnimDuration,
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
                        tooltip:
                            _alreadyFriend ? 'Remove friend' : 'Add friend',
                      ),
              ),
            ),
            SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  void _addOrRemoveFriend() async {
    setState(() => _loading = true);
    dynamic error = await _firestore.addOrRemoveFriend(
      widget.loggedUser.id,
      widget.targetUser.id,
      _alreadyFriend,
    );
    if (error == null) {
      if (_alreadyFriend) {
        widget.loggedUser.friendIds.remove(widget.targetUser.id);
      } else {
        widget.loggedUser.friendIds.add(widget.targetUser.id);
        if ((widget.loggedUser.friends.singleWhere(
                (item) => item.id == widget.targetUser.id,
                orElse: () => null)) ==
            null) {
          widget.loggedUser.friends.add(widget.targetUser);
        }
      }
      _alreadyFriend = !_alreadyFriend;
    }
    setState(() => _loading = false);
  }
}
