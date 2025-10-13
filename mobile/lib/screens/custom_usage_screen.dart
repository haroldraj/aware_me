import 'package:aware_me/screens/app_usage_screen.dart';
import 'package:aware_me/screens/usage_stats_screen.dart';
import 'package:aware_me/screens/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class CustomUsageScreen extends StatefulWidget {
  const CustomUsageScreen({super.key});

  @override
  State<CustomUsageScreen> createState() => _CustomUsageScreenState();
}

class _CustomUsageScreenState extends State<CustomUsageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(screenTitle: "Custom Usage"),
      drawer: Drawer(
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
                  MaterialPageRoute(
                    builder: (context) => const AppUsageScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                "Usage Stats Screen",
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
            ListTile(
              title: Text(
                "Custom Usage Screen",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const CustomUsageScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}