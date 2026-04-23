import 'package:uniterm/repositories/i_auth_repository.dart';
import 'package:get_storage/get_storage.dart';

class MockAuthRepository implements IAuthRepository {
  final _storage = GetStorage();
  
  @override
  bool isAuthenticated() {
    return _storage.read<bool>('is_logged_in') ?? false;
  }
  @override
  Future<bool> signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    bool success = email == 'test@uniterm.com' && password == 'password123';
    if (success) {
      await _storage.write('is_logged_in', true);
    }
    return success;
  }

  @override
  Future<bool> register(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    await _storage.write('is_logged_in', true);
    return true;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await _storage.remove('is_logged_in');
  }

  @override
  Future<bool> resetPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
