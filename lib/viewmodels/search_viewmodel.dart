import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/term_model.dart';
import '../core/mock_data.dart';

class SearchViewModel extends GetxController {
  final searchQuery = ''.obs;
  final searchController = TextEditingController();

  // Multiple filters
  final isPopularOnly = false.obs;
  final isNewOnly = false.obs;
  final selectedCategories = <String>[].obs;
  final isAllToggled = false.obs; // Explicitly show all

  final categories = <String>[].obs;
  final searchResults = <TermModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Load categories from MockData
    categories.value = MockData.majors
        .map((m) => m['title'] as String)
        .toList();

    // Listen to changes in query or any filter
    debounce(
      searchQuery,
      (_) => updateResults(),
      time: const Duration(milliseconds: 300),
    );
    ever(isPopularOnly, (_) => updateResults());
    ever(isNewOnly, (_) => updateResults());
    ever(selectedCategories, (_) => updateResults());
    ever(isAllToggled, (_) => updateResults());
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

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
    isNewOnly.value = false;
    isAllToggled.value = true; // Show all terms
  }

  bool get isAnyFilterSelected =>
      selectedCategories.isNotEmpty || isPopularOnly.value || isNewOnly.value;

  bool get isAllSelected => !isAnyFilterSelected;

  void updateResults() {
    // Show nothing if no interaction yet
    if (searchQuery.isEmpty && !isAnyFilterSelected && !isAllToggled.value) {
      searchResults.clear();
      return;
    }

    final filtered = MockData.terms.where((term) {
      // Search match
      final matchesQuery =
          searchQuery.isEmpty ||
          term.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          term.arabicTranslation.toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          );

      if (!matchesQuery) return false;

      // Filter matches
      if (isPopularOnly.value && !term.isPopular) return false;
      if (isNewOnly.value && !term.isNew) return false;

      if (selectedCategories.isNotEmpty) {
        if (!selectedCategories.contains(term.category) &&
            !selectedCategories.contains(term.major)) {
          return false;
        }
      }

      return true;
    }).toList();

    searchResults.assignAll(filtered);
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    updateResults();
  }
}
