import 'package:aware_me/constants/constants.dart';
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
      backgroundColor: CustomColors.bgColor,
      child: ListView(
        children: [
          DrawerHeader(
            child: Image(image: AssetImage("img/logo_aware_me_face.png")),
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
                ? CustomColors.selectedColor
                : CustomColors.bgColor,
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
                ? CustomColors.selectedColor
                : CustomColors.bgColor,
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => EventInfosScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.people, color: Colors.white),
            title: Text(
              "Custom Usage Screen",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            enabled: !(widget.screenName == CUSTOM_USAGE),
            tileColor: widget.screenName == CUSTOM_USAGE
                ? CustomColors.selectedColor
                : CustomColors.bgColor,
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => CustomUsageScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.network_cell, color: Colors.white),
            title: Text(
              "Network Usage Screen",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            enabled: !(widget.screenName == NETWORK_USAGE),
            tileColor: widget.screenName == NETWORK_USAGE
                ? CustomColors.selectedColor
                : CustomColors.bgColor,
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
