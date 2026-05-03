class ApiConstants {
  // ─── Base ─────────────────────────────────────────────────────────────────
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  // ─── Auth ─────────────────────────────────────────────────────────────────
  static const String register = '/register';
  static const String login    = '/login';
  static const String logout   = '/logout';
  static const String profile  = '/profile';

  // ─── Content ──────────────────────────────────────────────────────────────
  static const String specs      = '/specs';
  static const String latestTerms = '/terms/latest';
  static String specTerms(int specId) => '/specs/$specId/terms';

  // ─── Quizzes ──────────────────────────────────────────────────────────────
  static String specLevels(int specId)  => '/specs/$specId/levels';
  static String levelQuestions(int levelId) => '/levels/$levelId/questions';
  static const String checkAnswer = '/check-answer';
  static const String submitQuiz  = '/quiz/submit';

  // ─── Search ───────────────────────────────────────────────────────────────
  static const String search = '/search';

  // ─── Favorites ────────────────────────────────────────────────────────────
  static const String favorites       = '/favorites';
  static const String favoritesToggle = '/favorites/toggle';

  // ─── Password Reset ────────────────────────────────────────────────────────
  static const String sendOtp    = '/password/send-otp';
  static const String verifyOtp  = '/password/verify-otp';
  static const String resetPassword = '/password/reset';

  // ─── Storage Keys ─────────────────────────────────────────────────────────
  static const String tokenKey       = 'auth_token';
  static const String isLoggedInKey  = 'is_logged_in';
}
