import 'package:aware_me/constants/helpers.dart';
import 'package:aware_me/screens/app_usage_screen.dart';
import 'package:aware_me/screens/busage_stats_screen.dart';
import 'package:aware_me/screens/custom_usage_screen.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.deepPurple,
      child: ListView(
        children: [
          const DrawerHeader(child: Text("Methods")),
          drawerListTile("App Usage", Icons.add, context, AppUsageScreen()),
          drawerListTile(
            "Custom Usage",
            Icons.remove,
            context,
            CustomUsageScreen(),
          ),
          drawerListTile(
            "Usage stats",
            Icons.delete,
            context,
            UsageStatsScreens(),
          ),
        ],
      ),
    );
  }

  ListTile drawerListTile(
    String title,
    IconData leadingIcon,
    BuildContext context,
    Widget screenDestination,
  ) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      leading: Icon(leadingIcon, color: Colors.white),
      onTap: () {
        Navigator.pop(context);
        Helpers.goTo(context, screenDestination);
      },
    );
  }
}
