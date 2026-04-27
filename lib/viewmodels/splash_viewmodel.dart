import 'package:get/get.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import '../repositories/i_splash_repository.dart';
import '../repositories/i_onboarding_repository.dart';
import '../repositories/i_auth_repository.dart';

class SplashViewModel extends GetxController {
  final ISplashRepository _splashRepo;
  final IOnboardingRepository _onboardingRepo;
  final IAuthRepository _authRepo;

  SplashViewModel(this._splashRepo, this._onboardingRepo, this._authRepo);

  @override
  void onInit() {
    super.onInit();
    _startNavigationTimer();
  }

  void _startNavigationTimer() async {
    // Show the native blank splash for a short time (1 second)
    await Future.delayed(const Duration(seconds: 1));
    
    // Remove the native splash to reveal the Flutter SplashView
    FlutterNativeSplash.remove();
    
    // Keep the Flutter SplashView (with icon and name) visible for 3 seconds
    await Future.delayed(const Duration(seconds: 3));
    
    if (_authRepo.isAuthenticated()) {
      Get.offAllNamed('/home');
    } else {
      // Always show onboarding if not authenticated, as per user request
      Get.offAllNamed('/onboarding');
    }
  }
}
