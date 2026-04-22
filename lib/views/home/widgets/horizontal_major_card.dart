import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/app_colors.dart';
import 'package:get/get.dart';

class HorizontalMajorCard extends StatelessWidget {
  final String title;
  final String termsCount;
  final dynamic icon; // Can be String (Path) or IconData
  final bool isPinned;
  final VoidCallback onTap;
  final VoidCallback onPinTap;

  const HorizontalMajorCard({
    super.key,
    required this.title,
    required this.termsCount,
    required this.icon,
    required this.isPinned,
    required this.onTap,
    required this.onPinTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 110,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.headerGradientStart,
              Color(0xFF3B2A51),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3B2A51).withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Center Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon is IconData
                      ? Icon(
                          icon as IconData,
                          size: 28,
                          color: Colors.white,
                        )
                      : SvgPicture.asset(
                          icon as String,
                          width: 28,
                          height: 28,
                          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                        ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "$termsCount ${'terms'.tr}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.7),
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            // Pin Icon (Top Right)
            Positioned(
              top: 12,
              right: 12,
              child: GestureDetector(
                onTap: onPinTap,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: SvgPicture.asset(
                    isPinned ? 'assets/icons/curved_pin_slash.svg' : 'assets/icons/curved_pin.svg',
                    width: 18,
                    height: 18,
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
