import 'package:app_usage/app_usage.dart';
import 'package:aware_me/constants/constants.dart';
import 'package:aware_me/constants/enums.dart';
import 'package:aware_me/screens/widgets/custom_drawer.dart';
import 'package:aware_me/service/user_service.dart';
import 'package:aware_me/utils/data_sender.dart';
import 'package:flutter/material.dart';
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
  final String _appEndpoint = "/app_usage";
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

  Future<void> sendToAPI(BuildContext context) async {
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
    // ignore: use_build_context_synchronously
    DataSender.sendData(context, _appEndpoint, appUsageInfoList);
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
                "Count: $_infosCount",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: CustomColors.bgColor,
        foregroundColor: Colors.white,
      ),
      drawer: CustomDrawer(screenName: ScreenName.appUsage),
      body: RefreshIndicator(
        onRefresh: getUsageStats,
        child: Scrollbar(
          child: ListView.separated(
            itemCount: _infosCount,
            itemBuilder: (context, index) {
              return _infosCount != 0
                  ? ListTile(
                      title: Text(_infos[index].packageName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total Time Used (h:m:s): ${_infos[index].usage.toString()}",
                          ),
                        ],
                      ),
                    )
                  : Center(child: Text("No data yet."));
            },
            separatorBuilder: (context, index) => Divider(),
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
