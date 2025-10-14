import 'package:aware_me/screens/app_usage_screen.dart';
import 'package:aware_me/screens/event_infos_screen.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key, required this.screenName});
  final String screenName;

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  // ignore: constant_identifier_names
  static const String APPUSAGE = "App Usage";

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
            enabled: widget.screenName != APPUSAGE,
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
            enabled: widget.screenName == APPUSAGE,
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => EventInfosScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
