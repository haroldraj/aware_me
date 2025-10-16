import 'package:aware_me/constants/constants.dart';
import 'package:aware_me/screens/app_usage_screen.dart';
import 'package:aware_me/screens/custom_usage_screen.dart';
import 'package:aware_me/screens/event_infos_screen.dart';
import 'package:aware_me/screens/network_usage_screen.dart';
import 'package:aware_me/screens/widgets/custom_alert_dialog.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key, required this.screenName});
  final String screenName;

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  // ignore: constant_identifier_names
  static const String APP_USAGE = "App Usage";
  // ignore: constant_identifier_names
  static const String CUSTOM_USAGE = "Custom Usage";
  // ignore: constant_identifier_names
  static const String EVENT_INFO = "Event Info";
  // ignore: constant_identifier_names
  static const String NETWORK_USAGE = "Network Usage";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: CustomColors.bgColor,
      child: Column(
        children: [
          DrawerHeader(
            child: Image(image: AssetImage("img/logo_aware_me_face.png")),
          ),

          Expanded(
            child: ListView(
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.data_usage_rounded,
                  title: "App Usage Screen",
                  screenName: APP_USAGE,
                  destination: const AppUsageScreen(),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.event,
                  title: "Event Infos Screen",
                  screenName: EVENT_INFO,
                  destination: const EventInfosScreen(),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.people,
                  title: "Custom Usage Screen",
                  screenName: CUSTOM_USAGE,
                  destination: const CustomUsageScreen(),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.network_cell,
                  title: "Network Usage Screen",
                  screenName: NETWORK_USAGE,
                  destination: const NetworkUsageScreen(),
                ),
              ],
            ),
          ),

          // ✅ Footer
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.info_outline, color: Colors.white),
                  title: Text(
                    "Data Privacy",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    CustomAlertDialog.showPrivacyDialog(context);
                  },
                ),

                Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 12.0),
                  child: const Divider(color: Colors.white54),
                ),
                Text(
                  "AwareMe © 2025",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String screenName,
    required Widget destination,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      enabled: !(widget.screenName == screenName),
      tileColor: widget.screenName == screenName
          ? CustomColors.selectedColor
          : CustomColors.bgColor,
      onTap: () {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (context) => destination));
      },
    );
  }
}
