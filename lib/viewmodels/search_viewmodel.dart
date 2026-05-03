import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_viewmodel.dart';
import '../models/term_model.dart';
import '../core/api_constants.dart';
import '../core/api_service.dart';

class SearchViewModel extends GetxController {
  final searchQuery      = ''.obs;
  final searchController = TextEditingController();
  final isLoading        = false.obs;

  // Multiple filters
  final isPopularOnly      = false.obs;
  final isNewOnly          = false.obs;
  final selectedCategories = <String>[].obs;
  final isAllToggled       = false.obs;

  final categories    = <String>[].obs;
  final searchResults = <TermModel>[].obs;

  // Spec id for filtering (null = all specs)
  int? _selectedSpecId;

  late final ApiService _api;

  @override
  void onInit() {
    super.onInit();
    _api = Get.find<ApiService>();

    debounce(
      searchQuery,
      (_) => _fetchFromApi(),
      time: const Duration(milliseconds: 400),
    );
    ever(isPopularOnly,      (_) => _fetchFromApi());
    ever(isNewOnly,          (_) => _fetchFromApi());
    ever(selectedCategories, (_) => _fetchFromApi());
    ever(isAllToggled,       (_) => _fetchFromApi());
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // ─── Setters used by Home / filter UI ──────────────────────────────────────

  void setSpecId(int? specId) {
    _selectedSpecId = specId;
  }

  void setCategories(List<String> cats) {
    categories.assignAll(cats);
  }

  // ─── Filters ───────────────────────────────────────────────────────────────

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    if (query.isNotEmpty) isAllToggled.value = true;
  }

  void toggleCategory(String category) {
    isAllToggled.value = true;
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
  }

  void togglePopular() {
    isAllToggled.value = true;
    isPopularOnly.value = !isPopularOnly.value;
  }

  void toggleNew() {
    isAllToggled.value = true;
    isNewOnly.value = !isNewOnly.value;
  }

  void resetFilters() {
    selectedCategories.clear();
    isPopularOnly.value = false;
    isNewOnly.value     = false;
    isAllToggled.value  = true;
  }

  bool get isAnyFilterSelected =>
      selectedCategories.isNotEmpty || isPopularOnly.value || isNewOnly.value;

  bool get isAllSelected => !isAnyFilterSelected;

  // ─── API call ──────────────────────────────────────────────────────────────

  Future<void> _fetchFromApi() async {
    if (searchQuery.isEmpty && !isAnyFilterSelected && !isAllToggled.value) {
      searchResults.clear();
      return;
    }

    isLoading.value = true;

    final params = <String, String>{
      if (searchQuery.isNotEmpty) 'query': searchQuery.value.trim(),
      if (_selectedSpecId != null) 'spec_id': _selectedSpecId.toString(),
    };

    final response = await _api.get(ApiConstants.search, queryParams: params);
    isLoading.value = false;

    if (!response.success || response.data == null) {
      searchResults.clear();
      return;
    }

    final data = response.data as Map<String, dynamic>;
    final list =
        (data['data'] ?? data['results'] ?? data['terms'] ?? data['items'] ?? response.data) as List? ?? [];
    var results = list
        .map((e) => TermModel.fromJson(e as Map<String, dynamic>))
        .toList();

    // Hydrate categories from HomeViewModel's spec mapping
    if (Get.isRegistered<HomeViewModel>()) {
      final homeVm = Get.find<HomeViewModel>();
      final mapping = homeVm.specIdToName;
      results = results.map((t) {
        if (t.category.isEmpty && t.specId != null) {
          final cat = mapping[t.specId] ?? '';
          return cat.isNotEmpty ? t.copyWith(category: cat) : t;
        }
        return t;
      }).toList();
    }

    // Client-side filters (popular/new) if backend doesn't support them
    if (isPopularOnly.value) {
      results = results.where((t) => t.isPopular).toList();
    }
    if (isNewOnly.value) {
      results = results.where((t) => t.isNew).toList();
    }

    searchResults.assignAll(results);
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    searchResults.clear();
    isAllToggled.value = false;
  }

  // ─── Arabic normalisation (kept for any client-side use) ───────────────────
  String _normaliseArabic(String text) {
    text = text.replaceAll(RegExp(r'[\u064B-\u065F\u0640]'), '');
    text = text.replaceAll(RegExp(r'[أإآء]'), 'ا');
    text = text.replaceAll('ة', 'ه');
    text = text.replaceAll('ى', 'ي');
    return text;
  }

  static const Map<String, String> _englishToArabic = {
    'q': 'ض', 'w': 'ص', 'e': 'ث', 'r': 'ق', 't': 'ف',
    'y': 'غ', 'u': 'ع', 'i': 'ه', 'o': 'خ', 'p': 'ح',
    'a': 'ش', 's': 'س', 'd': 'ي', 'f': 'ب', 'g': 'ل',
    'h': 'ا', 'j': 'ت', 'k': 'ن', 'l': 'م',
    'z': 'ئ', 'x': 'ء', 'c': 'ؤ', 'v': 'ر', 'b': 'لا',
    'n': 'ى', 'm': 'ة', ',': 'و', '.': 'ز', ';': 'ك',
  };

  static final Map<String, String> _arabicToEnglish = {
    for (final entry in _englishToArabic.entries) entry.value: entry.key,
  };

  String _swapKeyboardLayout(String text) {
    if (text.isEmpty) return text;
    int latinCount = 0;
    int arabicCount = 0;
    for (final ch in text.characters) {
      if (_englishToArabic.containsKey(ch)) latinCount++;
      if (_arabicToEnglish.containsKey(ch)) arabicCount++;
    }
    final map =
        latinCount >= arabicCount ? _englishToArabic : _arabicToEnglish;
    final buffer = StringBuffer();
    for (final ch in text.characters) {
      buffer.write(map[ch] ?? ch);
    }
    return buffer.toString();
  }

  // Levenshtein kept for potential future use
  int _levenshteinDistance(String s, String t) {
    if (s == t) return 0;
    if (s.isEmpty) return t.length;
    if (t.isEmpty) return s.length;
    final v0 = List<int>.generate(t.length + 1, (i) => i);
    final v1 = List<int>.filled(t.length + 1, 0);
    for (int i = 0; i < s.length; i++) {
      v1[0] = i + 1;
      for (int j = 0; j < t.length; j++) {
        final cost = (s[i] == t[j]) ? 0 : 1;
        v1[j + 1] = min(min(v1[j] + 1, v0[j + 1] + 1), v0[j] + cost);
      }
      for (int j = 0; j < v0.length; j++) {
        v0[j] = v1[j];
      }
    }
    return v1[t.length];
  }
}
