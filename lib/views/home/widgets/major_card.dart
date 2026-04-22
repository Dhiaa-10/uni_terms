import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../core/app_colors.dart';

class MajorCard extends StatelessWidget {
  final String title;
  final String termsCount;
  final dynamic icon; // Can be String (Path) or IconData
  final VoidCallback onTap;

  const MajorCard({
    super.key,
    required this.title,
    required this.termsCount,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.headerGradientStart,
              AppColors.headerGradientEnd,
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon centered in the top/middle area
            Expanded(
              child: Center(
                child: icon is IconData
                    ? Icon(
                        icon as IconData,
                        size: 40,
                        color: Colors.white,
                      )
                    : SvgPicture.asset(
                        icon as String,
                        width: 48,
                        height: 48,
                        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      ),
              ),
            ),
            // Text group at the bottom
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Inter',
                  ),
                ),
                Text(
                  "$termsCount ${'terms'.tr}",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.8),
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
