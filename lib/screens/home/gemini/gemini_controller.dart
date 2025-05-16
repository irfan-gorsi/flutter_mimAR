import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mimar/utils/env.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeminiController {
  Future<String> generateText(String prompt) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found. Please log in.');
    }

    final response = await http.post(
      Uri.parse(Env.geminiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'prompt': prompt}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['result'] ?? 'No result from Gemini.';
    } else {
      throw Exception('Gemini API failed: ${response.statusCode} ${response.reasonPhrase}');
    }
  }
}
