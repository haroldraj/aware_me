import 'package:usage_stats/usage_stats.dart';

class CustomUsageRequest {
  String userId;
  String packageName;
  DateTime firstTimeStamp;
  DateTime lastTimeStamp;
  DateTime lastTimeUsed;
  String totalTimeInForeground;

  CustomUsageRequest({
    required this.userId,
    required this.packageName,
    required this.firstTimeStamp,
    required this.lastTimeStamp,
    required this.lastTimeUsed,
    required this.totalTimeInForeground,
  });

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "packageName": packageName,
      "firstTimeStamp": firstTimeStamp.toIso8601String(),
      "lastTimeUsed": lastTimeUsed.toIso8601String(),
      "lastTimeStamp": lastTimeStamp.toIso8601String(),
      "totalTimeInForeground": totalTimeInForeground,
    };
  }

  factory CustomUsageRequest.fromUsageInfo(String userId, UsageInfo usage) {
    return CustomUsageRequest(
      userId: userId,
      packageName: usage.packageName!,
      firstTimeStamp: DateTime.fromMillisecondsSinceEpoch(
        int.parse(usage.firstTimeStamp!),
      ),
      lastTimeStamp: DateTime.fromMillisecondsSinceEpoch(
        int.parse(usage.lastTimeStamp!),
      ),
      lastTimeUsed: DateTime.fromMillisecondsSinceEpoch(
        int.parse(usage.lastTimeUsed!),
      ),
      totalTimeInForeground: usage.totalTimeInForeground!,
    );
  }
}
