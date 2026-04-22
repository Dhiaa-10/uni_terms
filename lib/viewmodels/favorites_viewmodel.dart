import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uniterm/models/term_model.dart';
import 'package:uniterm/core/mock_data.dart';

class FavoritesViewModel extends GetxController {
  final _storage = GetStorage();
  var favoriteTerms = <TermModel>[].obs;
  
  // Filtering, Sorting and Search state
  final selectedFilters = <String>[].obs; // Using Major Titles
  final selectedSort = 'latest_added'.obs;
  final searchQuery = ''.obs;
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

  void loadFavorites() {
    List? storedFavs = _storage.read<List>('favorites');
    if (storedFavs != null) {
      favoriteTerms.assignAll(
        MockData.allTerms.where((term) => storedFavs.contains(term.id)).toList()
      );
    }
  }

  void toggleFavorite(TermModel term) {
    if (isFavorite(term)) {
      favoriteTerms.removeWhere((t) => t.id == term.id);
    } else {
      favoriteTerms.add(term);
    }
    _saveToStorage();
  }

  bool isFavorite(TermModel term) {
    return favoriteTerms.any((t) => t.id == term.id);
  }

  void _saveToStorage() {
    _storage.write('favorites', favoriteTerms.map((t) => t.id).toList());
  }

  // --- Filtering & Sorting Logic ---

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

  void deleteAll() {
    favoriteTerms.clear();
    _saveToStorage();
  }

  // Computed list based on favorites + active filters/sort
  List<TermModel> get displayList {
    List<TermModel> list = [...favoriteTerms];

    // Filter by Major
    if (selectedFilters.isNotEmpty) {
      list = list.where((term) => selectedFilters.contains(term.category)).toList();
    }

    // Filter by Search Query
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      list = list.where((term) => 
        term.title.toLowerCase().contains(query) || 
        term.arabicTranslation.toLowerCase().contains(query)
      ).toList();
    }

    // Sort
    if (selectedSort.value == 'alpha_az') {
      list.sort((a, b) => a.title.compareTo(b.title));
    } else if (selectedSort.value == 'alpha_za') {
      list.sort((a, b) => b.title.compareTo(a.title));
    } else {
      // 'latest_added' - assumes the order in favoriteTerms is the order they were added
      // Since it's an observable list, adding to the end is the newest.
    }

    return list;
  }

  bool get isAllFiltersSelected => selectedFilters.isEmpty;
}
