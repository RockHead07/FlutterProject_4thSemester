// lib/repositories/auth_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthRepository {
  // TODO: Ganti dengan base URL Laravel REST API Anda
  // Android Emulator: http://10.0.2.2:8000/api
  // iOS Simulator / Web: http://localhost:8000/api
  // Perangkat fisik: gunakan IP laptop di jaringan yang sama
  static const String _baseUrl = 'http://10.253.55.170:8000/api';

  Future<UserModel> login({
    required String username,
    required String password,
  }) async {  
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'), // Sesuaikan endpoint login Laravel Anda
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json', // Header Accept biasanya dibutuhkan oleh Laravel
        },
        body: jsonEncode({
          // API Laravel menerima key "email" (boleh berisi email atau username)
          'email': username,
          'password': password,
          'device_name': 'flutter',
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final payload = data['data'] ?? {};
        return UserModel(
          token: payload['token'] ?? '',
          email: payload['user']?['email'] ?? username,
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