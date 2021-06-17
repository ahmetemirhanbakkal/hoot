import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hoot/assets/colors.dart';
import 'package:hoot/assets/constants.dart';
import 'package:hoot/assets/styles.dart';
import 'package:hoot/models/hoot_user.dart';
import 'package:hoot/services/storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  final HootUser loggedUser;

  ProfilePage({this.loggedUser});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File _profileImage;
  final ImagePicker _picker = ImagePicker();
  final StorageService _storage = StorageService.getInstance();
  bool _imageLoading = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(hugePadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipOval(
              child: Container(
                width: 200,
                height: 200,
                color: primaryColorDark,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_profileImage != null)
                      Image.file(
                        _profileImage,
                        fit: BoxFit.fill,
                      ),
                    if (_imageLoading) CircularProgressIndicator(),
                  ],
                ),
              ),
            ),
            SizedBox(height: hugePadding),
            TextButton(
              onPressed: () => _updateProfileImage(),
              child: Text('Update Image'),
              style: defaultButtonStyle,
            ),
            SizedBox(height: hugePadding),
            Row(
              children: [
                Icon(Icons.person, color: secondaryColor),
                SizedBox(width: largePadding),
                Text(
                  widget.loggedUser.username,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: hugePadding),
            Row(
              children: [
                Icon(Icons.email, color: secondaryColor),
                SizedBox(width: largePadding),
                Text(
                  widget.loggedUser.email,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updateProfileImage() async {
    PickedFile pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File image = File(pickedFile.path);
      image = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [CropAspectRatioPreset.square],
      );
      setState(() => _imageLoading = true);
      String error =
          await _storage.uploadProfileImage(widget.loggedUser.id, image);
      if (error == null) {
        _profileImage = image;
      } else {
        showErrorSnackBar(error, context);
      }
      setState(() => _imageLoading = false);
    }
  }
}
