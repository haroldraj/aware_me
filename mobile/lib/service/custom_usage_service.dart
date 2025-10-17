import 'package:aware_me/models/custom_usage_request.dart';
import 'package:aware_me/service/user_service.dart';
import 'package:usage_stats/usage_stats.dart';

class CustomUsageService {
  Future<List<CustomUsageRequest>> queryCustomUsage() async {
    final DateTime endDate = DateTime.now();
    final DateTime startDate = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
      0,
      1,
    );
    List<UsageInfo> customUsages = await UsageStats.queryUsageStats(
      startDate,
      endDate,
    );
    String userId = await UserService().getUserId();

    return customUsages.reversed
        .where((usage) => int.parse(usage.totalTimeInForeground ?? "0") > 0)
        .map((usage) => CustomUsageRequest.fromUsageInfo(userId, usage))
        .toList();
  }

  List<Map<String, dynamic>> toJson(List<CustomUsageRequest> usages) {
    return usages.map((usage) => usage.toJson()).toList();
  }
}
