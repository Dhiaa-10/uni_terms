import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:uniterm/viewmodels/main_viewmodel.dart';
import 'package:uniterm/views/home_view.dart';
import 'package:uniterm/views/favorites/favorites_view.dart';
import 'package:uniterm/views/settings/settings_view.dart';
import 'package:uniterm/views/quiz/quiz_view.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainViewModel());

    final List<Widget> pages = [
      const HomeView(),
      const FavoritesView(),
      const QuizView(),
      const SettingsView(),
    ];

    const Color activeColor = Color(0xFF3A294F);
    const Color inactiveColor = Color(0xFFA197B0);

    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.selectedIndex.value,
            children: pages,
          )),
      bottomNavigationBar: Container(
        height: 75,
        padding: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(controller, 0, 'assets/icons/house.svg', 'home'.tr, activeColor, inactiveColor),
            _buildNavItem(controller, 1, 'assets/icons/heart.svg', 'favorites'.tr, activeColor, inactiveColor),
            _buildNavItem(controller, 2, 'assets/icons/brain.svg', 'quiz'.tr, activeColor, inactiveColor),
            _buildNavItem(controller, 3, 'assets/icons/gear_six.svg', 'settings'.tr, activeColor, inactiveColor),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(MainViewModel controller, int index, String iconPath, String label, Color activeColor, Color inactiveColor) {
    return Obx(() {
      final bool isActive = controller.selectedIndex.value == index;
      final Color color = isActive ? activeColor : inactiveColor;

      return Expanded(
        child: InkWell(
          onTap: () => controller.changeIndex(index),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Purple Dot Indicator ABOVE icon
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 4,
                height: 4,
                margin: const EdgeInsets.only(bottom: 6),
                decoration: BoxDecoration(
                  color: isActive ? activeColor : Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),
              SvgPicture.asset(
                iconPath,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
              if (isActive) ...[
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: activeColor,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }
}
