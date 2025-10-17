import 'dart:core';

import 'package:usage_stats/usage_stats.dart';

class EventInfoRequest {
  String userId;
  String packageName;
  String eventType;
  DateTime eventDate;
  String className;

  EventInfoRequest({
    required this.userId,
    required this.packageName,
    required this.eventType,
    required this.eventDate,
    required this.className,
  });

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "packageName": packageName,
      "eventType": eventType,
      "eventDate": eventDate.toIso8601String(),
      "className": className,
    };
  }

  factory EventInfoRequest.fromEventUsageInfo(
    String userId,
    EventUsageInfo event,
  ) {
    return EventInfoRequest(
      userId: userId,
      packageName: event.packageName ?? '',
      eventType: event.eventType ?? '',
      eventDate: DateTime.fromMillisecondsSinceEpoch(
        int.parse(event.timeStamp!),
      ),
      className: event.className ?? '',
    );
  }
}
