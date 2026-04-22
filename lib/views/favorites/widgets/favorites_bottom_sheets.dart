import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:uniterm/core/app_colors.dart';
import 'package:uniterm/core/mock_data.dart';
import 'package:uniterm/viewmodels/favorites_viewmodel.dart';

class FavoritesBottomSheets {
  static void showOptions(BuildContext context, FavoritesViewModel controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: const BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDraggableHandle(),
            const SizedBox(height: 24),
            _buildOptionRow(
              context,
              label: 'filter'.tr,
              value: controller.selectedFilters.isEmpty ? 'all_filters'.tr : '${controller.selectedFilters.length} ${'selected'.tr}',
              icon: 'assets/icons/curved_filter.svg',
              onTap: () {
                Navigator.of(context).pop();
                showFilter(context, controller);
              },
            ),
            const Divider(height: 32),
            _buildOptionRow(
              context,
              label: 'sort_by'.tr,
              value: controller.selectedSort.value.tr,
              icon: 'assets/icons/curved_filter.svg',
              onTap: () {
                Navigator.of(context).pop();
                showSort(context, controller);
              },
            ),
            const Divider(height: 32),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                showDeleteConfirmation(context, controller);
              },
              child: Row(
                children: [
                   const Icon(Icons.delete_outline, color: Colors.red, size: 24),
                   const SizedBox(width: 12),
                   Text(
                     'delete_all_items'.tr,
                     style: const TextStyle(
                       color: Colors.red,
                       fontWeight: FontWeight.w500,
                       fontFamily: 'Inter',
                     ),
                   ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void showSort(BuildContext context, FavoritesViewModel controller) {
    final options = ['latest_added', 'alpha_az', 'alpha_za'];
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: const BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDraggableHandle(),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.sort, color: Color(0xFF3B2A51)),
                const SizedBox(width: 8),
                Text(
                  'sort_by'.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3B2A51),
                    fontFamily: 'Inter',
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () => Navigator.of(ctx).pop(),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.close, size: 20, color: Color(0xFF3B2A51)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ...options.map((option) => Obx(() => _buildSelectionItem(
              label: option.tr,
              isSelected: controller.selectedSort.value == option,
              onTap: () {
                controller.updateSort(option);
                Navigator.of(ctx).pop();
              },
            ))),
          ],
        ),
      ),
    );
  }

  static void showFilter(BuildContext context, FavoritesViewModel controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: const BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDraggableHandle(),
            const SizedBox(height: 24),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/curved_filter.svg',
                  colorFilter: const ColorFilter.mode(Color(0xFF3B2A51), BlendMode.srcIn),
                  width: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'filter'.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3B2A51),
                    fontFamily: 'Inter',
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () => Navigator.of(ctx).pop(),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.close, size: 20, color: Color(0xFF3B2A51)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildFilterButton(
                  label: 'all_filters'.tr,
                  isSelected: controller.selectedFilters.isEmpty,
                  onTap: () => controller.toggleFilter('all_filters'),
                  isFullWidth: true,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: MockData.majors.map((major) => _buildFilterButton(
                    label: major['title']!.tr,
                    isSelected: controller.selectedFilters.contains(major['title']!),
                    onTap: () => controller.toggleFilter(major['title']!),
                  )).toList(),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }

  static void showDeleteConfirmation(BuildContext context, FavoritesViewModel controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              'delete_all_items'.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3B2A51),
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'delete_all_confirm'.tr,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Text(
                      'cancel'.tr,
                      style: const TextStyle(
                        color: Color(0xFF3B2A51),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      controller.deleteAll();
                      Navigator.of(ctx).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: AppColors.cardBg,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.delete_outline, size: 20),
                    label: Text(
                      'delete'.tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  static Widget _buildDraggableHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  static Widget _buildOptionRow(BuildContext context, {required String label, required String value, required String icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            colorFilter: const ColorFilter.mode(Color(0xFF3B2A51), BlendMode.srcIn),
            width: 20,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xFF3B2A51),
              fontFamily: 'Inter',
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.indexCircleDynamic.withValues(alpha: 0.3)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.indexCircleDynamic,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildSelectionItem({required String label, required bool isSelected, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected ? AppColors.indexCircleDynamic : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.indexCircleDynamic : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontFamily: 'Inter',
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check, color: AppColors.indexCircleDynamic, size: 20)
          ],
        ),
      ),
    );
  }

  static Widget _buildFilterButton({required String label, required bool isSelected, required VoidCallback onTap, bool isFullWidth = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: isFullWidth ? double.infinity : null,
        padding: EdgeInsets.symmetric(horizontal: isFullWidth ? 0 : 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF614A81) : AppColors.cardBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? Colors.transparent : const Color(0xFF614A81).withValues(alpha: 0.4),
            width: 1,
          ),
          boxShadow: isSelected ? [
             BoxShadow(
               color: const Color(0xFF614A81).withValues(alpha: 0.2),
               blurRadius: 8,
               offset: const Offset(0, 4),
             )
          ] : null,
        ),
        alignment: isFullWidth ? Alignment.center : null,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.cardBg : const Color(0xFF614A81),
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
