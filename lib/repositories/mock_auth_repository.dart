import 'package:uniterm/repositories/i_auth_repository.dart';

class MockAuthRepository implements IAuthRepository {
  @override
  Future<bool> signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return email == 'test@uniterm.com' && password == 'password123';
  }

  @override
  Future<bool> register(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<bool> resetPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
