import 'package:aware_me/screens/widgets/custom_app_bar.dart';
import 'package:aware_me/screens/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  Logger _logger = Logger();
  int _infosCount = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(screenTitle: "App Usage"),
      drawer: CustomDrawer(screenName: "App Usage"),
    );
  }
}
