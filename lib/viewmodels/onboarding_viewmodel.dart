import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../repositories/i_onboarding_repository.dart';

class OnboardingPageData {
  final String title;
  final String subtitle;
  final List<String> features;

  OnboardingPageData({
    required this.title,
    required this.subtitle,
    required this.features,
  });
}

class OnboardingViewModel extends GetxController {
  final IOnboardingRepository _onboardingRepo;
  
  OnboardingViewModel(this._onboardingRepo);

  final PageController pageController = PageController();
  final currentIndex = 0.obs;

  List<OnboardingPageData> get pages => [
        OnboardingPageData(
          title: 'onboarding_1_title'.tr,
          subtitle: 'onboarding_1_subtitle'.tr,
          features: [
            'onboarding_1_feature_1'.tr,
            'onboarding_1_feature_2'.tr,
            'onboarding_1_feature_3'.tr,
          ],
        ),
        OnboardingPageData(
          title: 'onboarding_2_title'.tr,
          subtitle: 'onboarding_2_subtitle'.tr,
          features: [
            'onboarding_2_feature_1'.tr,
            'onboarding_2_feature_2'.tr,
            'onboarding_2_feature_3'.tr,
          ],
        ),
        OnboardingPageData(
          title: 'onboarding_3_title'.tr,
          subtitle: 'onboarding_3_subtitle'.tr,
          features: [
            'onboarding_3_feature_1'.tr,
            'onboarding_3_feature_2'.tr,
            'onboarding_3_feature_3'.tr,
          ],
        ),
        OnboardingPageData(
          title: 'onboarding_4_title'.tr,
          subtitle: 'onboarding_4_subtitle'.tr,
          features: [
            'onboarding_4_feature_1'.tr,
            'onboarding_4_feature_2'.tr,
            'onboarding_4_feature_3'.tr,
          ],
        ),
      ];

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  void nextPage() {
    if (currentIndex.value < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      getStarted();
    }
  }

  void previousPage() {
    if (currentIndex.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skip() {
    getStarted();
  }

  void getStarted() {
    _onboardingRepo.completeOnboarding();
    Get.offAllNamed('/sign_in');
  }

  void toggleLanguage() {
    if (Get.locale?.languageCode == 'ar') {
      Get.updateLocale(const Locale('en', 'US'));
    } else {
      Get.updateLocale(const Locale('ar', 'SA'));
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
