import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mimar/utils/env.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserApiService {
  static Future<List<dynamic>> getAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) throw Exception('JWT token not found.');

    final url = Uri.parse(Env.allusersUrl);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Assuming response is a JSON array of users
      return jsonDecode(response.body);
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Failed to fetch users');
    }
  }
}
