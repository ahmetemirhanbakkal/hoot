import 'package:flutter/material.dart';
import 'package:hoot/assets/colors.dart';

class ProfileImageView extends StatelessWidget {
  final String imageUrl;
  final double imageSize;

  ProfileImageView({@required this.imageUrl, @required this.imageSize});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        height: imageSize,
        width: imageSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.account_circle,
              color: secondaryColor,
              size: imageSize,
            ),
            if (imageUrl != null)
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                height: imageSize,
                width: imageSize,
              ),
          ],
        ),
      ),
    );
  }
}
