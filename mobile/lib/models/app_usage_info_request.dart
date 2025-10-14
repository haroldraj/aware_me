class AppUsageInfoRequest {
  final String? userId;
  final String? packageName;
  final DateTime? firstTimeStamp;
  final DateTime? lastTimeStamp;
  final String? totalTimeInForeground;

  AppUsageInfoRequest({
    this.userId,
    this.packageName,
    this.firstTimeStamp,
    this.lastTimeStamp,
    this.totalTimeInForeground,
  });

}
