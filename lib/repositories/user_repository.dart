// lib/repositories/user_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_user.dart';

class UserRepository {
  // Gunakan 'http://10.0.2.2:8000/api' untuk Android Emulator
  // Gunakan 'http://localhost:8000/api' untuk iOS Simulator atau Web
  static const String _baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<ApiUser>> fetchUsers({
    required String token,
    int page = 1,
  }) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/users?page=$page'),
      headers: _authHeaders(token),
    );

    final data = _decodeJson(response);
    if (response.statusCode == 200) {
      final payload = data['data'] as Map<String, dynamic>? ?? {};
      final items = (payload['data'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>();
      return items.map(ApiUser.fromJson).toList();
    }

    throw Exception(data['message'] ?? 'Gagal mengambil data users.');
  }

  Future<ApiUser> fetchUser({
    required String token,
    required int id,
  }) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/users/$id'),
      headers: _authHeaders(token),
    );

    final data = _decodeJson(response);
    if (response.statusCode == 200) {
      final payload = data['data'] as Map<String, dynamic>? ?? {};
      return ApiUser.fromJson(payload);
    }

    throw Exception(data['message'] ?? 'Gagal mengambil detail user.');
  }

  Future<ApiUser> createUser({
    required String token,
    required Map<String, dynamic> body,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users'),
      headers: _authHeaders(token),
      body: jsonEncode(body),
    );

    final data = _decodeJson(response);
    if (response.statusCode == 201) {
      final payload = data['data'] as Map<String, dynamic>? ?? {};
      return ApiUser.fromJson(payload);
    }

    throw Exception(data['message'] ?? 'Gagal membuat user.');
  }

  Future<ApiUser> updateUser({
    required String token,
    required int id,
    required Map<String, dynamic> body,
  }) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/users/$id'),
      headers: _authHeaders(token),
      body: jsonEncode(body),
    );

    final data = _decodeJson(response);
    if (response.statusCode == 200) {
      final payload = data['data'] as Map<String, dynamic>? ?? {};
      return ApiUser.fromJson(payload);
    }

    throw Exception(data['message'] ?? 'Gagal mengubah user.');
  }

  Future<void> deleteUser({
    required String token,
    required int id,
  }) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/users/$id'),
      headers: _authHeaders(token),
    );

    final data = _decodeJson(response);
    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? 'Gagal menghapus user.');
    }
  }

  Map<String, String> _authHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Map<String, dynamic> _decodeJson(http.Response response) {
    if (response.body.isEmpty) {
      return {};
    }

    final decoded = jsonDecode(response.body);
    return decoded is Map<String, dynamic> ? decoded : {};
  }
}
