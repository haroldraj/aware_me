import 'dart:convert';

import 'package:aware_me/constants/constants.dart';
import 'package:aware_me/screens/widgets/custom_alert_dialog.dart';
import 'package:aware_me/screens/widgets/custom_drawer.dart';
import 'package:aware_me/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  final String apiKey = dotenv.env["API_KEY"]!;

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
      List<UsageInfo> normalizedUsage = queryUsage.reversed
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
      if (_customUsageCount > 0) {
        CustomAlertDialog.showResponseDialog(
          // ignore: use_build_context_synchronously
          context,
          title: "⏳ Sending data",
          message: "",
          isSendingData: true,
        );
        var response = await http.post(
          Uri.parse(url),
          headers: {
            "Content-Type": "application/json; charset=UTF-8",
            "api-key": apiKey,
          },
          body: jsonEncode(customUsageRequest),
        );
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          CustomAlertDialog.showResponseDialog(
            // ignore: use_build_context_synchronously
            context,
            title: "✅ Success",
            message:
                "${data['new_inserted']} new records inserted.\n${data['duplicates_skipped']} existing records skipped.",
          );
        } else {
          CustomAlertDialog.showResponseDialog(
            // ignore: use_build_context_synchronously
            context,
            title: "❌ Error",
            message:
                "Server responded with status code ${response.statusCode}.",
          );
        }
        _logger.i(jsonDecode(response.body));
      } else {
        CustomAlertDialog.showResponseDialog(
          // ignore: use_build_context_synchronously
          context,
          title: "❌ Error",
          message: "No data to send.",
        );
      }
    } catch (exception) {
      _logger.e(exception);
      CustomAlertDialog.showResponseDialog(
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
                "Custom",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Flexible(
              child: Text(
                "Count: $_customUsageCount",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: CustomColors.bgColor,
        foregroundColor: Colors.white,
      ),
      drawer: CustomDrawer(screenName: "Custom Usage"),
      body: RefreshIndicator(
        onRefresh: initUsage,
        child: Scrollbar(
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
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Send data to DB",
        backgroundColor: CustomColors.bgColor,
        onPressed: () => sendToAPI(context),
        child: Icon(Icons.send, color: Colors.white),
      ),
    );
  }
}
