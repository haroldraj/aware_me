import 'package:aware_me/constants/constants.dart';
import 'package:aware_me/constants/enums.dart';
import 'package:aware_me/models/event_info_request.dart';
import 'package:aware_me/screens/widgets/custom_drawer.dart';
import 'package:aware_me/service/event_info_service.dart';
import 'package:aware_me/utils/data_sender.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class EventInfosScreen extends StatefulWidget {
  const EventInfosScreen({super.key});

  @override
  State<EventInfosScreen> createState() => _EventInfosScreenState();
}

class _EventInfosScreenState extends State<EventInfosScreen> {
  List<EventInfoRequest> events = [];
  Logger logger = Logger();
  final String _endpoint = "/event_info";
  final EventInfoService _eventInfoService = EventInfoService();

  @override
  void initState() {
    super.initState();
    initUsage();
  }

  Future<void> initUsage() async {
    try {
      List<EventInfoRequest> normalizedEvent = await _eventInfoService
          .queryEventInfo();

      setState(() {
        events = normalizedEvent;
      });
    } catch (err) {
      logger.e(err);
    }
  }

  Future<void> sendToAPI(BuildContext context) async {
    final eventJsonList = _eventInfoService.toJson(events);
    // ignore: use_build_context_synchronously
    DataSender.sendData(context, _endpoint, eventJsonList);
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
                "Count: ${events.length}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: CustomColors.bgColor,
        foregroundColor: Colors.white,
      ),
      drawer: CustomDrawer(screenName: ScreenName.eventInfo),
      body: RefreshIndicator(
        onRefresh: initUsage,
        child: Scrollbar(
          child: ListView.separated(
            itemBuilder: (context, index) {
              return events.isNotEmpty
                  ? ListTile(
                      title: Text(events[index].packageName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Last time used: ${events[index].eventDate}"),
                          events[index].className.isNotEmpty
                              ? Text("Class name: ${events[index].className}")
                              : SizedBox(),
                        ],
                      ),
                      trailing: Text(events[index].eventType),
                    )
                  : Center(child: Text("No data yet."));
            },
            separatorBuilder: (context, index) => Divider(),
            itemCount: events.length,
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
