import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'core/app_translations.dart';
import 'core/api_service.dart';

// Repositories — interfaces
import 'repositories/i_splash_repository.dart';
import 'repositories/i_onboarding_repository.dart';
import 'repositories/i_auth_repository.dart';
import 'repositories/i_content_repository.dart';
import 'repositories/i_quiz_repository.dart';
import 'repositories/i_favorites_repository.dart';

// Repositories — mock (kept for onboarding & splash which need no network)
import 'repositories/mock_splash_repository.dart';
import 'repositories/mock_onboarding_repository.dart';

// Repositories — real (API)
import 'repositories/api_auth_repository.dart';
import 'repositories/api_content_repository.dart';
import 'repositories/api_quiz_repository.dart';
import 'repositories/api_favorites_repository.dart';

// ViewModels
import 'viewmodels/splash_viewmodel.dart';
import 'viewmodels/onboarding_viewmodel.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/register_viewmodel.dart';
import 'viewmodels/forget_password_viewmodel.dart';
import 'viewmodels/favorites_viewmodel.dart';
import 'viewmodels/settings_viewmodel.dart';
import 'viewmodels/home_viewmodel.dart';
import 'viewmodels/quiz_viewmodel.dart';
import 'viewmodels/search_viewmodel.dart';

// Views
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

  // await GetStorage().erase(); // Uncomment to reset all local storage

  _setupDependencies();
  runApp(const UnitermApp());
}

void _setupDependencies() {
  // ── Core services ─────────────────────────────────────────────────────────
  Get.put(ApiService(), permanent: true);

  // ── Repositories — permanent ──────────────────────────────────────────────
  Get.put<ISplashRepository>(MockSplashRepository(), permanent: true);
  Get.put<IOnboardingRepository>(MockOnboardingRepository(), permanent: true);

  // Auth: register the real repo as both IAuthRepository AND ApiAuthRepository
  final apiAuthRepo = ApiAuthRepository();
  Get.put<IAuthRepository>(apiAuthRepo, permanent: true);
  Get.put<ApiAuthRepository>(apiAuthRepo, permanent: true);

  Get.put<IContentRepository>(ApiContentRepository(), permanent: true);
  Get.put<IQuizRepository>(ApiQuizRepository(), permanent: true);
  Get.put<IFavoritesRepository>(ApiFavoritesRepository(), permanent: true);

  // ── Global ViewModels ─────────────────────────────────────────────────────
  Get.put(SettingsViewModel(), permanent: true);
  Get.put(
    FavoritesViewModel(Get.find<IFavoritesRepository>()),
    permanent: true,
  );
  Get.put(SearchViewModel(), permanent: true);
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
        settingsVm.currentLanguage.value == 'ar' ? 'SA' : 'US',
      ),
      fallbackLocale: const Locale('en', 'US'),
      theme: ThemeData(useMaterial3: true),
      initialRoute: '/splash',
      getPages: [
        // ── Splash ──────────────────────────────────────────────────────────
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
        // ── Onboarding ──────────────────────────────────────────────────────
        GetPage(
          name: '/onboarding',
          page: () => const OnboardingView(),
          binding: BindingsBuilder(() {
            Get.put(OnboardingViewModel(Get.find<IOnboardingRepository>()));
          }),
        ),
        // ── Sign In ─────────────────────────────────────────────────────────
        GetPage(
          name: '/sign_in',
          page: () => const SignInView(),
          binding: BindingsBuilder(() {
            Get.put(AuthViewModel(Get.find<IAuthRepository>()));
          }),
        ),
        // ── Register ────────────────────────────────────────────────────────
        GetPage(
          name: '/register',
          page: () => const RegisterView(),
          binding: BindingsBuilder(() {
            Get.put(RegisterViewModel(Get.find<IAuthRepository>()));
          }),
        ),
        // ── Forget Password ─────────────────────────────────────────────────
        GetPage(
          name: '/forget_password/email',
          page: () => const ForgetPasswordEmailView(),
          binding: BindingsBuilder(() {
            Get.put(ForgetPasswordViewModel(Get.find<IAuthRepository>()));
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
        // ── Main / Home ─────────────────────────────────────────────────────
        GetPage(
          name: '/home',
          page: () => const MainView(),
          binding: BindingsBuilder(() {
            Get.put(HomeViewModel(Get.find<IContentRepository>()));
            Get.put(QuizViewModel(
              Get.find<IQuizRepository>(),
              Get.find<IContentRepository>(),
            ));
          }),
        ),
        // ── Search ──────────────────────────────────────────────────────────
        GetPage(
          name: '/search',
          page: () => const SearchView(),
        ),
      ],
    );
  }
}
