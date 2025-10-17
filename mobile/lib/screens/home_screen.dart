import 'package:aware_me/constants/constants.dart';
import 'package:aware_me/constants/enums.dart';
import 'package:aware_me/screens/widgets/custom_drawer.dart';
import 'package:aware_me/service/all_usage_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AllUsageService _allUsageService = AllUsageService();

  Future<void> sendToAPI(BuildContext context) async {
    _allUsageService.sendAllUsageData(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: CustomColors.bgColor,
        foregroundColor: Colors.white,
      ),
      drawer: CustomDrawer(screenName: ScreenName.home),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: CustomColors.bgColor,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            sendToAPI(context);
          },
          child: Text(
            "Tap to collect & send data",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
