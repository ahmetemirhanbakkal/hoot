import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hoot/assets/colors.dart';
import 'package:hoot/assets/styles.dart';
import 'package:hoot/pages/home.dart';
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
      debugShowCheckedModeBanner: false,
      title: 'Hoot',
      routes: {
        '/': (context) => LoadingPage(),
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
      },
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: primaryColor,
        accentColor: secondaryColor,
        splashColor: splashColor,
        scaffoldBackgroundColor: primaryColor,
        canvasColor: primaryColorDark,
        errorColor: errorColor,
        popupMenuTheme: PopupMenuThemeData(
          color: primaryColorDark,
        ),
        appBarTheme: AppBarTheme(
          color: primaryColorDark,
          elevation: 0,
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: secondaryColor,
        ),
        textTheme: TextTheme(
          bodyText2: TextStyle(color: foregroundColor),
          headline6: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          headline5: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          headline4: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: foregroundColor,
          ),
        ),
        textButtonTheme: TextButtonThemeData(style: textButtonStyle),
        splashFactory: InkRipple.splashFactory,
        highlightColor: Colors.transparent,
      ),
    );
  }
}
