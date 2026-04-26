// lib/repositories/auth_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthRepository {
  static const String _baseUrl = 'https://dummyjson.com';

  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return UserModel(
          token: data['accessToken'],
          email: data['email'] ?? username,
        );
      } else {
        throw Exception(data['message'] ?? 'Login gagal. Periksa username dan password.');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Tidak dapat terhubung ke server. Periksa koneksi internet.');
    }
  }
}