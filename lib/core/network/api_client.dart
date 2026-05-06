import 'dart:convert';
import 'package:http/http.dart' as http;

/// Centralized HTTP client wrapper.
///
/// Provides the base URL, common headers, and JSON decoding
/// so that all datasources share a single configuration point.
class ApiClient {
  final http.Client client;
  static const String baseUrl = 'http://10.253.55.170:8000/api';

  ApiClient({required this.client});

  /// Headers for unauthenticated requests.
  Map<String, String> get defaultHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  /// Headers for authenticated requests (includes Bearer token).
  Map<String, String> authHeaders(String token) => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

  // ── Convenience HTTP methods ───────────────────────────────────────────────

  Future<http.Response> get(
    String path, {
    String? token,
    Map<String, String>? queryParams,
  }) {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: queryParams);
    return client.get(uri, headers: token != null ? authHeaders(token) : defaultHeaders);
  }

  Future<http.Response> post(
    String path, {
    String? token,
    Map<String, dynamic>? body,
  }) {
    return client.post(
      Uri.parse('$baseUrl$path'),
      headers: token != null ? authHeaders(token) : defaultHeaders,
      body: body != null ? jsonEncode(body) : null,
    );
  }

  Future<http.Response> put(
    String path, {
    String? token,
    Map<String, dynamic>? body,
  }) {
    return client.put(
      Uri.parse('$baseUrl$path'),
      headers: token != null ? authHeaders(token) : defaultHeaders,
      body: body != null ? jsonEncode(body) : null,
    );
  }

  Future<http.Response> delete(
    String path, {
    String? token,
  }) {
    return client.delete(
      Uri.parse('$baseUrl$path'),
      headers: token != null ? authHeaders(token) : defaultHeaders,
    );
  }

  /// Safely decodes a JSON response body into a Map.
  Map<String, dynamic> decodeJson(http.Response response) {
    if (response.body.isEmpty) return {};
    final decoded = jsonDecode(response.body);
    return decoded is Map<String, dynamic> ? decoded : {};
  }
}
