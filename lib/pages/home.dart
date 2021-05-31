import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hoot/assets/colors.dart';
import 'package:hoot/assets/constants.dart';
import 'package:hoot/assets/styles.dart';
import 'package:hoot/models/hoot_user.dart';
import 'package:hoot/services/auth.dart';
import 'package:hoot/views/destination.dart';
import 'package:hoot/views/loading_dialog.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _auth = AuthService.getInstance();
  HootUser _user;
  int _navigationIndex = 0;

  final List<Destination> destinations = [
    Destination(title: Destination.chats, iconData: Icons.chat),
    Destination(title: Destination.friends, iconData: Icons.people),
    Destination(title: Destination.profile, iconData: Icons.person),
  ];

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments;
    _user = args['user'];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light
          .copyWith(systemNavigationBarColor: primaryColorDark),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Hoot'),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {},
              tooltip: 'Search',
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {},
              tooltip: 'Settings',
            ),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () => _onSignOutPressed(),
              tooltip: 'Logout',
            ),
          ],
        ),
        body: IndexedStack(
          children: destinations.map((d) {
            bool active = _navigationIndex == destinations.indexOf(d);
            return DestinationView(destination: d, active: active);
          }).toList(),
          index: _navigationIndex,
        ),
        bottomNavigationBar: Material(
          elevation: 0,
          child: Container(
            child: Row(
              children: destinations.map((d) {
                Color color = d == destinations[_navigationIndex]
                    ? secondaryColor
                    : foregroundColor;
                return Expanded(
                  child: InkResponse(
                    onTap: () {
                      int index = destinations.indexOf(d);
                      setState(() => _navigationIndex = index);
                    },
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: smallPadding),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(d.iconData, color: color),
                            SizedBox(height: 4),
                            Text(d.title, style: TextStyle(color: color)),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  void _onSignOutPressed() async {
    showDialog(
      context: context,
      builder: (context) => LoadingDialog(),
    );
    String errorMsg = await _auth.signOut();
    Navigator.pop(context);
    if (errorMsg == null) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(buildErrorSnackBar(errorMsg, context));
    }
  }
}
