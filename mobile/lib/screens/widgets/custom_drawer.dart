import 'package:aware_me/constants/constants.dart';
import 'package:aware_me/constants/enums.dart';
import 'package:aware_me/screens/custom_usage_screen.dart';
import 'package:aware_me/screens/event_infos_screen.dart';
import 'package:aware_me/screens/home_screen.dart';
import 'package:aware_me/screens/network_usage_screen.dart';
import 'package:aware_me/screens/widgets/custom_alert_dialog.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key, required this.screenName});
  final ScreenName screenName;

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
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
                  icon: Icons.home,
                  title: "Home Screen",
                  screenName: ScreenName.home,
                  destination: const HomeScreen(),
                ),
                // _buildDrawerItem(
                //   context,
                //   icon: Icons.data_usage_rounded,
                //   title: "App Usage Screen",
                //   screenName: ScreenName.appUsage,
                //   destination: const AppUsageScreen(),
                // ),
                _buildDrawerItem(
                  context,
                  icon: Icons.event,
                  title: "Event Info Screen",
                  screenName: ScreenName.eventInfo,
                  destination: const EventInfosScreen(),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.people,
                  title: "Custom Usage Screen",
                  screenName: ScreenName.customUsage,
                  destination: const CustomUsageScreen(),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.network_cell,
                  title: "Network Usage Screen",
                  screenName: ScreenName.networkUsage,
                  destination: const NetworkUsageScreen(),
                ),
              ],
            ),
          ),

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
    required ScreenName screenName,
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
