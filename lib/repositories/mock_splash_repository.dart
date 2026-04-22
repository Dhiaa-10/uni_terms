import 'i_splash_repository.dart'; class MockSplashRepository implements ISplashRepository { @override Future<bool> checkInitialState() async { return true; } }
