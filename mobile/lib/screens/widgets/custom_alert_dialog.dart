import 'package:aware_me/constants/constants.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog {
  static void showResponseDialog(
    BuildContext context, {
    required String title,
    required String message,
    bool isSendingData = false,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: CustomColors.bgColor,
            ),
          ),
          content: isSendingData
              ? SizedBox(
                  height: 50,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: CustomColors.bgColor,
                    ),
                  ),
                )
              : Text(message),

          actions: [
            isSendingData
                ? Text("")
                : TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      "OK",
                      style: TextStyle(color: CustomColors.bgColor),
                    ),
                  ),
          ],
        );
      },
    );
  }

  static void showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            "Data Privacy & Usage",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: CustomColors.bgColor,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "This app collects anonymized data about smartphone usage to help "
                  "analyze digital habits and detect potential signs of overuse. "
                  "No personal messages, images, passwords, or content are ever collected.",
                  style: TextStyle(height: 1.4),
                ),
                SizedBox(height: 12),
                Text(
                  "Collected data includes:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  "• App usage duration and open times\n"
                  "• App event logs (when opened or closed)\n"
                  "• Network usage statistics (data sent/received)\n"
                  "• Device identifier (anonymous user ID only)",
                ),
                SizedBox(height: 12),
                Text("Purpose:", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Text(
                  "The goal is to study smartphone behavior patterns in a private, "
                  "secure way to support research on digital well-being and potential "
                  "addictive use of technology.",
                ),
                SizedBox(height: 12),
                Text(
                  "Data storage & retention:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  "All data is securely stored in a private database and used exclusively "
                  "for research and testing. No data is shared or sold. "
                  "You may request deletion at any time.",
                ),
                SizedBox(height: 12),
                Text(
                  "If you have concerns, please contact the project developer directly.",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Close",
                style: TextStyle(
                  color: CustomColors.bgColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
