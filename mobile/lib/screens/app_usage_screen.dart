import 'dart:convert';

import 'package:app_usage/app_usage.dart';
import 'package:aware_me/screens/custom_usage_screen.dart';
import 'package:aware_me/screens/usage_stats_screen.dart';
import 'package:aware_me/screens/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AppUsageScreen extends StatefulWidget {
  const AppUsageScreen({super.key});

  @override
  State<AppUsageScreen> createState() => _AppUsageScreenState();
}

class _AppUsageScreenState extends State<AppUsageScreen> {
  List<AppUsageInfo> _infos = [];
  var logger = Logger();
  var selectedPage = '';

  Future<String> getOrCreateUserId() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("userId");
    if (userId == null) {
      setState(() {
        userId = Uuid().v4();
      });
      prefs.setString("userId", userId!);
    }
    logger.w(userId);
    return userId!;
  }

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
      //  var eventLog = await AppUsage().getAppEvents(startOfDay, now);
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
    var baseUrl = "https://5c846bafe285.ngrok-free.app";
    bool test = false;
    try {
      if (test) {
        var testUrl = "$baseUrl/test?name=${_infos[0].appName}";
        var testRepsonse = await http.post(Uri.parse(testUrl));
        logger.i(jsonDecode(testRepsonse.body));
      } else {
        var url = "$baseUrl/app_usage_data";

        String userId = await getOrCreateUserId();

        final List<Map<String, dynamic>> appUsageInfoList = _infos
            .map(
              (info) => {
                "userId": userId.toString(),
                "packageName": info.packageName,
                "appName": info.appName,
                "usage": info.usage.inSeconds,
                "startDate": info.startDate.toIso8601String(),
                "endDate": info.endDate.toIso8601String(),
                "lastForegroundDate": info.lastForeground.toIso8601String(),
              },
            )
            .toList();

        var response = await http.post(
          Uri.parse(url),
          headers: {"Content-Type": "application/json; charset=UTF-8"},
          body: jsonEncode(appUsageInfoList),
        );
        logger.i(jsonDecode(response.body));
      }
    } catch (exception) {
      logger.e(exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(screenTitle: "App Usage"),
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
      /*  body: ListView.builder(
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
      ),*/
    );
  }
}
