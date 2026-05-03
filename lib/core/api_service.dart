import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'api_constants.dart';

/// Wrapper around HTTP responses so callers can check success/failure
/// without throwing exceptions.
class ApiResponse {
  final bool success;
  final dynamic data;
  final String message;
  final int? statusCode;

  ApiResponse({
    required this.success,
    this.data,
    this.message = '',
    this.statusCode,
  });
}

/// Central service for all HTTP communication.
/// Automatically attaches Bearer token and handles common errors.
class ApiService {
  final _storage = GetStorage();

  // ─── Token helpers ─────────────────────────────────────────────────────────

  String? get token => _storage.read<String>(ApiConstants.tokenKey);

  bool get isAuthenticated =>
      _storage.read<bool>(ApiConstants.isLoggedInKey) ?? false;

  Future<void> saveToken(String token) async {
    await _storage.write(ApiConstants.tokenKey, token);
    await _storage.write(ApiConstants.isLoggedInKey, true);
  }

  Future<void> clearToken() async {
    await _storage.remove(ApiConstants.tokenKey);
    await _storage.write(ApiConstants.isLoggedInKey, false);
  }

  // ─── Default headers ──────────────────────────────────────────────────────

  Map<String, String> get _headers {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Uri _uri(String path, [Map<String, String>? queryParams]) =>
      Uri.parse('${ApiConstants.baseUrl}$path')
          .replace(queryParameters: queryParams);

  // ─── GET ──────────────────────────────────────────────────────────────────

  Future<ApiResponse> get(
    String path, {
    Map<String, String>? queryParams,
  }) async {
    try {
      final response = await http
          .get(_uri(path, queryParams), headers: _headers)
          .timeout(const Duration(seconds: 15));
      return _handle(response);
    } on SocketException {
      return ApiResponse(success: false, message: 'no_internet'.tr);
    } on TimeoutException {
      return ApiResponse(success: false, message: 'request_timeout'.tr);
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }

  // ─── POST ─────────────────────────────────────────────────────────────────

  Future<ApiResponse> post(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await http
          .post(
            _uri(path),
            headers: _headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: 15));
      return _handle(response);
    } on SocketException {
      return ApiResponse(success: false, message: 'no_internet'.tr);
    } on TimeoutException {
      return ApiResponse(success: false, message: 'request_timeout'.tr);
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }

  // ─── Response handler ─────────────────────────────────────────────────────

  ApiResponse _handle(http.Response response) {
    dynamic body;
    try {
      body = jsonDecode(utf8.decode(response.bodyBytes));
    } catch (_) {
      body = response.body;
    }

    switch (response.statusCode) {
      case 200:
      case 201:
        return ApiResponse(
          success: true,
          data: body,
          statusCode: response.statusCode,
          message: (body is Map ? body['message'] ?? '' : '').toString(),
        );

      case 401:
        // Token expired or invalid → force logout
        clearToken();
        Get.offAllNamed('/sign_in');
        return ApiResponse(
          success: false,
          statusCode: 401,
          message: 'session_expired'.tr,
        );

      case 422:
        // Validation errors
        final errors = body is Map ? body['errors'] : null;
        String msg = '';
        if (errors is Map) {
          msg = errors.values
              .map((v) => (v as List).first.toString())
              .join('\n');
        } else {
          msg = (body is Map ? body['message'] : body).toString();
        }
        return ApiResponse(success: false, statusCode: 422, message: msg);

      default:
        final msg = body is Map
            ? (body['message'] ?? 'unknown_error').toString()
            : 'server_error'.tr;
        return ApiResponse(
          success: false,
          statusCode: response.statusCode,
          message: msg,
        );
    }
  }
}
