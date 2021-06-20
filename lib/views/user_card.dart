import 'package:flutter/material.dart';
import 'package:hoot/assets/colors.dart';
import 'package:hoot/assets/constants.dart';
import 'package:hoot/assets/globals.dart';
import 'package:hoot/models/hoot_user.dart';
import 'package:hoot/services/firestore.dart';
import 'package:hoot/services/storage.dart';
import 'package:hoot/views/profile_image.dart';

class UserCardView extends StatefulWidget {
  final HootUser loggedUser;
  final HootUser user;

  UserCardView({this.loggedUser, this.user});

  @override
  _UserCardViewState createState() => _UserCardViewState();
}

class _UserCardViewState extends State<UserCardView> {
  final StorageService _storage = StorageService.getInstance();
  final FirestoreService _firestore = FirestoreService.getInstance();
  bool _loading = false;
  bool _alreadyFriend = false;
  String _imageUrl;

  @override
  void initState() {
    super.initState();
    _getProfileImage();
  }

  @override
  Widget build(BuildContext context) {
    _alreadyFriend = widget.loggedUser.friendIds.contains(widget.user.id);
    return Container(
      child: InkWell(
        onTap: () {
          Map args = {
            'logged_user': widget.loggedUser,
            'target_user': widget.user,
          };
          Navigator.pushNamed(homeContext, '/chat', arguments: args);
        },
        child: Row(
          children: [
            SizedBox(width: smallPadding),
            ProfileImageView(imageUrl: _imageUrl, imageSize: 52),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(largePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.user.username,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(height: 4),
                    Text(widget.user.email),
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
      widget.user.id,
      _alreadyFriend,
    );
    if (error == null) {
      if (_alreadyFriend) {
        widget.loggedUser.friendIds.remove(widget.user.id);
      } else {
        widget.loggedUser.friendIds.add(widget.user.id);
        if ((widget.loggedUser.friends.singleWhere(
                (item) => item.id == widget.user.id,
                orElse: () => null)) ==
            null) {
          widget.loggedUser.friends.add(widget.user);
        }
      }
      _alreadyFriend = !_alreadyFriend;
    }
    setState(() => _loading = false);
  }

  void _getProfileImage() async {
    _imageUrl = await _storage.getProfileImageUrl(widget.user.id);
    setState(() {});
  }
}
