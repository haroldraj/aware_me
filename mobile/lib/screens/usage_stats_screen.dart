import 'package:aware_me/screens/app_usage_screen.dart';
import 'package:aware_me/screens/custom_usage_screen.dart';
import 'package:aware_me/screens/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:usage_stats/usage_stats.dart';

class UsageStatsScreen extends StatefulWidget {
  const UsageStatsScreen({super.key});

  @override
  State<UsageStatsScreen> createState() => _UsageStatsScreenState();
}

class _UsageStatsScreenState extends State<UsageStatsScreen> {
  List<EventUsageInfo> events = [];
  Map<String?, NetworkInfo?> _netInfoMap = Map();
  Logger logger = Logger();

  @override
  void initState() {
    super.initState();

    initUsage();
  }

  Future<void> initUsage() async {
    try {
      UsageStats.grantUsagePermission();

      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(Duration(days: 1));

      List<EventUsageInfo> queryEvents = await UsageStats.queryEvents(
        startDate,
        endDate,
      );
      logger.w(queryEvents);
      List<NetworkInfo> networkInfos = await UsageStats.queryNetworkUsageStats(
        startDate,
        endDate,
        networkType: NetworkType.all,
      );

      Map<String?, NetworkInfo?> netInfoMap = {
        for (var v in networkInfos) v.packageName: v,
      };

      List<UsageInfo> t = await UsageStats.queryUsageStats(startDate, endDate);

      for (var i in t) {
        if (double.parse(i.totalTimeInForeground!) > 0) {
          logger.i(
            DateTime.fromMillisecondsSinceEpoch(
              int.parse(i.firstTimeStamp!),
            ).toIso8601String(),
          );

          logger.i(
            DateTime.fromMillisecondsSinceEpoch(
              int.parse(i.lastTimeStamp!),
            ).toIso8601String(),
          );

          logger.i(i.packageName);
          logger.i(
            DateTime.fromMillisecondsSinceEpoch(
              int.parse(i.lastTimeUsed!),
            ).toIso8601String(),
          );
          logger.i(int.parse(i.totalTimeInForeground!) / 1000 / 60);

          logger.i('-----\n');
        }
      }

      setState(() {
        logger.w(queryEvents.first.eventType);
        events = queryEvents.reversed.toList();
        _netInfoMap = netInfoMap;
      });
    } catch (err) {
      logger.e(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(screenTitle: "Usage Stats"),
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
      body: Container(
        child: RefreshIndicator(
          onRefresh: initUsage,
          child: ListView.separated(
            itemBuilder: (context, index) {
              var event = events[index];
              var networkInfo = _netInfoMap[event.packageName];
              return ListTile(
                title: Text(events[index].packageName!),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Last time used: ${DateTime.fromMillisecondsSinceEpoch(int.parse(events[index].timeStamp!)).toIso8601String()}",
                    ),
                    networkInfo == null
                        ? Text("Unknown network usage")
                        : Text(
                            "Received bytes: ${networkInfo.rxTotalBytes}\n" +
                                "Transfered bytes : ${networkInfo.txTotalBytes}",
                          ),
                  ],
                ),
                trailing: Text(events[index].eventType!),
              );
            },
            separatorBuilder: (context, index) => Divider(),
            itemCount: events.length,
          ),
        ),
      ),
    );
  }
}
