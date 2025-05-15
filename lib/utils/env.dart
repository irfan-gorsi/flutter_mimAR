import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? '';
  static String get signupUrl => '$apiBaseUrl/api/auth/signup';
  static String get loginUrl => '$apiBaseUrl/api/auth/login';
  static String get weatherUrl => '$apiBaseUrl/api/weather';
}
