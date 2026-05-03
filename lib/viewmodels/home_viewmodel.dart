import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/term_model.dart';
import '../models/spec_model.dart';
import '../repositories/i_content_repository.dart';

class HomeViewModel extends GetxController {
  final IContentRepository contentRepo;
  HomeViewModel(this.contentRepo);

  final _storage = GetStorage();
  
  // Local tracking of term clicks: { "termId": count }
  final _termClicks = <String, int>{}.obs;

  // ─── Data from backend ─────────────────────────────────────────────────────
  var specs = <SpecModel>[].obs;
  var latestTerms = <TermModel>[].obs;
  var specTerms = <TermModel>[].obs;
  var isLoadingSpecs = false.obs;
  var isLoadingLatest = false.obs;
  var isLoadingTerms = false.obs;
  
  // Helper to map specId to its name for display in term tiles
  Map<int, String> get specIdToName => {
    for (var s in specs) s.id : (Get.locale?.languageCode == 'ar' ? s.nameAr : s.name)
  };

  // ─── Search state ──────────────────────────────────────────────────────────
  var termSearchQuery = ''.obs;
  var majorSearchQuery = ''.obs;
  var isMajorSearchActive = false.obs;
  final majorSearchController = TextEditingController();

  // ─── Navigation / View State ───────────────────────────────────────────────
  var isShowingAllMajors = false.obs;
  var isShowingTerms = false.obs;
  var selectedMajorTitle = ''.obs;
  var selectedSpecId = Rxn<int>();

  // ─── Pinned majors (local persistence) ────────────────────────────────────
  var pinnedMajors = <String>[].obs;

  // ─── Viewed state for new terms ───────────────────────────────────────────
  var viewedNewTerms = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    
    // Load saved clicks from storage safely
    try {
      final savedClicks = _storage.read('term_clicks');
      if (savedClicks != null && savedClicks is Map) {
        _termClicks.assignAll(savedClicks.map((key, value) => MapEntry(key.toString(), value as int)));
      }
    } catch (e) {
      debugPrint('Error loading term clicks: $e');
    }

    // Load viewed new terms
    try {
      final savedViewed = _storage.read('viewed_new_terms');
      if (savedViewed != null && savedViewed is List) {
        viewedNewTerms.assignAll(savedViewed.map((e) => e.toString()));
      }
    } catch (e) {
      debugPrint('Error loading viewed terms: $e');
    }

    fetchSpecs().then((_) => fetchLatestTerms());
  }

  void _hydrateCategories() {
    final mapping = specIdToName;
    if (mapping.isEmpty) return;

    latestTerms.value = latestTerms.map((t) {
      if (t.category.isEmpty && t.specId != null) {
        return t.copyWith(category: mapping[t.specId] ?? '');
      }
      return t;
    }).toList();

    specTerms.value = specTerms.map((t) {
      if (t.category.isEmpty && t.specId != null) {
        return t.copyWith(category: mapping[t.specId] ?? '');
      }
      return t;
    }).toList();
  }

  // ─── Fetch from backend ────────────────────────────────────────────────────

  Future<void> fetchSpecs() async {
    isLoadingSpecs.value = true;
    specs.value = await contentRepo.getSpecs();
    _hydrateCategories();
    isLoadingSpecs.value = false;
    
    // Start fetching counts in the background to update the UI
    _fetchCountsSilently();
  }

  Future<void> _fetchCountsSilently() async {
    for (var i = 0; i < specs.length; i++) {
      // Only fetch if count is 0 to save bandwidth
      if (specs[i].termsCount == 0) {
        final terms = await contentRepo.getTermsBySpec(specs[i].id);
        if (terms.isNotEmpty) {
          specs[i] = specs[i].copyWith(termsCount: terms.length);
        }
      }
    }
  }

  Future<void> fetchLatestTerms() async {
    isLoadingLatest.value = true;
    final baseTerms = await contentRepo.getLatestTerms();
    
    // If we have terms, try to hydrate them with full details from their specs
    if (baseTerms.isNotEmpty) {
      final hydratedList = <TermModel>[];
      final Map<int, List<TermModel>> specCache = {};

      for (var term in baseTerms) {
        // Try to find the specId from the term
        final sId = term.specId;
        if (sId != null) {
          try {
            if (!specCache.containsKey(sId)) {
              specCache[sId] = await contentRepo.getTermsBySpec(sId);
            }
            
            final fullTerm = specCache[sId]?.where(
              (t) => t.id.toString() == term.id.toString()
            ).firstOrNull;
            
            if (fullTerm != null) {
              hydratedList.add(fullTerm.copyWith(isNew: term.isNew));
            } else {
              hydratedList.add(term);
            }
          } catch (e) {
            hydratedList.add(term);
          }
        } else {
          hydratedList.add(term);
        }
      }
      latestTerms.value = hydratedList.map<TermModel>((t) {
        if (t.category.isEmpty && t.specId != null) {
          return t.copyWith(category: specIdToName[t.specId] ?? '');
        }
        return t;
      }).toList();
    } else {
      latestTerms.value = [];
    }
    
    isLoadingLatest.value = false;
  }

  Future<void> fetchTermsBySpec(int specId) async {
    isLoadingTerms.value = true;
    final terms = await contentRepo.getTermsBySpec(specId);
    
    // Inject the spec name into each term for display consistency
    final specName = specIdToName[specId] ?? '';
    specTerms.value = terms.map((t) => t.copyWith(category: specName)).toList();
    
    // Update the count in the main specs list
    final index = specs.indexWhere((s) => s.id == specId);
    if (index != -1) {
      specs[index] = specs[index].copyWith(termsCount: terms.length);
    }
    
    isLoadingTerms.value = false;
  }

  // ─── Pinned majors ─────────────────────────────────────────────────────────

  void _loadPins() {
    List? storedPins = _storage.read<List>('pinned_majors');
    if (storedPins != null) {
      pinnedMajors.assignAll(storedPins.cast<String>());
    }
  }

  void _savePins() {
    _storage.write('pinned_majors', pinnedMajors.toList());
  }

  // ─── Dashboard logic ───────────────────────────────────────────────────────

  /// Top 4 specs: pinned first, then the rest.
  List<SpecModel> get dashboardSpecs {
    final pinned = specs.where((s) => pinnedMajors.contains(s.name)).toList();
    final others = specs.where((s) => !pinnedMajors.contains(s.name)).toList();
    return [...pinned, ...others].take(4).toList();
  }

  /// Converts specs to the UI map format expected by existing Home widgets.
  List<Map<String, dynamic>> get dashboardMajors {
    return dashboardSpecs.map((s) => s.toUiMap()).toList();
  }

  // ─── Major management ──────────────────────────────────────────────────────

  void updateMajorSearchQuery(String query) {
    majorSearchQuery.value = query;
    isMajorSearchActive.value = query.isNotEmpty;
  }

  void clearMajorSearch() {
    majorSearchQuery.value = '';
    majorSearchController.clear();
    isMajorSearchActive.value = false;
  }

  List<Map<String, dynamic>> get filteredMajors {
    List<SpecModel> list = [...specs];
    if (majorSearchQuery.isNotEmpty) {
      list = list
          .where(
            (s) =>
                s.name.toLowerCase().contains(
                  majorSearchQuery.value.toLowerCase(),
                ) ||
                s.nameAr.contains(majorSearchQuery.value),
          )
          .toList();
    }
    // Pinned first
    final pinned = list.where((s) => pinnedMajors.contains(s.name)).toList();
    final others = list.where((s) => !pinnedMajors.contains(s.name)).toList();
    return [...pinned, ...others].map((s) => s.toUiMap()).toList();
  }

  bool isPinned(String majorTitle) => pinnedMajors.contains(majorTitle);

  void togglePin(String majorTitle) {
    if (isPinned(majorTitle)) {
      pinnedMajors.remove(majorTitle);
    } else {
      pinnedMajors.add(majorTitle);
    }
    _savePins();
  }

  // ─── View toggles ──────────────────────────────────────────────────────────

  void showAllMajors() => isShowingAllMajors.value = true;
  void hideAllMajors() => isShowingAllMajors.value = false;

  void showMajorTerms(Map<String, dynamic> major) {
    final isArabic = Get.locale?.languageCode == 'ar';
    selectedMajorTitle.value = (isArabic ? (major['arabicTitle'] ?? major['title']) : major['title']) as String? ?? '';
    selectedSpecId.value = major['id'] as int?;
    isShowingTerms.value = true;
    if (selectedSpecId.value != null) {
      fetchTermsBySpec(selectedSpecId.value!);
    }
  }

  void hideMajorTerms() {
    isShowingTerms.value = false;
    selectedMajorTitle.value = '';
    selectedSpecId.value = null;
    specTerms.clear();
  }

  // ─── Term search (local filter on loaded specTerms) ────────────────────────

  void updateSearchQuery(String query) {
    termSearchQuery.value = query;
  }

  List<TermModel> get filteredTerms {
    final baseList = isShowingTerms.value ? specTerms : latestTerms;
    if (termSearchQuery.isEmpty) {
      return isShowingTerms.value ? baseList : [];
    }
    final query = termSearchQuery.value.toLowerCase();
    return baseList
        .where(
          (t) =>
              t.title.toLowerCase().contains(query) ||
              t.arabicTranslation.contains(termSearchQuery.value),
        )
        .toList();
  }

  // ─── Most Used Terms Logic ────────────────────────────────────────────────
  
  List<TermModel> get popularTerms {
    // Combine all available terms to find the most used ones
    final allAvailable = [...latestTerms, ...specTerms];
    if (allAvailable.isEmpty) return [];

    // Filter to only those that have at least one click
    final usedTerms = allAvailable.where((t) => (_termClicks[t.id] ?? 0) > 0).toList();
    
    // Remove duplicates by ID
    final uniqueUsed = { for (var t in usedTerms) t.id : t }.values.toList();

    // Sort by click count descending
    uniqueUsed.sort((a, b) {
      final clicksA = _termClicks[a.id] ?? 0;
      final clicksB = _termClicks[b.id] ?? 0;
      return clicksB.compareTo(clicksA);
    });

    return uniqueUsed.take(5).toList();
  }

  void trackTermClick(TermModel term) {
    final currentCount = _termClicks[term.id] ?? 0;
    _termClicks[term.id] = currentCount + 1;
    
    // Persist to storage
    _storage.write('term_clicks', Map<String, int>.from(_termClicks));
    
    // Refresh the popular terms list
    _termClicks.refresh();
  }

  void markTermAsViewed(String termId) {
    if (!viewedNewTerms.contains(termId)) {
      viewedNewTerms.add(termId);
      _storage.write('viewed_new_terms', viewedNewTerms.toList());
    }
  }

  String getTermCategory(TermModel t) {
    if (t.category.isNotEmpty) return t.category;
    
    final sId = t.specId;
    if (sId != null) {
      // Robust lookup: try int key first, then string key if needed
      final mapping = specIdToName;
      String? result = mapping[sId];
      
      if (result == null || result.isEmpty) {
        // Fallback for case where types might be mixed
        for (var s in specs) {
          if (s.id.toString() == sId.toString()) {
            result = Get.locale?.languageCode == 'ar' ? s.nameAr : s.name;
            break;
          }
        }
      }
      return result ?? '';
    }
    return '';
  }

  @override
  void onClose() {
    majorSearchController.dispose();
    super.onClose();
  }
}
