import 'package:aware_me/screens/app_usage_screen.dart';
import 'package:aware_me/screens/usage_stats_screen.dart';
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
          DrawerHeader(child: Text("Header")),
          ListTile(
            title: Text(
              "App Usage Screen",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const AppUsageScreen()),
              );
            },
          ),
          ListTile(
            title: Text(
              "Event Infos Screen",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const UsageStatsScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
