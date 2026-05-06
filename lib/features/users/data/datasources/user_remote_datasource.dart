import '../../../../core/network/api_client.dart';
import '../models/api_user_model.dart';

/// Abstract contract for user remote data operations.
abstract class UserRemoteDatasource {
  Future<List<ApiUserModel>> fetchUsers({required String token, int page = 1});
  Future<ApiUserModel> fetchUser({required String token, required int id});
  Future<ApiUserModel> createUser({required String token, required Map<String, dynamic> body});
  Future<ApiUserModel> updateUser({required String token, required int id, required Map<String, dynamic> body});
  Future<void> deleteUser({required String token, required int id});
}

/// Implementation using [ApiClient] to call the Laravel REST API.
///
/// All HTTP logic extracted from the original `UserRepository`.
class UserRemoteDatasourceImpl implements UserRemoteDatasource {
  final ApiClient apiClient;

  UserRemoteDatasourceImpl({required this.apiClient});

  @override
  Future<List<ApiUserModel>> fetchUsers({
    required String token,
    int page = 1,
  }) async {
    final response = await apiClient.get(
      '/users',
      token: token,
      queryParams: {'page': page.toString()},
    );

    final data = apiClient.decodeJson(response);
    if (response.statusCode == 200) {
      final raw = data['data'];
      List<dynamic> items;
      if (raw is List) {
        items = raw;
      } else if (raw is Map<String, dynamic>) {
        items = (raw['data'] as List<dynamic>?) ?? [];
      } else {
        items = [];
      }
      return items
          .cast<Map<String, dynamic>>()
          .map(ApiUserModel.fromJson)
          .toList();
    }

    throw Exception(data['message'] ?? 'Gagal mengambil data users.');
  }

  @override
  Future<ApiUserModel> fetchUser({
    required String token,
    required int id,
  }) async {
    final response = await apiClient.get('/users/$id', token: token);

    final data = apiClient.decodeJson(response);
    if (response.statusCode == 200) {
      final payload = data['data'] as Map<String, dynamic>? ?? {};
      return ApiUserModel.fromJson(payload);
    }

    throw Exception(data['message'] ?? 'Gagal mengambil detail user.');
  }

  @override
  Future<ApiUserModel> createUser({
    required String token,
    required Map<String, dynamic> body,
  }) async {
    final response = await apiClient.post('/users', token: token, body: body);

    final data = apiClient.decodeJson(response);
    if (response.statusCode == 201) {
      final payload = data['data'] as Map<String, dynamic>? ?? {};
      return ApiUserModel.fromJson(payload);
    }

    throw Exception(data['message'] ?? 'Gagal membuat user.');
  }

  @override
  Future<ApiUserModel> updateUser({
    required String token,
    required int id,
    required Map<String, dynamic> body,
  }) async {
    final response = await apiClient.put('/users/$id', token: token, body: body);

    final data = apiClient.decodeJson(response);
    if (response.statusCode == 200) {
      final payload = data['data'] as Map<String, dynamic>? ?? {};
      return ApiUserModel.fromJson(payload);
    }

    throw Exception(data['message'] ?? 'Gagal mengubah user.');
  }

  @override
  Future<void> deleteUser({
    required String token,
    required int id,
  }) async {
    final response = await apiClient.delete('/users/$id', token: token);

    final data = apiClient.decodeJson(response);
    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? 'Gagal menghapus user.');
    }
  }
}
