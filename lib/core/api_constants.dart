import 'dart:io';

class ApiConstants {
  // ─── Device IP Configuration ───────────────────────────────────────────────
  //
  // ⚠️  REAL DEVICE SETUP:
  //     Replace the value below with your PC's local IP address.
  //     To find it: run `ipconfig` on Windows → look for "IPv4 Address"
  //     Example: '192.168.1.5'
  //
  static const String _realDeviceIp = '192.168.0.42';

  // ─── Base URL (auto-selected) ──────────────────────────────────────────────
  static String get baseUrl {
    final host = _resolveHost();
    return 'http://$host:8000/api';
  }

  static String _resolveHost() {
    if (Platform.isAndroid) {
      // Android emulators route 10.0.2.2 → host machine's localhost
      // Real Android devices need the actual PC IP on the LAN
      return _isAndroidEmulator() ? '10.0.2.2' : _realDeviceIp;
    } else if (Platform.isIOS) {
      // iOS simulators share the Mac's localhost directly
      // Real iOS devices need the actual Mac IP on the LAN
      return _isIOSSimulator() ? '127.0.0.1' : _realDeviceIp;
    }
    // Fallback for desktop (Windows/macOS/Linux) — direct localhost
    return '127.0.0.1';
  }

  /// Detects Android emulator by checking for the emulator-specific
  /// build fingerprint value in the platform environment.
  static bool _isAndroidEmulator() {
    try {
      // The ANDROID_SDK_ROOT or ANDROID_EMULATOR env vars are set in emulators
      // but a more reliable approach is checking known emulator hostname patterns
      final hostname = Platform.environment['HOSTNAME'] ?? '';
      final androidRoot = Platform.environment['ANDROID_ROOT'] ?? '';
      // Emulators typically have 'generic' in their paths or specific env vars
      if (hostname.contains('generic') ||
          hostname.contains('emulator') ||
          androidRoot.contains('generic')) {
        return true;
      }
      // Additional check: emulators often have ANDROID_EMULATOR set
      if (Platform.environment.containsKey('ANDROID_EMULATOR_HOME')) {
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Detects iOS Simulator via the SIMULATOR_DEVICE_NAME environment variable
  /// which is always set in Xcode simulators.
  static bool _isIOSSimulator() {
    try {
      return Platform.environment.containsKey('SIMULATOR_DEVICE_NAME');
    } catch (_) {
      return false;
    }
  }

  // ─── Auth ─────────────────────────────────────────────────────────────────
  static const String register = '/register';
  static const String login = '/login';
  static const String logout = '/logout';
  static const String profile = '/profile';

  // ─── Content ──────────────────────────────────────────────────────────────
  static const String specs = '/specs';
  static const String latestTerms = '/terms/latest';
  static String specTerms(int specId) => '/specs/$specId/terms';

  // ─── Quizzes ──────────────────────────────────────────────────────────────
  static String specLevels(int specId) => '/specs/$specId/levels';
  static String levelQuestions(int levelId) => '/levels/$levelId/questions';
  static const String checkAnswer = '/check-answer';
  static const String submitQuiz = '/quiz/submit';

  // ─── Search ───────────────────────────────────────────────────────────────
  static const String search = '/search';

  // ─── Favorites ────────────────────────────────────────────────────────────
  static const String favorites = '/favorites';
  static const String favoritesToggle = '/favorites/toggle';

  // ─── Password Reset ────────────────────────────────────────────────────────
  static const String sendOtp = '/password/send-otp';
  static const String verifyOtp = '/password/verify-otp';
  static const String resetPassword = '/password/reset';

  // ─── Storage Keys ─────────────────────────────────────────────────────────
  static const String tokenKey = 'auth_token';
  static const String isLoggedInKey = 'is_logged_in';
}
