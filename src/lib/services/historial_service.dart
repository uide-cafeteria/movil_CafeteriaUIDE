import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cafeteria_uide/utils/secure_storage.dart';

class HistorialService {
  static const String baseUrl = "http://localhost:3001/api/historial";

  static Future<Map<String, dynamic>> obtenerMiHistorial() async {
    final token = await SecureStorage.getToken();
    final response = await http.get(
      Uri.parse("$baseUrl/usuario/mostrar"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['data'];
    } else {
      throw Exception("Error al cargar historial");
    }
  }
}
