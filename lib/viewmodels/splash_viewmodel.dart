import 'package:get/get.dart';
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
    
    // For now, always go to home as per user request
    // In a real app, we'd check onboarding/auth state here
    Get.offAllNamed('/home');
  }
}
