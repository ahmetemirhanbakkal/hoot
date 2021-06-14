import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hoot/assets/colors.dart';
import 'package:hoot/models/hoot_user.dart';
import 'package:hoot/services/auth.dart';
import 'package:hoot/services/firestore.dart';
import 'package:intl/date_symbol_data_local.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  final AuthService _auth = AuthService.getInstance();
  final FirestoreService _firestore = FirestoreService.getInstance();

  @override
  void initState() {
    super.initState();
    redirect();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light
          .copyWith(systemNavigationBarColor: primaryColor),
      child: Scaffold(
        body: Center(
          child: SpinKitCubeGrid(
            color: secondaryColor,
          ),
        ),
      ),
    );
  }

  void redirect() async {
    initializeDateFormatting();
    HootUser user = _auth.getUser();
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.pushReplacementNamed(context, '/login');
      });
    } else {
      dynamic result = await _firestore.getUserDetails(user);
      if (result == null) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Map args = {'user': user};
          Navigator.pushReplacementNamed(context, '/home', arguments: args);
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.pushReplacementNamed(context, '/login');
        });
      }
    }
  }
}
