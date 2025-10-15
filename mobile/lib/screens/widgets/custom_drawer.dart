import 'package:aware_me/screens/app_usage_screen.dart';
import 'package:aware_me/screens/custom_usage_screen.dart';
import 'package:aware_me/screens/event_infos_screen.dart';
import 'package:aware_me/screens/network_usage_screen.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key, required this.screenName});
  final String screenName;

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  // ignore: constant_identifier_names
  static const String APP_USAGE = "App Usage";
  // ignore: constant_identifier_names
  static const String CUSTOM_USAGE = "Custom Usage";
  // ignore: constant_identifier_names
  static const String EVENT_INFO = "Event Info";
  // ignore: constant_identifier_names
  static const String NETWORK_USAGE = "Network Usage";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.deepPurple,
      child: ListView(
        children: [
          DrawerHeader(
            child: Text(
              "Header",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.data_usage_rounded, color: Colors.white),
            title: Text(
              "App Usage Screen",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            enabled: !(widget.screenName == APP_USAGE),
            tileColor: widget.screenName == APP_USAGE
                ? Colors.deepPurple[400]
                : Colors.deepPurple,
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => AppUsageScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.event, color: Colors.white),
            title: Text(
              "Event Infos Screen",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            enabled: !(widget.screenName == EVENT_INFO),
            tileColor: widget.screenName == EVENT_INFO
                ? Colors.deepPurple[400]
                : Colors.deepPurple,
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => EventInfosScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.event, color: Colors.white),
            title: Text(
              "Custom Usage Screen",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            enabled: !(widget.screenName == CUSTOM_USAGE),
            tileColor: widget.screenName == CUSTOM_USAGE
                ? Colors.deepPurple[400]
                : Colors.deepPurple,
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => CustomUsageScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.event, color: Colors.white),
            title: Text(
              "Network Usage Screen",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            enabled: !(widget.screenName == NETWORK_USAGE),
            tileColor: widget.screenName == NETWORK_USAGE
                ? Colors.deepPurple[400]
                : Colors.deepPurple,
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => NetworkUsageScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
