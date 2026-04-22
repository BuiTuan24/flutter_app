import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static Future<String?> register(
      String baseUrl, Map<String, dynamic> data) async {

    final url = Uri.parse("$baseUrl/api/auth/register");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
      return null;
    } else {
      return response.body;
    }
  }
}