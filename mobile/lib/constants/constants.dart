import 'package:flutter_dotenv/flutter_dotenv.dart';

class Url {
  static String base = dotenv.env['API_BASE_URL'] ?? "http://localhost:8000";
}
