import 'package:flutter/material.dart';
import 'package:hoot/assets/globals.dart';

class Destination {
  static const String chats = 'Chats';
  static const String friends = 'Friends';
  static const String profile = 'Profile';

  const Destination({this.title, this.iconData});
  final String title;
  final IconData iconData;
}

class DestinationView extends StatefulWidget {
  final Destination destination;
  final bool active;

  DestinationView({
    Key key,
    @required this.destination,
    @required this.active,
  }) : super(key: key);

  @override
  _DestinationViewState createState() => _DestinationViewState();
}

class _DestinationViewState extends State<DestinationView> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            switch (settings.name) {
              case '/':
                if (widget.active) navigatorContext = context;
                return buildChatsPage();
              default:
                return null;
            }
          },
        );
      },
    );
  }

  Widget buildChatsPage() {
    switch (widget.destination.title) {
      case Destination.chats:
      default:
        return Center(child: Text(widget.destination.title));
    }
  }
}
