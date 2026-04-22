import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniterm/viewmodels/main_viewmodel.dart';
import '../../core/app_colors.dart';
import '../../viewmodels/settings_viewmodel.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsViewModel>();
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFEFE7F5),
      body: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.fromLTRB(16, statusBarHeight + 8, 16, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.headerGradientStart, AppColors.headerGradientEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Get.find<MainViewModel>().changeIndex(0),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'settings'.tr,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Appearance Section
                  _buildSection(
                    title: 'appearance'.tr,
                    icon: Icons.wb_sunny_outlined,
                    children: [
                      _buildSettingItem(
                        title: 'light_mode'.tr,
                        subtitle: 'switch_theme_desc'.tr,
                        icon: Icons.wb_sunny_outlined,
                        trailing: Obx(() => Transform.scale(
                          scale: 0.8,
                          child: Switch(
                                value: !controller.isDarkMode.value,
                                onChanged: (val) => controller.toggleDarkMode(!val),
                                activeColor: const Color(0xFF614A81),
                              ),
                        )),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Language Section
                  _buildSection(
                    title: 'language'.tr,
                    icon: Icons.language_outlined,
                    children: [
                      _buildSettingItem(
                        title: 'language'.tr,
                        subtitle: 'choose_lang_desc'.tr,
                        icon: Icons.language_outlined,
                        trailing: Obx(() => GestureDetector(
                              onTap: () => _showLanguageDialog(context, controller),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF614A81),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.language_outlined, color: Colors.white, size: 18),
                                    const SizedBox(width: 6),
                                    Text(
                                      controller.currentLanguage.value.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ],
                                ),
                              ))),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // About Section
                  _buildSection(
                    title: 'about'.tr,
                    icon: Icons.info_outline_rounded,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'version'.tr,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3B2950),
                                fontFamily: 'Inter',
                              ),
                            ),
                            const Text(
                              '1.0.0',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF8D64AA),
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: OutlinedButton(
                          onPressed: () => controller.showLogoutConfirmation(context),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFFF5B5B)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            minimumSize: const Size(double.infinity, 54),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.logout_rounded, color: Color(0xFFFF5B5B), size: 22),
                              const SizedBox(width: 8),
                              Text(
                                'logout'.tr,
                                style: const TextStyle(
                                  color: Color(0xFFFF5B5B),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE9E0F2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF8D64AA), size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3B2950),
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF3EDF7),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE9E0F2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFF614A81), size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3B2950),
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF8D64AA),
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, SettingsViewModel controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'language'.tr,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF3B2950)),
            ),
            const SizedBox(height: 24),
            _buildLanguageOption(
              label: 'English',
              code: 'en',
              current: controller.currentLanguage.value,
              onTap: () {
                controller.changeLanguage('en');
                Get.back();
              },
            ),
            const SizedBox(height: 12),
            _buildLanguageOption(
              label: 'العربية',
              code: 'ar',
              current: controller.currentLanguage.value,
              onTap: () {
                controller.changeLanguage('ar');
                Get.back();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required String label,
    required String code,
    required String current,
    required VoidCallback onTap,
  }) {
    bool isSelected = code == current;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF5F0F9) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF614A81) : const Color(0xFFE9E0F2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: const Color(0xFF3B2950),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xFF614A81)),
          ],
        ),
      ),
    );
  }
}
