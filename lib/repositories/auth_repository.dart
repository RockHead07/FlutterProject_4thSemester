// lib/repositories/auth_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthRepository {
  // Using reqres.in as free dummy API for demo
  static const String _baseUrl = 'https://reqres.in/api';

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return UserModel(
          token: data['token'],
          email: email,
        );
      } else {
        throw Exception(data['error'] ?? 'Login gagal. Periksa email dan password.');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Tidak dapat terhubung ke server. Periksa koneksi internet.');
    }
  }
}