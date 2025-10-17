import 'package:aware_me/constants/constants.dart';
import 'package:aware_me/constants/enums.dart';
import 'package:aware_me/models/custom_usage_request.dart';
import 'package:aware_me/screens/widgets/custom_drawer.dart';
import 'package:aware_me/service/custom_usage_service.dart';
import 'package:aware_me/utils/data_sender.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class CustomUsageScreen extends StatefulWidget {
  const CustomUsageScreen({super.key});

  @override
  State<CustomUsageScreen> createState() => _CustomUsageScreenState();
}

class _CustomUsageScreenState extends State<CustomUsageScreen> {
  final Logger _logger = Logger();
  List<CustomUsageRequest> customUsage = [];
  final String _customEndpoint = "/custom_usage";
  final CustomUsageService _customUsageService = CustomUsageService();

  @override
  void initState() {
    super.initState();
    initUsage();
  }

  Future<void> initUsage() async {
    try {
      List<CustomUsageRequest> normalizedUsage = await _customUsageService
          .queryCustomUsage();
      setState(() {
        customUsage = normalizedUsage;
      });
    } catch (err) {
      _logger.e(err);
    }
  }

  Future<void> sendToAPI(BuildContext context) async {
    final customJsonList = _customUsageService.toJson(customUsage);
    // ignore: use_build_context_synchronously
    DataSender.sendData(context, _customEndpoint, customJsonList);
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
                "Count: ${customUsage.length}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: CustomColors.bgColor,
        foregroundColor: Colors.white,
      ),
      drawer: CustomDrawer(screenName: ScreenName.customUsage),
      body: RefreshIndicator(
        onRefresh: initUsage,
        child: Scrollbar(
          child: ListView.separated(
            separatorBuilder: (context, index) => Divider(),
            itemCount: customUsage.length,
            itemBuilder: (context, index) {
              return customUsage.isNotEmpty
                  ? ListTile(
                      title: Text(customUsage[index].packageName),
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
