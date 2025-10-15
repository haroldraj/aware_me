import 'dart:convert';

import 'package:app_usage/app_usage.dart';
import 'package:aware_me/constants/constants.dart';
import 'package:aware_me/screens/widgets/custom_drawer.dart';
import 'package:aware_me/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

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

  @override
  void initState() {
    super.initState();
    getUsageStats();
  }

  void _showResponseDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(message),

          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
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

  Future<void> sendToAPI(BuildContext context) async {
    try {
      var url = "${Url.base}/app_usage";
      String userId = await UserService().getUserId();
      final List<Map<String, dynamic>> appUsageInfoList = _infos
          .map(
            (info) => {
              "userId": userId,
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
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _showResponseDialog(
          // ignore: use_build_context_synchronously
          context,
          title: "Data Sent",
          message:
              "${data['new_inserted']} new records inserted.\n${data['duplicates_skipped']} existing records skipped.",
        );
      } else {
        _showResponseDialog(
          // ignore: use_build_context_synchronously
          context,
          title: "Error",
          message: "Server responded with status code ${response.statusCode}.",
        );
      }
      logger.i(jsonDecode(response.body));
    } catch (exception) {
      logger.e(exception);
      _showResponseDialog(
        // ignore: use_build_context_synchronously
        context,
        title: "⚠️ Exception",
        message: exception.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                "App",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Flexible(
              child: Text(
                "Count: $_infosCount apps",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: CustomColors.bgColor,
        foregroundColor: Colors.white,
      ),
      drawer: CustomDrawer(screenName: "App Usage"),
      body: RefreshIndicator(
        onRefresh: getUsageStats,
        child: ListView.separated(
          itemCount: _infosCount,
          itemBuilder: (context, index) {
            return _infosCount != 0
                ? ListTile(
                    title: Text(_infos[index].packageName),
                    subtitle: Text(_infos[index].appName),
                    trailing: Text(_infos[index].usage.toString()),
                  )
                : Center(child: Text("No data yet."));
          },
          separatorBuilder: (context, index) => Divider(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => sendToAPI(context),
        child: Icon(Icons.send),
      ),
    );
  }
}
