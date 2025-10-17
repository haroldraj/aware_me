import 'package:aware_me/models/event_info_request.dart';
import 'package:aware_me/service/user_service.dart';
import 'package:usage_stats/usage_stats.dart';

class EventInfoService {
  Future<List<EventInfoRequest>> queryEventInfo() async {
    final DateTime endDate = DateTime.now();
    final DateTime startDate = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
      0,
      1,
    );
    List<EventUsageInfo> queryEvents = await UsageStats.queryEvents(
      startDate,
      endDate,
    );
    String userId = await UserService().getUserId();

    return queryEvents.reversed
        .map((event) => EventInfoRequest.fromEventUsageInfo(userId, event))
        .toList();
  }

  List<Map<String, dynamic>> toJson(List<EventInfoRequest> events) {
    return events.map((event) => event.toJson()).toList();
  }
}
