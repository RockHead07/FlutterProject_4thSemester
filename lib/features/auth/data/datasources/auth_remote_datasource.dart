import 'dart:convert';

import '../../../../core/network/api_client.dart';
import '../models/auth_response_model.dart';

/// Abstract contract for auth remote data operations.
abstract class AuthRemoteDatasource {
  Future<AuthResponseModel> login({
    required String username,
    required String password,
  });
}

/// Implementation using [ApiClient] to call the Laravel REST API.
class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final ApiClient apiClient;

  AuthRemoteDatasourceImpl({required this.apiClient});

  @override
  Future<AuthResponseModel> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await apiClient.post(
        '/login',
        body: {
          // API Laravel menerima key "email" (boleh berisi email atau username)
          'email': username,
          'password': password,
          'device_name': 'flutter',
        },
      );

      final data = apiClient.decodeJson(response);

      if (response.statusCode == 200) {
        return AuthResponseModel.fromJson(data);
      } else {
        throw Exception(
          data['message'] ?? 'Login gagal. Periksa username dan password.',
        );
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Tidak dapat terhubung ke server. Periksa koneksi internet.');
    }
  }
}
