import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthRepository {
  final String baseUrl;

  AuthRepository({required this.baseUrl});

  Future<void> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/login');
    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception(jsonDecode(res.body)['message'] ?? 'Register failed');
}
  }

  Future<void> register({
    required String fullName,
    required String phone,
    required String email,
    required String password,
    required int birthYear,
    required String gender,
    String avatar = '',
  }) async {
    final url = Uri.parse('$baseUrl/api/auth/register');
    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fullName': fullName,
        'phone': phone,
        'email': email,
        'password': password,
        'birthYear': birthYear,
        'gender': gender,
        'avatar': avatar,
      }),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception(jsonDecode(res.body)['message'] ?? 'Register failed');
    }
  }
  Future<void> logout() async {
    // TODO: xóa token sau này
    print("Đã logout");
  }
}