import 'dart:convert';

import 'package:aware_me/constants/constants.dart';
import 'package:aware_me/screens/widgets/custom_drawer.dart';
import 'package:aware_me/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:usage_stats/usage_stats.dart';

class CustomUsageScreen extends StatefulWidget {
  const CustomUsageScreen({super.key});

  @override
  State<CustomUsageScreen> createState() => _CustomUsageScreenState();
}

class _CustomUsageScreenState extends State<CustomUsageScreen> {
  final Logger _logger = Logger();
  List<UsageInfo> customUsage = [];
  int _customUsageCount = 0;

  @override
  void initState() {
    super.initState();
    initUsage();
  }

  Future<void> initUsage() async {
    try {
      DateTime now = DateTime.now();
      DateTime startDate = DateTime(now.year, now.month, now.day, 0, 1);

      List<UsageInfo> queryUsage = await UsageStats.queryUsageStats(
        startDate,
        now,
      );
      List<UsageInfo> normalizedUsage = queryUsage
          .where((usage) => int.parse(usage.totalTimeInForeground ?? "0") > 0)
          .map((usage) {
            return UsageInfo(
              packageName: usage.packageName,
              firstTimeStamp: DateTime.fromMillisecondsSinceEpoch(
                int.parse(usage.firstTimeStamp!),
              ).toIso8601String(),
              lastTimeStamp: DateTime.fromMillisecondsSinceEpoch(
                int.parse(usage.lastTimeStamp!),
              ).toIso8601String(),
              lastTimeUsed: DateTime.fromMillisecondsSinceEpoch(
                int.parse(usage.lastTimeUsed!),
              ).toIso8601String(),
              totalTimeInForeground: usage.totalTimeInForeground,
            );
          })
          .toList();
      setState(() {
        customUsage = normalizedUsage;
        _customUsageCount = normalizedUsage.length;
      });
    } catch (err) {
      _logger.e(err);
    }
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

  Future<void> sendToAPI(BuildContext context) async {
    try {
      var url = "${Url.base}/custom_usage";
      String userId = await UserService().getUserId();

      final List<Map<String, dynamic>> customUsageRequest = customUsage
          .map(
            (usage) => {
              "userId": userId,
              "packageName": usage.packageName,
              "firstTimeStamp": usage.firstTimeStamp,
              "lastTimeUsed": usage.lastTimeUsed,
              "lastTimeStamp": usage.lastTimeStamp,
              "totalTimeInForeground": usage.totalTimeInForeground,
            },
          )
          .toList();

      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: jsonEncode(customUsageRequest),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _showResponseDialog(
          // ignore: use_build_context_synchronously
          context,
          title: "Data Sent",
          message:
              "${data['message']}\n${data['duplicates_skipped']} existing records skipped.",
        );
      } else {
        _showResponseDialog(
          // ignore: use_build_context_synchronously
          context,
          title: "Error",
          message: "Server responded with status code ${response.statusCode}.",
        );
      }
      _logger.i(jsonDecode(response.body));
    } catch (exception) {
      _logger.e(exception);
      _showResponseDialog(
        // ignore: use_build_context_synchronously
        context,
        title: "Exception",
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
            Text("Custom", style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(
              "Count: $_customUsageCount usages",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      drawer: CustomDrawer(screenName: "Custom Usage"),
      body: RefreshIndicator(
        onRefresh: initUsage,
        child: ListView.separated(
          separatorBuilder: (context, index) => Divider(),
          itemCount: _customUsageCount,
          itemBuilder: (context, index) {
            return _customUsageCount != 0
                ? ListTile(
                    title: Text(customUsage[index].packageName!),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "FirstTimeStamp: ${customUsage[index].firstTimeStamp}",
                        ),
                        Text(
                          "LastTimeStamp: ${customUsage[index].lastTimeStamp}",
                        ),
                        Text(
                          "TotalTimeInForeground: ${customUsage[index].totalTimeInForeground}",
                        ),
                        Text(
                          "LastTimeUsed: ${customUsage[index].lastTimeUsed}",
                        ),
                      ],
                    ),
                  )
                : Center(child: Text("No data yet."));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => sendToAPI(context),
        child: Icon(Icons.send),
      ),
    );
  }
}
