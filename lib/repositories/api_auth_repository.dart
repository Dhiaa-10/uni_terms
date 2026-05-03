import 'package:get/get.dart';
import '../core/api_constants.dart';
import '../core/api_service.dart';
import '../models/user_model.dart';
import 'i_auth_repository.dart';

class ApiAuthRepository implements IAuthRepository {
  final ApiService _api = Get.find<ApiService>();

  // ─── IAuthRepository ──────────────────────────────────────────────────────

  @override
  bool isAuthenticated() => _api.isAuthenticated;

  @override
  Future<bool> signIn(String email, String password) async {
    final response = await _api.post(ApiConstants.login, body: {
      'email': email,
      'password': password,
    });

    if (response.success && response.data != null) {
      final data = response.data as Map<String, dynamic>;
      // Backend returns: { "token": "...", "user": {...} }
      final token = data['token'] as String?;
      if (token != null) {
        await _api.saveToken(token);
        return true;
      }
    }
    return false;
  }

  @override
  Future<bool> register(String name, String email, String password) async {
    // name is split as "firstName lastName" for simplicity
    final parts = name.trim().split(' ');
    final firstName = parts.first;
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    final response = await _api.post(ApiConstants.register, body: {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
    });

    if (response.success && response.data != null) {
      final data = response.data as Map<String, dynamic>;
      final token = data['token'] as String?;
      if (token != null) {
        await _api.saveToken(token);
        return true;
      }
    }
    return false;
  }

  /// Extended register that accepts first/last name separately.
  Future<bool> registerWithNames({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final response = await _api.post(ApiConstants.register, body: {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
    });

    if (response.success && response.data != null) {
      final data = response.data as Map<String, dynamic>;
      final token = data['token'] as String?;
      if (token != null) {
        await _api.saveToken(token);
        return true;
      }
    }
    return false;
  }

  @override
  Future<void> logout() async {
    await _api.post(ApiConstants.logout);
    await _api.clearToken();
  }

  @override
  Future<bool> resetPassword(String email) async {
    final response = await _api.post(ApiConstants.sendOtp, body: {
      'email': email,
    });
    return response.success;
  }

  // ─── Extra auth methods ───────────────────────────────────────────────────

  Future<bool> verifyOtp(String email, String otp) async {
    final response = await _api.post(ApiConstants.verifyOtp, body: {
      'email': email,
      'otp': otp,
    });
    return response.success;
  }

  Future<bool> resetPasswordWithOtp(
      String email, String otp, String newPassword) async {
    final response = await _api.post(ApiConstants.resetPassword, body: {
      'email': email,
      'otp': otp,
      'password': newPassword,
    });
    return response.success;
  }

  Future<UserModel?> getProfile() async {
    final response = await _api.get(ApiConstants.profile);
    if (response.success && response.data != null) {
      final data = response.data as Map<String, dynamic>;
      // Backend may wrap in { "user": {...} } or return directly
      final userJson = data['user'] ?? data;
      return UserModel.fromJson(userJson as Map<String, dynamic>);
    }
    return null;
  }

  /// Returns the last error message from the sign-in attempt
  String _lastError = '';
  String get lastError => _lastError;

  Future<(bool, String)> signInWithMessage(String email, String password) async {
    final response = await _api.post(ApiConstants.login, body: {
      'email': email,
      'password': password,
    });

    if (response.success && response.data != null) {
      final data = response.data as Map<String, dynamic>;
      final token = data['token'] as String?;
      if (token != null) {
        await _api.saveToken(token);
        return (true, '');
      }
    }
    return (false, response.message);
  }
}
