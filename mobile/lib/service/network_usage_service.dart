import 'package:aware_me/models/network_usage_request.dart';
import 'package:aware_me/service/user_service.dart';
import 'package:usage_stats/usage_stats.dart';

class NetworkUsageService {
  Future<List<NetworkUsageRequest>> queryNetworkUsage() async {
    final DateTime endDate = DateTime.now();
    final DateTime startDate = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
      0,
      1,
    );
    List<NetworkInfo> queryNetworks = await UsageStats.queryNetworkUsageStats(
      startDate,
      endDate,
    );
    String userId = await UserService().getUserId();

    return queryNetworks.reversed
        .where(
          (network) =>
              (int.parse(network.rxTotalBytes ?? "0") > 0) ||
              (int.parse(network.txTotalBytes ?? "0") > 0),
        )
        .map(
          (network) => NetworkUsageRequest.fromNetworkInfo(
            userId,
            network,
            startDate,
            endDate,
          ),
        )
        .toList();
  }

  List<Map<String, dynamic>> toJson(List<NetworkUsageRequest> networks) {
    return networks.map((network) => network.toJson()).toList();
  }
}
