import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Url {
  static String base = dotenv.env['API_BASE_URL'] ?? "http://localhost:8000";
}

class CustomColors {
  static Color bgColor = Color(0xFF5c2961);
  static Color selectedColor = Color(0xCC643768);
}
