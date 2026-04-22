import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'core/app_translations.dart';
import 'repositories/i_splash_repository.dart';
import 'repositories/mock_splash_repository.dart';
import 'repositories/i_onboarding_repository.dart';
import 'repositories/mock_onboarding_repository.dart';
import 'repositories/i_auth_repository.dart';
import 'repositories/mock_auth_repository.dart';
import 'viewmodels/splash_viewmodel.dart';
import 'viewmodels/onboarding_viewmodel.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/register_viewmodel.dart';
import 'viewmodels/forget_password_viewmodel.dart';
import 'viewmodels/favorites_viewmodel.dart';
import 'viewmodels/settings_viewmodel.dart';
import 'views/splash_view.dart';
import 'views/onboarding_view.dart';
import 'views/sign_in_view.dart';
import 'views/register_view.dart';

import 'views/forget_password/forget_password_email_view.dart';
import 'views/forget_password/forget_password_otp_view.dart';
import 'views/forget_password/forget_password_reset_view.dart';
import 'views/main/main_view.dart';
import 'views/search_view.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  
  await GetStorage.init();

  // await GetStorage().erase();

  _setupDependencies();
  runApp(const UnitermApp());
}

void _setupDependencies() {
  // Repositories — permanent so they survive route changes
  Get.put<ISplashRepository>(MockSplashRepository(), permanent: true);
  Get.put<IOnboardingRepository>(MockOnboardingRepository(), permanent: true);
  Get.put<IAuthRepository>(MockAuthRepository(), permanent: true);

  // Global ViewModels
  Get.put(SettingsViewModel(), permanent: true);
  Get.put(FavoritesViewModel(), permanent: true);
}

class UnitermApp extends StatelessWidget {
  const UnitermApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsVm = Get.find<SettingsViewModel>();
    return GetMaterialApp(
      title: 'UniTerms',
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      locale: Locale(
        settingsVm.currentLanguage.value, 
        settingsVm.currentLanguage.value == 'ar' ? 'SA' : 'US'
      ),
      fallbackLocale: const Locale('en', 'US'),
      theme: ThemeData(
        useMaterial3: true,
      ),
      initialRoute: '/splash',
      getPages: [
        GetPage(
          name: '/splash',
          page: () => const SplashView(),
          binding: BindingsBuilder(() {
            Get.put(SplashViewModel(
              Get.find<ISplashRepository>(),
              Get.find<IOnboardingRepository>(),
              Get.find<IAuthRepository>(),
            ));
          }),
        ),
        GetPage(
          name: '/onboarding',
          page: () => const OnboardingView(),
          binding: BindingsBuilder(() {
            Get.put(OnboardingViewModel(
              Get.find<IOnboardingRepository>(),
            ));
          }),
        ),
        GetPage(
          name: '/sign_in',
          page: () => const SignInView(),
          binding: BindingsBuilder(() {
            Get.put(AuthViewModel(
              Get.find<IAuthRepository>(),
            ));
          }),
        ),
        GetPage(
          name: '/register',
          page: () => const RegisterView(),
          binding: BindingsBuilder(() {
            Get.put(RegisterViewModel(
              Get.find<IAuthRepository>(),
            ));
          }),
        ),
        GetPage(
          name: '/forget_password/email',
          page: () => const ForgetPasswordEmailView(),
          binding: BindingsBuilder(() {
            Get.put(ForgetPasswordViewModel(
              Get.find<IAuthRepository>(),
            ));
          }),
        ),
        GetPage(
          name: '/forget_password/otp',
          page: () => const ForgetPasswordOtpView(),
        ),
        GetPage(
          name: '/forget_password/reset',
          page: () => const ForgetPasswordResetView(),
        ),
        GetPage(
          name: '/home',
          page: () => const MainView(),
        ),
        GetPage(
          name: '/search',
          page: () => const SearchView(),
        ),
      ],
    );
  }
}
