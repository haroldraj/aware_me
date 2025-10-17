import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static final String _baseUrl = dotenv.env["API_BASE_URL"]!;
  static final String _apiKey = dotenv.env["API_KEY"]!;

  static Future<http.Response> sendDataToApi(
    String endpoint,
    dynamic data,
  ) async {
    final String url = _baseUrl + endpoint;
    return await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "api-key": _apiKey,
      },
      body: jsonEncode(data),
    );
  }
}
