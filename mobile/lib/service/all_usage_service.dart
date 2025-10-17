import 'dart:convert';

import 'package:aware_me/models/all_usage_request.dart';
import 'package:aware_me/models/custom_usage_request.dart';
import 'package:aware_me/models/event_info_request.dart';
import 'package:aware_me/models/network_usage_request.dart';
import 'package:aware_me/screens/widgets/custom_alert_dialog.dart';
import 'package:aware_me/service/api_service.dart';
import 'package:aware_me/service/custom_usage_service.dart';
import 'package:aware_me/service/event_info_service.dart';
import 'package:aware_me/service/network_usage_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class AllUsageService {
  final NetworkUsageService _networkUsageService = NetworkUsageService();
  final EventInfoService _eventInfoService = EventInfoService();
  final CustomUsageService _customUsageService = CustomUsageService();
  final String _endpoint = "/all_usage";
  final Logger _logger = Logger();

  Future<void> sendAllUsageData(BuildContext context) async {
    try {
      CustomAlertDialog.showResponseDialog(
        context,
        title: "⏳ Collecting/sending data",
        message: "",
        isSendingData: true,
      );
      await Future.delayed(Duration.zero);
      final results = await Future.wait([
        _networkUsageService.queryNetworkUsage(),
        _eventInfoService.queryEventInfo(),
        _customUsageService.queryCustomUsage(),
      ]);

      final List<NetworkUsageRequest> networks =
          results[0] as List<NetworkUsageRequest>;
      final List<EventInfoRequest> events =
          results[1] as List<EventInfoRequest>;
      final List<CustomUsageRequest> customs =
          results[2] as List<CustomUsageRequest>;

      var data = AllUsageRequest(
        customUsageRequestList: customs,
        eventInfoRequestList: events,
        networkUsageRequestList: networks,
      ).toJson();
      final response = await ApiService.sendDataToApi(_endpoint, data);

      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        CustomAlertDialog.showResponseDialog(
          // ignore: use_build_context_synchronously
          context,
          title: "✅ Success",
          message:
              "Event Info: ${data["event"]["new_inserted"]} new records inserted and ${data["event"]['duplicates_skipped']} existing records skipped.\n"
              "App Usage: ${data["custom"]["new_inserted"]} new records inserted and ${data["custom"]['duplicates_skipped']} existing records skipped.\n"
              "Network Usage: ${data["network"]["new_inserted"]} new records inserted/updated.",
        );
      } else {
        CustomAlertDialog.showResponseDialog(
          // ignore: use_build_context_synchronously
          context,
          title: "❌ Error",
          message: "Server responded with status code ${response.statusCode}.",
        );
      }

      _logger.i(jsonDecode(response.body));
    } catch (e) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      CustomAlertDialog.showResponseDialog(
        // ignore: use_build_context_synchronously
        context,
        title: "⚠️ Exception",
        message: "An error occurred while sending data:\n$e",
      );
      _logger.e(e);
    }
  }
}
