import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniterm/core/app_colors.dart';
import 'package:uniterm/models/term_model.dart';
import 'package:uniterm/viewmodels/favorites_viewmodel.dart';
import 'package:uniterm/viewmodels/term_details_viewmodel.dart';

class TermDetailsView extends StatelessWidget {
  final TermModel term;
  const TermDetailsView({super.key, required this.term});

  @override
  Widget build(BuildContext context) {
    final favoritesVm = Get.find<FavoritesViewModel>();
    final detailsVm = Get.put(TermDetailsViewModel());

    return Scaffold(
      backgroundColor: AppColors.onboardingBg,
      body: Column(
        children: [
          // Custom Header
          _buildHeader(favoritesVm),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                children: [
                  // Translation Card
                  _buildTranslationCard(detailsVm),
                  const SizedBox(height: 20),
                  
                  // Content Cards (Definition & Example)
                  Obx(() {
                    final isEng = detailsVm.isEnglishFirst.value;
                    return Column(
                      children: [
                        // Academic Definition Card
                        _buildContentCard(
                          title: isEng ? 'academic_definition'.tr : 'academic_definition'.tr,
                          content: isEng ? term.definition : term.arabicDefinition,
                          iconData: Icons.menu_book_outlined,
                          onCopy: () => detailsVm.copyToClipboard(
                            isEng ? term.definition : term.arabicDefinition, 
                            isEng ? 'definition'.tr : 'definition'.tr
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // Example Card
                        _buildContentCard(
                          title: isEng ? 'example'.tr : 'example'.tr,
                          content: (isEng ? term.example : term.arabicExample) ?? '', 
                          iconData: Icons.lightbulb_outline_rounded,
                          onCopy: () => detailsVm.copyToClipboard(
                            (isEng ? term.example : term.arabicExample) ?? '', 
                            isEng ? 'example'.tr : 'example'.tr
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(FavoritesViewModel favoritesVm) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.headerGradientStart,
            AppColors.headerGradientEnd,
          ],
        ),
      ),
      child: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Back Button
            Positioned(
              left: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => Get.back(),
                ),
              ),
            ),
            
            // Title
            Text(
              'term_details'.tr,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontFamily: 'Inter',
              ),
            ),
            
            // Favorite Button
            Positioned(
              right: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Obx(() {
                  final isFav = favoritesVm.isFavorite(term);
                  return IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.white,
                      size: 24,
                    ),
                    onPressed: () => favoritesVm.toggleFavorite(term),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTranslationCard(TermDetailsViewModel detailsVm) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          // Header of card
          Row(
            children: [
              Icon(
                Icons.language_rounded,
                size: 24,
                color: AppColors.subtitleColor,
              ),
              const SizedBox(width: 8),
              Text(
                'translation'.tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  fontFamily: 'Inter',
                ),
              ),
              const Spacer(),
              // Speaker Icon
              _buildIconButton(Icons.volume_up_rounded, () {}, hasBg: true),
              const SizedBox(width: 8),
              // Copy Icon
              _buildIconButton(
                Icons.copy_all_outlined, 
                () => detailsVm.copyToClipboard(
                  detailsVm.isEnglishFirst.value ? term.title : term.arabicTranslation, 
                  'term'.tr
                ), 
                hasBg: false
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // English - Arabic Row
          Obx(() => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.sectionBorder),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        detailsVm.isEnglishFirst.value ? 'english'.tr : 'arabic'.tr,
                        key: ValueKey(detailsVm.isEnglishFirst.value),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.subtitleColor,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.swap_horiz_rounded,
                        color: AppColors.subtitleColor,
                        size: 24,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => detailsVm.toggleLanguage(),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        detailsVm.isEnglishFirst.value ? 'arabic'.tr : 'english'.tr,
                        key: ValueKey(!detailsVm.isEnglishFirst.value),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.subtitleColor,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  crossFadeState: detailsVm.isEnglishFirst.value 
                      ? CrossFadeState.showFirst 
                      : CrossFadeState.showSecond,
                  firstChild: Row(
                    children: [
                      Expanded(
                        child: Text(
                          term.title,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          term.arabicTranslation,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ],
                  ),
                  secondChild: Row(
                    children: [
                      Expanded(
                        child: Text(
                          term.arabicTranslation,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          term.title,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildContentCard({
    required String title,
    required String content,
    required IconData iconData,
    required VoidCallback onCopy,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.sectionBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                iconData,
                size: 24,
                color: AppColors.subtitleColor,
              ),
              const SizedBox(width: 8),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  title,
                  key: ValueKey(title),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              const Spacer(),
              _buildIconButton(Icons.copy_all_outlined, onCopy, hasBg: false),
            ],
          ),
          const SizedBox(height: 16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              content,
              key: ValueKey(content),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
                height: 1.6,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData iconData, VoidCallback onPressed, {bool hasBg = true}) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: hasBg ? const Color(0xFFD9D9D9).withOpacity(0.5) : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          iconData,
          size: hasBg ? 18 : 22,
          color: AppColors.subtitleColor,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
