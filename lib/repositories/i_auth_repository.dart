abstract class IAuthRepository {
  Future<bool> signIn(String email, String password);
  Future<bool> register(String name, String email, String password);
  Future<void> logout();
  Future<bool> resetPassword(String email);
}
