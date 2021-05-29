import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hoot/assets/colors.dart';
import 'package:hoot/assets/constants.dart';
import 'package:hoot/models/hoot_user.dart';
import 'package:hoot/pages/login.dart';
import 'package:hoot/views/destination.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HootUser _user;
  int _navigationIndex = 0;

  final List<Destination> destinations = [
    Destination(title: Destination.chats, iconData: Icons.chat),
    Destination(title: Destination.friends, iconData: Icons.people),
    Destination(title: Destination.profile, iconData: Icons.person),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: primaryColorDark,
    ));

    final Map args = ModalRoute.of(context).settings.arguments;
    _user = args['user'];
    return Scaffold(
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
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
            tooltip: 'Logout',
          ),
          /*
          PopupMenuButton(
            offset: Offset(0, -32),
            padding: EdgeInsets.zero,
            itemBuilder: (context) {
              return {
                'Settings',
                'Logout',
              }.map((choice) {
                return PopupMenuItem(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
          */
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
    );
  }
}
