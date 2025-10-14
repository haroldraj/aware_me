import 'package:aware_me/screens/app_usage_screen.dart';
import 'package:flutter/material.dart';
import 'package:usage_stats/usage_stats.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    grantUsagePermission();
  }

  Future<void> grantUsagePermission() async {
    UsageStats.grantUsagePermission();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      ),
      home: AppUsageScreen(),
    );
  }
}
