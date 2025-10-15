import 'dart:convert';

import 'package:aware_me/constants/constants.dart';
import 'package:aware_me/screens/widgets/custom_drawer.dart';
import 'package:aware_me/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:usage_stats/usage_stats.dart';

class NetworkUsageScreen extends StatefulWidget {
  const NetworkUsageScreen({super.key});

  @override
  State<NetworkUsageScreen> createState() => _NetworkUsageScreenState();
}

class _NetworkUsageScreenState extends State<NetworkUsageScreen> {
  List<NetworkInfo> networkUsages = [];
  Logger logger = Logger();
  int _networksCount = 0;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    initUsage();
  }

  Future<void> initUsage() async {
    try {
      DateTime now = DateTime.now();
      DateTime startDate = DateTime(now.year, now.month, now.day, 0, 1);

      List<NetworkInfo> queryNetworks = await UsageStats.queryNetworkUsageStats(
        startDate,
        now,
      );
      List<NetworkInfo> normalizedNetwork = queryNetworks
          .where(
            (network) =>
                (int.parse(network.rxTotalBytes ?? "0") > 0) ||
                (int.parse(network.txTotalBytes ?? "0") > 0),
          )
          .map((network) {
            return NetworkInfo(
              packageName: network.packageName,
              rxTotalBytes: network.rxTotalBytes,
              txTotalBytes: network.txTotalBytes,
            );
          })
          .toList();

      setState(() {
        networkUsages = normalizedNetwork;
        _networksCount = networkUsages.length;
        _endDate = now;
        _startDate = startDate;
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
      var url = "${Url.base}/network_usage";
      String userId = await UserService().getUserId();

      final List<Map<String, dynamic>> networkUsageList = networkUsages
          .map(
            (network) => {
              "userId": userId,
              "packageName": network.packageName,
              "totalReceivedBytes": network.rxTotalBytes,
              "totalTransferredBytes": network.txTotalBytes,
              "startDate": _startDate!.toIso8601String(),
              "endDate": _endDate!.toIso8601String(),
            },
          )
          .toList();

      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: jsonEncode(networkUsageList),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _showResponseDialog(
          // ignore: use_build_context_synchronously
          context,
          title: "✅ Success",
          message: "${data['new_inserted']} new records inserted/updated.",
        );
      } else {
        _showResponseDialog(
          // ignore: use_build_context_synchronously
          context,
          title: "❌ Error",
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
                "Network",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Flexible(
              child: Text(
                "Count: $_networksCount exchanges",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: CustomColors.bgColor,
        foregroundColor: Colors.white,
      ),
      drawer: CustomDrawer(screenName: "Network Usage"),
      body: RefreshIndicator(
        onRefresh: initUsage,
        child: ListView.separated(
          itemBuilder: (context, index) {
            return _networksCount != 0
                ? ListTile(
                    title: Text(networkUsages[index].packageName!),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Received Bytes: ${networkUsages[index].rxTotalBytes}",
                        ),
                        Text(
                          "Total Transferred Bytes: ${networkUsages[index].txTotalBytes}",
                        ),
                        Text("Start Date: $_startDate"),
                        Text("End Date: $_endDate"),
                      ],
                    ),
                  )
                : Center(child: Text("No data yet."));
          },
          separatorBuilder: (context, index) => Divider(),
          itemCount: _networksCount,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => sendToAPI(context),
        child: Icon(Icons.send),
      ),
    );
  }
}
