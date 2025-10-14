import 'dart:convert';

import 'package:aware_me/constants/constants.dart';
import 'package:aware_me/screens/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usage_stats/usage_stats.dart';
import 'package:uuid/uuid.dart';

class UsageStatsScreen extends StatefulWidget {
  const UsageStatsScreen({super.key});

  @override
  State<UsageStatsScreen> createState() => _UsageStatsScreenState();
}

class _UsageStatsScreenState extends State<UsageStatsScreen> {
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
      UsageStats.grantUsagePermission();

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

  Future<String> getOrCreateUserId() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("userId");
    if (userId == null) {
      setState(() {
        userId = Uuid().v4();
      });
      prefs.setString("userId", userId!);
    }
    logger.w("UserId: $userId");
    return userId!;
  }

  Future<void> sendToAPI() async {
    try {
      var url = "${Url.base}/event_info";

      String userId = await getOrCreateUserId();

      final List<Map<String, dynamic>> eventInfoList = events
          .map(
            (event) => {
              "userId": userId.toString(),
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
              "Event Info",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "Count: $_eventsCount events",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      drawer: CustomDrawer(),
      body: RefreshIndicator(
        onRefresh: initUsage,
        child: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(events[index].packageName!),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Last time used: ${events[index].timeStamp}"),
                  Text("Class name: ${events[index].className}"),
                ],
              ),
              trailing: Text(events[index].eventType!),
            );
          },
          separatorBuilder: (context, index) => Divider(),
          itemCount: events.length,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => sendToAPI(),
        child: Icon(Icons.send),
      ),
    );
  }
}
