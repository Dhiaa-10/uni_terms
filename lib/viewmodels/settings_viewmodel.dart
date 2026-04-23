import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../repositories/i_auth_repository.dart';

class SettingsViewModel extends GetxController {
  final _storage = GetStorage();
  
  var currentLanguage = 'en'.obs;
  var isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Load saved settings
    currentLanguage.value = _storage.read('language') ?? 'en';
    isDarkMode.value = _storage.read('isDarkMode') ?? false;
  }

  void changeLanguage(String langCode) {
    currentLanguage.value = langCode;
    _storage.write('language', langCode);
    
    Locale locale = langCode == 'ar' 
        ? const Locale('ar', 'SA') 
        : const Locale('en', 'US');
    Get.updateLocale(locale);
  }

  void toggleDarkMode(bool value) {
    isDarkMode.value = value;
    _storage.write('isDarkMode', value);
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  void showLogoutConfirmation(BuildContext context) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'logout_confirm_title'.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3B2950),
                  fontFamily: 'Inter',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'logout_confirm_subtitle'.tr,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF8D64AA),
                  fontFamily: 'Inter',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF614A81),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'cancel'.tr,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextButton(
                      onPressed: logout,
                      child: Text(
                        'logout_now'.tr,
                        style: const TextStyle(
                          color: Color(0xFFFF5B5B),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void logout() async {
    final authRepo = Get.find<IAuthRepository>();
    await authRepo.logout();
    Get.offAllNamed('/sign_in');
  }
}
