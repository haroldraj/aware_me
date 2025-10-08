/*
import 'package:flutter/material.dart';
import 'screens/usage_stats_screen.dart';

void main() {
  runApp(const AppUsageTrackerApp());
}

class AppUsageTrackerApp extends StatelessWidget {
  const AppUsageTrackerApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Usage Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      ),
      home: const UsageStatsScreen(),
    );
  }
}
*/
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:app_usage/app_usage.dart';
import 'package:installed_apps/app_info.dart';
import 'package:logger/logger.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:http/http.dart' as http;

void main() => runApp(AppUsageApp());

class AppUsageApp extends StatefulWidget {
  const AppUsageApp({super.key});

  @override
  AppUsageAppState createState() => AppUsageAppState();
}

class AppUsageAppState extends State<AppUsageApp> {
  List<AppUsageInfo> _infos = [];
  var logger = Logger();

  @override
  void initState() {
    super.initState();
  }

  void getUsageStats() async {
    try {
      DateTime now = DateTime.now();
      DateTime startOfDay = DateTime(now.year, now.month, now.day, 5, 1);
      List<AppUsageInfo> infoList = await AppUsage().getAppUsage(
        startOfDay,
        now,
      );
      List<AppUsageInfo> normalized = infoList.map((info) {
        return AppUsageInfo(
          info.packageName,
          info.usage.inSeconds.toDouble(),
          startOfDay,
          info.endDate,
          info.lastForeground,
        );
      }).toList();
      logger.i(normalized);
      setState(() => _infos = normalized);
    } catch (exception) {
      logger.e(exception);
    }
  }

  Future<void> sendToAPI() async {
    var url = "https://b9304ae91e3f.ngrok-free.app/appusagedata?name=Flutter";

    try {
      var repsonse = await http.post(Uri.parse(url));
      logger.i(jsonDecode(repsonse.body));
    } catch (exception) {
      logger.e(exception);
    }
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
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'App Usage Data',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        body: ListView.builder(
          itemCount: _infos.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_infos[index].appName),

              trailing: Text(_infos[index].usage.toString()),
            );
          },
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          spacing: 15,
          children: [
            FloatingActionButton(
              onPressed: getUsageStats,
              child: Icon(Icons.file_download),
            ),
            FloatingActionButton(
              onPressed: () => sendToAPI(),
              child: Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
