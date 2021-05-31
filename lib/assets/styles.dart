import 'package:flutter/material.dart';
import 'package:hoot/assets/colors.dart';
import 'package:hoot/assets/constants.dart';

final ButtonStyle defaultButtonStyle = ButtonStyle(
  padding: MaterialStateProperty.all(EdgeInsets.all(largePadding)),
  backgroundColor: MaterialStateProperty.all(secondaryColor),
  overlayColor: MaterialStateProperty.all(lightSplashColor),
  foregroundColor: MaterialStateProperty.all(primaryColorDark),
  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
);

final ButtonStyle textButtonStyle = ButtonStyle(
  overlayColor: MaterialStateProperty.all(splashColor),
  foregroundColor: MaterialStateProperty.all(secondaryColor),
  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(smallRadius),
    ),
  ),
);

SnackBar buildErrorSnackBar(String message, BuildContext context) {
  return SnackBar(
    backgroundColor: errorColor,
    content: Text(
      message,
      style: TextStyle(color: foregroundColor),
    ),
    action: SnackBarAction(
      textColor: foregroundColor,
      label: 'Dismiss',
      onPressed: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
    ),
  );
}
