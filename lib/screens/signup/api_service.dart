import 'package:http/http.dart' as http;
import 'package:mimar/utils/env.dart';
import 'dart:convert';

class SignupApiService {
  static Future<String> signup(String fullname,String email, String password) async {
    print('Signup URL: ${Env.signupUrl}');
    final response = await http.post(
      Uri.parse(Env.signupUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'fullname':fullname,'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      return "Signup successful!";
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Signup failed');
    }
  }
}
