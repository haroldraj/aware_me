import 'package:flutter/material.dart';

class Helpers {
  static void goTo(
    BuildContext context,
    Widget screen, {
    bool isReplaced = false,
  }) {
    isReplaced
        ? Navigator.of(
            context,
          ).pushReplacement(MaterialPageRoute(builder: (context) => screen))
        : Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => screen));
  }
}
