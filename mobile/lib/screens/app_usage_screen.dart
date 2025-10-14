import 'dart:convert';

import 'package:app_usage/app_usage.dart';
import 'package:aware_me/constants/constants.dart';
import 'package:aware_me/screens/widgets/custom_drawer.dart';
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
  int _infosCount = 0;

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
    getUsageStats();
  }

  Future<void> getUsageStats() async {
    try {
      DateTime now = DateTime.now();
      DateTime startOfDay = DateTime(now.year, now.month, now.day, 0, 1);
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
      //logger.i(normalized);
      setState(() {
        _infos = normalized;
        _infosCount = _infos.length;
      });
    } catch (exception) {
      logger.e(exception);
    }
  }

  Future<void> sendToAPI() async {
    try {
      var url = "${Url.base}/app_usage";

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
    } catch (exception) {
      logger.e(exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "App Usage",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "Count: $_infosCount apps",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      drawer: CustomDrawer(),
      body: RefreshIndicator(
        onRefresh: getUsageStats,
        child: ListView.separated(
          itemCount: _infosCount,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_infos[index].packageName),
              subtitle: Text(_infos[index].appName),
              trailing: Text(_infos[index].usage.toString()),
            );
          },
          separatorBuilder: (context, index) => Divider(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => sendToAPI(),
        child: Icon(Icons.send),
      ),
    );
  }
}
