// services/api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiResult {
  final dynamic data;
  final bool isLoading;
  final String? error;

  ApiResult({required this.data, this.isLoading = false, this.error});
}

class ApiService {
  final http.Client _client = http.Client();

  Future<ApiResult> get(String url) async {
    try {
      final response = await _client.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return ApiResult(data: json.decode(response.body), isLoading: false);
      } else {
        return ApiResult(
          data: null,
          isLoading: false,
          error: 'Failed to load data: ${response.statusCode}',
        );
      }
    } catch (e) {
      return ApiResult(
        data: null,
        isLoading: false,
        error: 'Exception occurred: $e',
      );
    }
  }

  Future<ApiResult> post(String url, dynamic body) async {
    try {
      final response = await _client.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResult(data: json.decode(response.body), isLoading: false);
      } else {
        return ApiResult(
          data: null,
          isLoading: false,
          error: 'Failed to post data: ${response.statusCode}',
        );
      }
    } catch (e) {
      return ApiResult(
        data: null,
        isLoading: false,
        error: 'Exception occurred: $e',
      );
    }
  }

  void dispose() {
    _client.close();
  }
}
