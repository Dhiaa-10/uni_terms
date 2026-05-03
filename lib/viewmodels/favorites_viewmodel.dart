import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/term_model.dart';
import '../repositories/i_favorites_repository.dart';
import '../repositories/api_favorites_repository.dart';
import '../core/api_service.dart';

import '../viewmodels/home_viewmodel.dart';

class FavoritesViewModel extends GetxController {
  final IFavoritesRepository favoritesRepo;
  FavoritesViewModel(this.favoritesRepo);

  var favoriteTerms = <TermModel>[].obs;
  var isLoading     = false.obs;

  // Filtering, Sorting and Search state
  final selectedFilters = <String>[].obs;
  final selectedSort    = 'latest_added'.obs;
  final searchQuery     = ''.obs;
  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // ─── Load ──────────────────────────────────────────────────────────────────

  Future<void> loadFavorites() async {
    if (!Get.find<ApiService>().isAuthenticated) return;
    
    isLoading.value = true;
    final terms = await favoritesRepo.getFavorites();
    
    // Hydrate categories from multiple sources
    if (Get.isRegistered<HomeViewModel>()) {
      final homeVm = Get.find<HomeViewModel>();

      // Build a lookup map from all known terms (by ID → category)
      final knownTerms = <String, String>{};
      for (final t in [...homeVm.latestTerms, ...homeVm.specTerms]) {
        if (t.category.isNotEmpty) knownTerms[t.id] = t.category;
      }

      favoriteTerms.value = terms.map((t) {
        if (t.category.isNotEmpty) return t; // already has a category

        // 1st: look up by specId in the spec map
        if (t.specId != null) {
          final catFromSpec = homeVm.specIdToName[t.specId] ?? '';
          if (catFromSpec.isNotEmpty) return t.copyWith(category: catFromSpec);
        }

        // 2nd: look up by term ID in already-loaded terms
        final catFromCache = knownTerms[t.id] ?? '';
        if (catFromCache.isNotEmpty) return t.copyWith(category: catFromCache);

        return t;
      }).toList();
    } else {
      favoriteTerms.value = terms;
    }
    
    isLoading.value = false;
  }

  // ─── Toggle ────────────────────────────────────────────────────────────────

  Future<void> toggleFavorite(TermModel term) async {
    final termIdInt = int.tryParse(term.id) ?? 0;

    // Snapshot known categories BEFORE backend refresh wipes them
    final categorySnapshot = <String, String>{
      for (final t in favoriteTerms)
        if (t.category.isNotEmpty) t.id: t.category,
    };
    // Also include the term being added (which has the full category from the UI)
    if (term.category.isNotEmpty) categorySnapshot[term.id] = term.category;

    // Optimistic update
    final wasFavorite = isFavorite(term);
    if (wasFavorite) {
      favoriteTerms.removeWhere((t) => t.id == term.id);
    } else {
      favoriteTerms.add(term.copyWith(isFavorite: true));
    }

    // Sync with backend
    await favoritesRepo.toggleFavorite(termIdInt);

    // Refresh from backend, then restore any missing categories from snapshot
    await loadFavorites();

    // Patch: if backend response lost any category tags, restore from snapshot
    favoriteTerms.value = favoriteTerms.map((t) {
      if (t.category.isNotEmpty) return t;
      final saved = categorySnapshot[t.id] ?? '';
      return saved.isNotEmpty ? t.copyWith(category: saved) : t;
    }).toList();
  }

  bool isFavorite(TermModel term) {
    return favoriteTerms.any((t) => t.id == term.id);
  }

  // ─── Filtering & Sorting ───────────────────────────────────────────────────

  void toggleFilter(String majorTitle) {
    if (majorTitle == 'All') {
      selectedFilters.clear();
    } else {
      if (selectedFilters.contains(majorTitle)) {
        selectedFilters.remove(majorTitle);
      } else {
        selectedFilters.add(majorTitle);
      }
    }
  }

  void updateSort(String option) {
    selectedSort.value = option;
  }

  Future<void> deleteAll() async {
    // Toggle each favorite off
    for (final term in List<TermModel>.from(favoriteTerms)) {
      final termIdInt = int.tryParse(term.id) ?? 0;
      await favoritesRepo.toggleFavorite(termIdInt);
    }
    favoriteTerms.clear();
  }

  List<TermModel> get displayList {
    List<TermModel> list = [...favoriteTerms];

    // Reactive Hydration: Ensure categories are mapped as soon as specs are available
    if (Get.isRegistered<HomeViewModel>()) {
      final homeVm = Get.find<HomeViewModel>();
      final mapping = homeVm.specIdToName; // This is reactive
      
      if (mapping.isNotEmpty) {
        list = list.map((t) {
          if (t.category.isEmpty && t.specId != null) {
            final cat = mapping[t.specId] ?? '';
            return cat.isNotEmpty ? t.copyWith(category: cat) : t;
          }
          return t;
        }).toList();
      }
    }

    if (selectedFilters.isNotEmpty) {
      list = list.where((t) => selectedFilters.contains(t.category)).toList();
    }

    if (searchQuery.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      list = list.where((t) =>
          t.title.toLowerCase().contains(query) ||
          t.arabicTranslation.toLowerCase().contains(query)).toList();
    }

    if (selectedSort.value == 'alpha_az') {
      list.sort((a, b) => a.title.compareTo(b.title));
    } else if (selectedSort.value == 'alpha_za') {
      list.sort((a, b) => b.title.compareTo(a.title));
    }

    return list;
  }

  String getTermCategory(TermModel t) {
    if (t.category.isNotEmpty) return t.category;
    
    final sId = t.specId;
    debugPrint('Favorites lookup for term ${t.id}: specId=$sId');
    
    if (sId != null && Get.isRegistered<HomeViewModel>()) {
      final homeVm = Get.find<HomeViewModel>();
      final mapping = homeVm.specIdToName;
      String? result = mapping[sId];
      
      if (result == null || result.isEmpty) {
        for (var s in homeVm.specs) {
          if (s.id.toString() == sId.toString()) {
            result = Get.locale?.languageCode == 'ar' ? s.nameAr : s.name;
            break;
          }
        }
      }
      debugPrint('Favorites lookup result for ${t.id}: $result');
      return result ?? '';
    }
    return '';
  }

  bool get isAllFiltersSelected => selectedFilters.isEmpty;
}
