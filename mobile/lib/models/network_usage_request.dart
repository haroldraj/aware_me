import 'package:usage_stats/usage_stats.dart';

class NetworkUsageRequest {
  String userId;
  String packageName;
  int totalReceivedBytes;
  int totalTransferredBytes;
  DateTime startDate;
  DateTime endDate;

  NetworkUsageRequest({
    required this.userId,
    required this.packageName,
    required this.totalReceivedBytes,
    required this.totalTransferredBytes,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "packageName": packageName,
      "totalReceivedBytes": totalReceivedBytes,
      "totalTransferredBytes": totalTransferredBytes,
      "startDate": startDate.toIso8601String(),
      "endDate": endDate.toIso8601String(),
    };
  }
  

  factory NetworkUsageRequest.fromNetworkInfo(
    String userId,
    NetworkInfo networdInfo,
    DateTime startDate,
    DateTime endDate,
  ) {
    return NetworkUsageRequest(
      userId: userId,
      packageName: networdInfo.packageName!,
      totalReceivedBytes: int.tryParse(networdInfo.rxTotalBytes ?? '0') ?? 0,
      totalTransferredBytes: int.tryParse(networdInfo.txTotalBytes ?? '0') ?? 0,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
