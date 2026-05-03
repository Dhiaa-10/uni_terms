abstract class IAuthRepository {
  bool isAuthenticated();
  Future<bool> signIn(String email, String password);
  Future<bool> register(String name, String email, String password);
  Future<void> logout();
  Future<bool> resetPassword(String email);
  Future<bool> verifyOtp(String email, String otp);
  Future<bool> resetPasswordWithOtp(String email, String otp, String newPassword);
}
