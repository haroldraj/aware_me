class AppUsageRequest {
  String userId;
  String packageName;
  String appName;
  DateTime startDate;
  DateTime endDate;
  String totalTimeInForeground;

  AppUsageRequest({
    required this.userId,
    required this.packageName,
    required this.startDate,
    required this.endDate,
    required this.totalTimeInForeground,
    required this.appName,
  });
}
