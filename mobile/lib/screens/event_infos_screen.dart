import 'dart:convert';

import 'package:aware_me/constants/constants.dart';
import 'package:aware_me/screens/widgets/custom_drawer.dart';
import 'package:aware_me/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:usage_stats/usage_stats.dart';

class EventInfosScreen extends StatefulWidget {
  const EventInfosScreen({super.key});

  @override
  State<EventInfosScreen> createState() => _EventInfosScreenState();
}

class _EventInfosScreenState extends State<EventInfosScreen> {
  List<EventUsageInfo> events = [];
  Logger logger = Logger();
  int _eventsCount = 0;

  @override
  void initState() {
    super.initState();
    initUsage();
  }

  Future<void> initUsage() async {
    try {
      DateTime now = DateTime.now();
      DateTime startDate = DateTime(now.year, now.month, now.day, 0, 1);

      List<EventUsageInfo> queryEvents = await UsageStats.queryEvents(
        startDate,
        now,
      );
      List<EventUsageInfo> normalizedEvent = queryEvents.reversed.map((event) {
        return EventUsageInfo(
          eventType: event.eventType,
          packageName: event.packageName,
          timeStamp: DateTime.fromMillisecondsSinceEpoch(
            int.parse(event.timeStamp!),
          ).toIso8601String(),
          className: event.className,
        );
      }).toList();

      setState(() {
        events = normalizedEvent;
        _eventsCount = events.length;
      });
    } catch (err) {
      logger.e(err);
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
      var url = "${Url.base}/event_info";
      String userId = await UserService().getUserId();

      final List<Map<String, dynamic>> eventInfoList = events
          .map(
            (event) => {
              "userId": userId,
              "packageName": event.packageName,
              "eventType": event.eventType,
              "eventDate": event.timeStamp!,
              "className": event.className.toString(),
            },
          )
          .toList();

      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: jsonEncode(eventInfoList),
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
                "Event",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Flexible(
              child: Text(
                "Count: $_eventsCount events",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: CustomColors.bgColor,
        foregroundColor: Colors.white,
      ),
      drawer: CustomDrawer(screenName: "Event Info"),
      body: RefreshIndicator(
        onRefresh: initUsage,
        child: ListView.separated(
          itemBuilder: (context, index) {
            return _eventsCount != 0
                ? ListTile(
                    title: Text(events[index].packageName!),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Last time used: ${events[index].timeStamp}"),
                        Text("Class name: ${events[index].className}"),
                      ],
                    ),
                    trailing: Text(events[index].eventType!),
                  )
                : Center(child: Text("No data yet."));
          },
          separatorBuilder: (context, index) => Divider(),
          itemCount: _eventsCount,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => sendToAPI(context),
        child: Icon(Icons.send),
      ),
    );
  }
}
