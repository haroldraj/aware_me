import 'package:aware_me/models/custom_usage_request.dart';
import 'package:aware_me/models/event_info_request.dart';
import 'package:aware_me/models/network_usage_request.dart';

class AllUsageRequest {
  List<CustomUsageRequest> customUsageRequestList;
  List<EventInfoRequest> eventInfoRequestList;
  List<NetworkUsageRequest> networkUsageRequestList;

  AllUsageRequest({
    required this.customUsageRequestList,
    required this.eventInfoRequestList,
    required this.networkUsageRequestList,
  });

  Map<String, dynamic> toJson() {
    return {
      "customUsageRequestList": customUsageRequestList
          .map((c) => c.toJson())
          .toList(),
      "eventInfoRequestList": eventInfoRequestList
          .map((e) => e.toJson())
          .toList(),
      "networkUsageRequestList": networkUsageRequestList
          .map((n) => n.toJson())
          .toList(),
    };
  }
}
