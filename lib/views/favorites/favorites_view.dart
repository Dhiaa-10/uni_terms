import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/app_colors.dart';
import '../../viewmodels/favorites_viewmodel.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../../viewmodels/main_viewmodel.dart';
import '../terms/term_details_view.dart';
import '../../core/mock_data.dart';

import '../home/widgets/term_list_tile.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoritesViewModel>();
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF3EDF7),
      body: Column(
        children: [
          // Header Section
          Container(
            padding: EdgeInsets.fromLTRB(16, statusBarHeight + 16, 16, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.headerGradientStart, AppColors.headerGradientEnd],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      'my_favorites'.tr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.find<MainViewModel>().changeIndex(0),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(Icons.arrow_back, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextField(
                          controller: controller.searchController,
                          onChanged: (v) => controller.searchQuery.value = v,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'search_terms'.tr,
                            hintStyle: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 14,
                            ),
                            prefixIcon: const Icon(Icons.search, color: Colors.white70, size: 20),
                            prefixIconConstraints: const BoxConstraints(minWidth: 32),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 10),
                            suffixIcon: Obx(() => controller.searchQuery.isNotEmpty 
                              ? IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: SvgPicture.asset(
                                    'assets/icons/curved_close_circle.svg',
                                    width: 24,
                                    height: 24,
                                    colorFilter: const ColorFilter.mode(
                                      Colors.white70,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  onPressed: () {
                                    controller.searchController.clear();
                                    controller.searchQuery.value = '';
                                  },
                                )
                              : const SizedBox.shrink()),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: Obx(() {
              final list = controller.displayList;
              
              if (controller.favoriteTerms.isEmpty) {
                return _buildEmptyState();
              }

              return _buildFavoritesList(context, list, controller);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
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
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF614A81),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.favorite_border, color: Colors.white, size: 32),
            ),
            const SizedBox(height: 24),
            Text(
              'no_favorites_yet'.tr,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3B2A51)),
            ),
            const SizedBox(height: 8),
            Text(
              'start_adding_terms'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Color(0xFF8D64AA)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesList(BuildContext context, List list, FavoritesViewModel controller) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(color: const Color(0xFFE9E0F2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${'saved_terms'.tr} (${list.length})',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF3B2A51)),
              ),
              GestureDetector(
                onTap: () => _showMainOptionsSheet(context, controller),
                child: const Icon(Icons.more_vert, color: Color(0xFF614A81)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 24),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final term = list[index];
                return TermListTile(
                  index: index + 1,
                  term: term.title,
                  category: controller.getTermCategory(term),
                  onTap: () => Get.to(() => TermDetailsView(term: term)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- Bottom Sheets ---

  void _showMainOptionsSheet(BuildContext context, FavoritesViewModel controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHandle(),
            const SizedBox(height: 24),
            _buildOptionRow(
              icon: Icons.filter_alt_outlined,
              title: 'filter'.tr,
              trailing: Obx(() => _buildPill(controller.isAllFiltersSelected ? 'all'.tr : '${controller.selectedFilters.length}')),
              onTap: () {
                Get.back();
                _showFilterSheet(context, controller);
              },
            ),
            const SizedBox(height: 20),
            _buildOptionRow(
              icon: Icons.sort_rounded,
              title: 'sort_by'.tr,
              trailing: Obx(() => _buildPill(_getSortLabel(controller.selectedSort.value))),
              onTap: () {
                Get.back();
                _showSortSheet(context, controller);
              },
            ),
            const SizedBox(height: 20),
            const Divider(color: Color(0xFFF1F1F1)),
            const SizedBox(height: 20),
            _buildOptionRow(
              icon: Icons.delete_outline_rounded,
              title: 'delete_all_items'.tr,
              color: const Color(0xFFFF5E5E),
              onTap: () {
                Get.back();
                _showDeleteWarning(context, controller);
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context, FavoritesViewModel controller) {
    final homeVm = Get.find<HomeViewModel>();
    final majors = homeVm.specs.map((s) => Get.locale?.languageCode == 'ar' ? s.nameAr : s.name).toList();
    
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHandle(),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.filter_alt_outlined, color: Color(0xFF3B2A51)),
                const SizedBox(width: 12),
                Text('filter'.tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3B2A51))),
                const Spacer(),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.arrow_forward_rounded, color: Color(0xFF3B2A51)),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Obx(() => Column(
              children: [
                // All Chip - Full width
                _buildFilterChip(
                  label: 'all'.tr,
                  isSelected: controller.isAllFiltersSelected,
                  onTap: () => controller.toggleFilter('All'),
                  width: double.infinity,
                ),
                const SizedBox(height: 12),
                // Other chips in 2x2 grid
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: majors.map((m) => _buildFilterChip(
                    label: m,
                    isSelected: controller.selectedFilters.contains(m),
                    onTap: () => controller.toggleFilter(m),
                    width: (MediaQuery.of(context).size.width - 60) / 2,
                  )).toList(),
                ),
              ],
            )),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _showSortSheet(BuildContext context, FavoritesViewModel controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHandle(),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.sort_rounded, color: Color(0xFF3B2A51)),
                const SizedBox(width: 12),
                Text('sort_by'.tr, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3B2A51))),
                const Spacer(),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.arrow_forward_rounded, color: Color(0xFF3B2A51)),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSortOption(
              icon: Icons.access_time_rounded,
              label: 'Latest Added',
              id: 'latest_added',
              controller: controller,
            ),
            _buildSortOption(
              icon: Icons.sort_by_alpha_rounded,
              label: 'Alphabetical (A-Z)',
              id: 'alpha_az',
              controller: controller,
            ),
            _buildSortOption(
              icon: Icons.sort_by_alpha_rounded,
              label: 'Alphabetical (Z-A)',
              id: 'alpha_za',
              controller: controller,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _showDeleteWarning(BuildContext context, FavoritesViewModel controller) {
    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFFF3EDF7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.delete_outline_rounded, color: Color(0xFFFF5E5E), size: 32),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'delete_all_confirm_title'.tr,
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3B2A51),
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'delete_all_confirm_desc'.tr,
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF3B2A51),
                            fontWeight: FontWeight.w500,
                            height: 1.3,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Divider(color: const Color(0xFF3B2A51).withOpacity(0.05), thickness: 1),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF614A81),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: Text('cancel'.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    controller.deleteAll();
                    Get.back();
                  },
                  child: Text(
                    'delete'.tr,
                    style: const TextStyle(color: Color(0xFFFF5E5E), fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI Helpers ---

  Widget _buildHandle() {
    return Container(
      width: 48,
      height: 4,
      decoration: BoxDecoration(
        color: const Color(0xFFE9E0F2),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildOptionRow({
    required IconData icon,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
    Color color = const Color(0xFF3B2A51),
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color)),
          const Spacer(),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFB0A4C0)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF614A81)),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    double? width,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        width: width ?? (Get.width - 60) / 2, // Default to grid width if not specified
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF614A81) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : const Color(0xFF614A81).withValues(alpha: 0.2),
            width: 1.5,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: const Color(0xFF614A81).withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 6),
            )
          ] : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF614A81),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildSortOption({
    required IconData icon,
    required String label,
    required String id,
    required FavoritesViewModel controller,
  }) {
    return Obx(() {
      final isSelected = controller.selectedSort.value == id;
      return GestureDetector(
        onTap: () => controller.updateSort(id),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              Icon(icon, color: isSelected ? const Color(0xFF614A81) : const Color(0xFFB0A4C0), size: 22),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? const Color(0xFF614A81) : const Color(0xFFB0A4C0),
                ),
              ),
              const Spacer(),
              if (isSelected)
                const Icon(Icons.check_circle, color: Color(0xFF614A81), size: 24)
              else
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFE9E0F2), width: 2),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  String _getSortLabel(String id) {
    switch (id) {
      case 'latest_added': return 'latest_added'.tr;
      case 'alpha_az': return 'alpha_az'.tr;
      case 'alpha_za': return 'alpha_za'.tr;
      default: return '';
    }
  }
}
