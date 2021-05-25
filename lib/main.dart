import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hoot/assets/colors.dart';
import 'package:hoot/pages/loading.dart';
import 'package:hoot/pages/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hoot',
      routes: {
        '/': (context) => LoadingPage(),
        '/login': (context) => LoginPage(),
      },
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: primaryColor,
        scaffoldBackgroundColor: primaryColor,
        textTheme: TextTheme(
          bodyText2: TextStyle(color: foregroundColor),
        ),
      ),
    );
  }
}
