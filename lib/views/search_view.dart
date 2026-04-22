import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../core/app_colors.dart';
import '../viewmodels/search_viewmodel.dart';
import 'terms/term_details_view.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final SearchViewModel controller = Get.put(SearchViewModel());
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF3EDF7), // Light lavender background
      body: Column(
        children: [
          // Header Section
          Container(
            padding: EdgeInsets.fromLTRB(16, statusBarHeight + 16, 16, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.headerGradientStart,
                  AppColors.headerGradientEnd,
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
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
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextField(
                      controller: controller.searchController,
                      onChanged: controller.updateSearchQuery,
                      autofocus: false,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'search_terms'.tr,
                        hintStyle: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 14,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset(
                            'assets/icons/curved_search.svg',
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        suffixIcon: IconButton(
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
                            controller.clearSearch();
                          },
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => _showFilterBottomSheet(context, controller),
                  child: SvgPicture.asset(
                    'assets/icons/curved_filter.svg',
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Filters row (Image 2 Style)
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Obx(() {
              final selectedFilters = [
                if (controller.isPopularOnly.value) 'popular'.tr,
                if (controller.isNewOnly.value) 'new'.tr,
                ...controller.selectedCategories,
                if (controller.isAllSelected && controller.isAllToggled.value) 'all'.tr,
              ];

              if (selectedFilters.isEmpty) return const SizedBox.shrink();

              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: selectedFilters.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filter = selectedFilters[index];
                  return _buildSelectedFilterChip(filter, () {
                    if (filter == 'popular'.tr) {
                      controller.isPopularOnly.value = false;
                    } else if (filter == 'new'.tr) {
                      controller.isNewOnly.value = false;
                    } else if (filter == 'all'.tr) {
                      controller.isAllToggled.value = false;
                    } else {
                      controller.selectedCategories.remove(filter);
                    }
                  });
                },
              );
            }),
          ),

          // Main Search Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Obx(() {
                final query = controller.searchQuery.value;
                final results = controller.searchResults;

                if (query.isEmpty && !controller.isAnyFilterSelected && !controller.isAllToggled.value) {
                  return const SizedBox.shrink(); 
                }

                if (results.isEmpty) {
                  return _buildNoResultsState(); 
                }

                return _buildResultsState(results, query, context); 
              }),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context, SearchViewModel controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF614A81).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/curved_filter.svg',
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(Color(0xFF614A81), BlendMode.srcIn),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'filter'.tr,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3B2A51)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Popular and New Row
              Row(
                children: [
                  Expanded(
                    child: Obx(() => _buildFilterChip(
                      label: 'popular'.tr,
                      isSelected: controller.isPopularOnly.value,
                      onTap: controller.togglePopular,
                      activeColor: const Color(0xFF27C840),
                    )),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(() => _buildFilterChip(
                      label: 'new'.tr,
                      isSelected: controller.isNewOnly.value,
                      onTap: controller.toggleNew,
                      activeColor: const Color(0xFF27C840),
                    )),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // All Button
              SizedBox(
                width: double.infinity,
                child: Obx(() => _buildFilterChip(
                  label: 'all'.tr,
                  isSelected: controller.isAllSelected,
                  onTap: () {
                    controller.resetFilters();
                    Get.back();
                  },
                  activeColor: const Color(0xFF614A81),
                )),
              ),
              const SizedBox(height: 24),
              // Categories Grid
              Obx(() => Wrap(
                spacing: 12,
                runSpacing: 12,
                children: controller.categories.map((cat) {
                  final isSelected = controller.selectedCategories.contains(cat);
                  return SizedBox(
                    width: (MediaQuery.of(context).size.width - 60) / 2,
                    child: _buildFilterChip(
                      label: cat,
                      isSelected: isSelected,
                      onTap: () => controller.toggleCategory(cat),
                      activeColor: const Color(0xFF614A81),
                    ),
                  );
                }).toList(),
              )),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required Color activeColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: activeColor, // Always show the color border (green or purple)
            width: 1.5,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : activeColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedFilterChip(String label, VoidCallback onRemove) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF614A81),
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.cancel, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
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
              decoration: const BoxDecoration(
                color: Color(0xFF614A81),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.search, color: Colors.white, size: 32),
            ),
            const SizedBox(height: 24),
            Text(
              'no_results'.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3B2A51),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'no_results_matching'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF8D64AA),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsState(List results, String query, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF614A81).withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'items_count'.trParams({'count': '${results.length}'}),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3B2A51),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 24),
              itemCount: results.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final term = results[index];
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Get.to(() => TermDetailsView(term: term)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFF1F1F1)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _getHighlightedText(term.title, query),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3EDF7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            term.category,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF8D64AA),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.north_east_rounded, size: 20, color: Color(0xFFB0A4C0)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getHighlightedText(String text, String query) {
    if (query.isEmpty) return Text(text, style: const TextStyle(fontSize: 16, color: Color(0xFF3B2A51)));

    final lowercaseText = text.toLowerCase();
    final lowercaseQuery = query.toLowerCase();
    final index = lowercaseText.indexOf(lowercaseQuery);

    if (index == -1) return Text(text, style: const TextStyle(fontSize: 16, color: Color(0xFF3B2A51)));

    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 16, color: Color(0xFFB0A4C0)), // Lighter color for non-matched
        children: [
          TextSpan(text: text.substring(0, index)),
          TextSpan(
            text: text.substring(index, index + query.length),
            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3B2A51)), // Bold & Dark for matched
          ),
          TextSpan(text: text.substring(index + query.length)),
        ],
      ),
    );
  }
}
