import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/secure_storage.dart';

class AuthService {
  static const String baseUrl = "https://tu-api.com/auth";

  Future<bool> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/login");

    final response = await http.post(
      url,
      body: {"email": email, "password": password},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      await SecureStorage.saveToken(data['token']);
      return true;
    }
    return false;
  }
}
