import 'package:aware_me/constants/constants.dart';
import 'package:aware_me/constants/enums.dart';
import 'package:aware_me/models/network_usage_request.dart';
import 'package:aware_me/screens/widgets/custom_drawer.dart';
import 'package:aware_me/service/network_usage_service.dart';
import 'package:aware_me/utils/data_sender.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class NetworkUsageScreen extends StatefulWidget {
  const NetworkUsageScreen({super.key});

  @override
  State<NetworkUsageScreen> createState() => _NetworkUsageScreenState();
}

class _NetworkUsageScreenState extends State<NetworkUsageScreen> {
  List<NetworkUsageRequest> networkUsages = [];
  Logger logger = Logger();
  final String _endpoint = "/network_usage";
  final NetworkUsageService _networkUsageService = NetworkUsageService();

  @override
  void initState() {
    super.initState();
    initUsage();
  }

  Future<void> initUsage() async {
    try {
      List<NetworkUsageRequest> normalizedNetwork = await _networkUsageService
          .queryNetworkUsage();

      setState(() {
        networkUsages = normalizedNetwork;
      });
    } catch (err) {
      logger.e(err);
    }
  }

  Future<void> sendToAPI(BuildContext context) async {
    final networkJsonList = _networkUsageService.toJson(networkUsages);
    // ignore: use_build_context_synchronously
    DataSender.sendData(context, _endpoint, networkJsonList, isNetowrk: true);
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
                "Count: ${networkUsages.length}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: CustomColors.bgColor,
        foregroundColor: Colors.white,
      ),
      drawer: CustomDrawer(screenName: ScreenName.networkUsage),
      body: RefreshIndicator(
        onRefresh: initUsage,
        child: Scrollbar(
          child: ListView.separated(
            itemBuilder: (context, index) {
              return networkUsages.isNotEmpty
                  ? ListTile(
                      title: Text(networkUsages[index].packageName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total Received Bytes: ${networkUsages[index].totalReceivedBytes}",
                          ),
                          Text(
                            "Total Transferred Bytes: ${networkUsages[index].totalTransferredBytes}",
                          ),
                          Text("Start Date: ${networkUsages[index].startDate}"),
                          Text("End Date: ${networkUsages[index].endDate}"),
                        ],
                      ),
                    )
                  : Center(child: Text("No data yet."));
            },
            separatorBuilder: (context, index) => Divider(),
            itemCount: networkUsages.length,
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
