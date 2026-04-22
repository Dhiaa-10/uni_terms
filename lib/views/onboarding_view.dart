import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodels/onboarding_viewmodel.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final OnboardingViewModel controller = Get.find<OnboardingViewModel>();
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF3EDF7), // Light purple background from design
      body: Column(
        children: [
          SizedBox(height: statusBarHeight + 16),
          // Top Header: Skip and Language
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: controller.skip,
                  child: Text(
                    'skip'.tr,
                    style: const TextStyle(
                      color: Color(0xFF614A81),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: controller.toggleLanguage,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF614A81).withValues(alpha: 0.3)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.language,
                          color: Color(0xFF614A81),
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          Get.locale?.languageCode == 'ar' ? 'AR' : 'EN',
                          style: const TextStyle(
                            color: Color(0xFF614A81),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 48),

          // Main Card Swiper & Dots
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 380,
                  child: PageView.builder(
                    controller: controller.pageController,
                    onPageChanged: controller.onPageChanged,
                    itemCount: controller.pages.length,
                    itemBuilder: (context, index) {
                      final page = controller.pages[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                        child: Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: const Color(0xFF614A81).withValues(alpha: 0.5), width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                page.title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3B2A51),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                page.subtitle,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF614A81),
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 32),
                              ...page.features.map((feature) => Padding(
                                    padding: const EdgeInsets.only(bottom: 16.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF27C840).withValues(alpha: 0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.check_circle,
                                            color: Color(0xFF27C840),
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            feature,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF3B2A51),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                const SizedBox(height: 32),

                // Pagination Dots
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        controller.pages.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: controller.currentIndex.value == index
                                ? const Color(0xFF3B2A51)
                                : Colors.white,
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),

          // Bottom Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Obx(() => Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: controller.nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF614A81),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          controller.currentIndex.value == controller.pages.length - 1
                              ? 'get_started'.tr
                              : 'next'.tr,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    if (controller.currentIndex.value > 0) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton(
                          onPressed: controller.previousPage,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: const Color(0xFF614A81).withValues(alpha: 0.3)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'previous'.tr,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF614A81),
                            ),
                          ),
                        ),
                      ),
                    ] else
                      // Add an invisible placeholder to keep layout stable when 'Previous' is hidden
                      const SizedBox(height: 68), 
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
