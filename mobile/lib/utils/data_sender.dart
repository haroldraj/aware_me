import 'dart:convert';
import 'package:aware_me/screens/widgets/custom_alert_dialog.dart';
import 'package:aware_me/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class DataSender {
  static final Logger _logger = Logger();

  static Future<void> sendData(
    BuildContext context,
    String endpoint,
    dynamic dataList, {
    bool isNetowrk = false,
    bool isAllData = false,
  }) async {
    if (dataList.isEmpty) {
      CustomAlertDialog.showResponseDialog(
        context,
        title: "❌ Error",
        message: "No data to send.",
      );
      return;
    }

    CustomAlertDialog.showResponseDialog(
      context,
      title: "⏳ Sending data",
      message: "",
      isSendingData: true,
    );

    await Future.delayed(Duration.zero);

    try {
      final response = await ApiService.sendDataToApi(endpoint, dataList);

      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        CustomAlertDialog.showResponseDialog(
          // ignore: use_build_context_synchronously
          context,
          title: "✅ Success",
          message: isAllData
              ? "event: ${data["event"]}\ncustom: ${data["custom"]}\nnetwork: ${data["network"]}"
              : isNetowrk
              ? "${data['new_inserted']} new records inserted/updated."
              : "${data['new_inserted']} new records inserted.\n${data['duplicates_skipped']} existing records skipped.",
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
