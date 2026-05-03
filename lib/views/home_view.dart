import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../core/app_colors.dart';
import '../viewmodels/home_viewmodel.dart';
import 'home/widgets/major_card.dart';
import 'home/widgets/horizontal_major_card.dart';
import 'home/widgets/term_list_tile.dart';
import 'terms/term_details_view.dart';
import 'terms/widgets/simple_term_tile.dart';
import '../core/mock_data.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    final HomeViewModel controller = Get.find<HomeViewModel>();

    return Scaffold(
      backgroundColor: AppColors.screenBg,
      body: PopScope(
        canPop: false, // Handle pop manually to support sub-views
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          if (controller.isShowingTerms.value) {
            controller.hideMajorTerms();
          } else if (controller.isShowingAllMajors.value) {
            controller.hideAllMajors();
          } else {
            // If on dashboard, dont call Get.back() as it can cause Navigator Key conflicts
            // if there's no route to go back to.
          }
        },
        child: Obx(() {
          if (controller.isShowingTerms.value) {
            return _buildTermsView(context, controller);
          }
          if (controller.isShowingAllMajors.value) {
            return _buildAllMajorsView(context, controller);
          }
          return _buildDashboard(context, controller);
        }),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, HomeViewModel controller) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildTopSection(context),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                _buildSectionContainer(
                  child: _buildMajorsSection(controller),
                ),
                const SizedBox(height: 24),
                _buildSectionContainer(
                  child: _buildTrendingSection(context, controller),
                ),
                const SizedBox(height: 24),
                _buildSectionContainer(
                  child: _buildLatestTermsSection(context, controller),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.sectionBorder,
          width: 1,
        ),
      ),
      child: child,
    );
  }

  Widget _buildTopSection(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    
    return Container(
      padding: EdgeInsets.fromLTRB(16, statusBarHeight + 16, 16, 32),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SvgPicture.asset(
                    'assets/icons/app_logo.svg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'UniTerms',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontFamily: 'Inter',
                    ),
                  ),
                  Text(
                    'hello_msg'.tr,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.cardBg.withValues(alpha: 0.8),
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSearchBar(context),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        Get.toNamed('/search');
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg.withValues(alpha: 0.3), // Glass-morphic effect
          borderRadius: BorderRadius.circular(16),
        ),
        child: AbsorbPointer(
          child: TextField(
            readOnly: true,
            style: TextStyle(color: AppColors.cardBg),
            decoration: InputDecoration(
              hintText: 'search_terms'.tr,
              hintStyle: TextStyle(
                color: AppColors.cardBg.withValues(alpha: 0.5),
                fontSize: 13,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SvgPicture.asset(
                  'assets/icons/curved_search.svg',
                  colorFilter: const ColorFilter.mode(
                    AppColors.cardBg,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMajorsSection(HomeViewModel controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'my_majors'.tr,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF3B2A51),
                fontFamily: 'Inter',
              ),
            ),
            GestureDetector(
              onTap: () => controller.showAllMajors(),
              child: Text(
                'see_all'.tr,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.headerGradientStart,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Obx(() {
          final majors = controller.dashboardMajors;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: majors.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2, // Increased height to accommodate design
            ),
            itemBuilder: (context, index) {
              final major = majors[index];
              final isArabic = Get.locale?.languageCode == 'ar';
              return MajorCard(
                title: isArabic ? (major['arabicTitle'] ?? major['title']) : major['title'],
                termsCount: major['count']!,
                icon: major['icon'],
                onTap: () => controller.showMajorTerms(major),
              );
            },
          );
        }),
      ],
    );
  }

  Widget _buildTrendingSection(BuildContext context, HomeViewModel controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              'assets/icons/curved_trending_up.svg',
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                AppColors.headerGradientStart,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'most_used_terms'.tr,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF3B2A51),
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.isLoadingLatest.value) {
            return const Center(child: CircularProgressIndicator());
          }
          final trendingTerms = controller.popularTerms;
          if (trendingTerms.isEmpty) {
            return Text('no_results'.tr, style: const TextStyle(color: Colors.grey));
          }
          return Column(
            children: trendingTerms.asMap().entries.map((entry) => TermListTile(
              index: entry.key + 1,
              term: entry.value.title,
              category: controller.getTermCategory(entry.value),
              isNew: entry.value.isNew && !controller.viewedNewTerms.contains(entry.value.id),
              onTap: () {
                controller.markTermAsViewed(entry.value.id);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => TermDetailsView(term: entry.value)),
                );
              },
            )).toList(),
          );
        }),
      ],
    );
  }

  Widget _buildLatestTermsSection(BuildContext context, HomeViewModel controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              'assets/icons/curved_clock.svg',
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                AppColors.headerGradientStart,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'latest_terms'.tr,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF3B2A51),
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.isLoadingLatest.value) {
            return const Center(child: CircularProgressIndicator());
          }
          final latestTerms = controller.latestTerms.take(5).toList();
          if (latestTerms.isEmpty) {
            return Text('no_results'.tr, style: const TextStyle(color: Colors.grey));
          }
          return Column(
            children: latestTerms.asMap().entries.map((entry) => TermListTile(
              index: entry.key + 1,
              term: entry.value.title,
              category: controller.getTermCategory(entry.value),
              isNew: entry.value.isNew && !controller.viewedNewTerms.contains(entry.value.id),
              onTap: () {
                controller.markTermAsViewed(entry.value.id);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => TermDetailsView(term: entry.value)),
                );
              },
            )).toList(),
          );
        }),
      ],
    );
  }

  Widget _buildTermsView(BuildContext context, HomeViewModel controller) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    
    return Container(
      color: AppColors.screenBg, 
      child: Column(
        children: [
          // Premium Header
          Container(
            padding: EdgeInsets.fromLTRB(20, statusBarHeight + 10, 20, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.headerGradientStart,
                  AppColors.headerGradientEnd,
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0),
              ),
            ),
            child: Column(
              children: [
                // Top Row: Back Button and Title
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => controller.hideMajorTerms(),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/icons/curved_back_arrow.svg',
                              width: 24,
                              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Obx(() {
                      final specId = controller.selectedSpecId.value;
                      String title = 'terms'.tr;
                      if (specId != null) {
                        title = controller.specIdToName[specId] ?? controller.selectedMajorTitle.value;
                      }
                      
                      return Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: 'Inter',
                        ),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 24),
                // Search Bar
                _buildTermsSearchBar(controller),
              ],
            ),
          ),
          
          // List of Terms
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Text(
                    'items_count'.trParams({'count': controller.filteredTerms.length.toString()}),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      fontFamily: 'Inter',
                    ),
                  )),
                  const SizedBox(height: 20),
                  // Scrollable List
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoadingTerms.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (controller.filteredTerms.isEmpty) {
                        return Center(child: Text('no_results'.tr));
                      }
                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: controller.filteredTerms.length,
                        itemBuilder: (context, index) {
                          final term = controller.filteredTerms[index];
                          return SimpleTermTile(
                            index: index + 1,
                            term: term,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => TermDetailsView(term: term)),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsSearchBar(HomeViewModel controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        onChanged: controller.updateSearchQuery,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'search_terms'.tr,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: 'Inter',
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
            icon: const Icon(Icons.cancel, color: Colors.white70, size: 20),
            onPressed: () => controller.updateSearchQuery(''), // Logic to clear
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildAllMajorsView(BuildContext context, HomeViewModel controller) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    
    return Column(
      children: [
        // Redesigned Header: Back button + Search bar in one row
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
            borderRadius: BorderRadius.zero,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => controller.hideAllMajors(),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/curved_back_arrow.svg',
                      width: 24,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: controller.majorSearchController,
                    onChanged: controller.updateMajorSearchQuery,
                    onTap: () => controller.isMajorSearchActive.value = true,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      hintText: 'search_majors'.tr,
                      hintStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Inter',
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
                      suffixIcon: Obx(() => controller.majorSearchQuery.isNotEmpty || controller.isMajorSearchActive.value
                          ? IconButton(
                              icon: const Icon(Icons.cancel, color: Colors.white70, size: 20),
                              onPressed: controller.clearMajorSearch,
                            )
                          : const SizedBox.shrink()),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Body: Conditional rendering for Default(All), Empty Search, Found, No Results
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(top: 24),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Obx(() {
              final isActive = controller.isMajorSearchActive.value;
              final query = controller.majorSearchQuery.value;
              final results = controller.filteredMajors;

              // CASE 1: Not searching yet -> Show all majors (sorted)
              if (!isActive) {
                return _buildMajorsResultContainer(controller, controller.filteredMajors);
              }

              // CASE 2: Searching but query is empty -> Show blank (Image 1)
              if (query.isEmpty) {
                return const SizedBox.shrink();
              }

              // CASE 3: No results found (Image 3)
              if (results.isEmpty) {
                return _buildNoResultsState();
              }

              // CASE 4: Search results found (Image 2)
              return _buildMajorsResultContainer(controller, results);
            }),
          ),
        ),
      ],
    );
  }

  // Helper to build the white container with the majors list
  Widget _buildMajorsResultContainer(HomeViewModel controller, List<Map<String, dynamic>> list) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'my_majors'.tr,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF3B2A51).withValues(alpha: 0.5),
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: list.length,
              itemBuilder: (context, index) {
                final major = list[index];
                final isArabic = Get.locale?.languageCode == 'ar';
                final majorTitle = isArabic ? (major['arabicTitle'] ?? major['title']) : major['title'];
                return Obx(() => HorizontalMajorCard(
                  title: majorTitle,
                  termsCount: major['count']!,
                  icon: major['icon'],
                  isPinned: controller.isPinned(major['title']!),
                  onTap: () => controller.showMajorTerms(major),
                  onPinTap: () => controller.togglePin(major['title']!),
                ));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.sectionBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF8E66A2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.search, color: AppColors.cardBg, size: 32),
            ),
            const SizedBox(height: 24),
            Text(
              'no_results'.tr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF3B2A51),
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'no_results_desc'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF3B2A51).withValues(alpha: 0.6),
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
