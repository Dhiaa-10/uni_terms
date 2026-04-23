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
    // Wait for 3 seconds
    await Future.delayed(const Duration(seconds: 3));
    
    FlutterNativeSplash.remove();
    
    bool hasSeenOnboarding = await _onboardingRepo.isOnboardingCompleted();
    
    if (_authRepo.isAuthenticated()) {
      Get.offAllNamed('/home');
    } else if (hasSeenOnboarding) {
      Get.offAllNamed('/sign_in');
    } else {
      Get.offAllNamed('/onboarding');
    }
  }
}
