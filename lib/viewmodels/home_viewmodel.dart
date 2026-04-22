import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uniterm/models/term_model.dart';
import 'package:uniterm/core/mock_data.dart';

class HomeViewModel extends GetxController {
  final _storage = GetStorage();
  
  // Search state
  var termSearchQuery = ''.obs;
  var majorSearchQuery = ''.obs;
  var isMajorSearchActive = false.obs;
  final majorSearchController = TextEditingController();

  // Navigation / View State
  var isShowingAllMajors = false.obs;
  var isShowingTerms = false.obs;
  var selectedMajorTitle = ''.obs;

  // Pinned majors (persistence)
  var pinnedMajors = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadPins();
  }

  void _loadPins() {
    List? storedPins = _storage.read<List>('pinned_majors');
    if (storedPins != null) {
      pinnedMajors.assignAll(storedPins.cast<String>());
    }
  }

  void _savePins() {
    _storage.write('pinned_majors', pinnedMajors.toList());
  }

  // Dashboard logic
  List<Map<String, dynamic>> get dashboardMajors {
    List<Map<String, dynamic>> all = MockData.majors;
    List<Map<String, dynamic>> pinned = all.where((m) => pinnedMajors.contains(m['title'])).toList();
    List<Map<String, dynamic>> others = all.where((m) => !pinnedMajors.contains(m['title'])).toList();
    return [...pinned, ...others].take(4).toList();
  }

  // Major Management
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
    List<Map<String, dynamic>> list = MockData.majors;
    if (majorSearchQuery.isNotEmpty) {
      list = list.where((m) => 
        (m['title'] as String).toLowerCase().contains(majorSearchQuery.value.toLowerCase()) ||
        (m['arabicTitle'] as String).contains(majorSearchQuery.value)
      ).toList();
    }
    
    // Sort: pinned first
    List<Map<String, dynamic>> pinned = list.where((m) => pinnedMajors.contains(m['title'] as String)).toList();
    List<Map<String, dynamic>> others = list.where((m) => !pinnedMajors.contains(m['title'] as String)).toList();
    return [...pinned, ...others];
  }

  bool isPinned(String majorTitle) {
    return pinnedMajors.contains(majorTitle);
  }

  void togglePin(String majorTitle) {
    if (isPinned(majorTitle)) {
      pinnedMajors.remove(majorTitle);
    } else {
      pinnedMajors.add(majorTitle);
    }
    _savePins();
  }

  // View toggles
  void showAllMajors() => isShowingAllMajors.value = true;
  void hideAllMajors() => isShowingAllMajors.value = false;

  void showMajorTerms(String majorTitle) {
    selectedMajorTitle.value = majorTitle;
    isShowingTerms.value = true;
  }

  void hideMajorTerms() {
    isShowingTerms.value = false;
    selectedMajorTitle.value = '';
  }

  // Term Data for specific major
  List<TermModel> get majorTerms {
    if (selectedMajorTitle.isEmpty) return [];
    // Important: Use title for matching as it's the key in MockData.majors
    return MockData.allTerms.where((t) => t.category == selectedMajorTitle.value).toList();
  }

  // Term Search
  void updateSearchQuery(String query) {
    termSearchQuery.value = query;
  }

  // Final filtered list used by the UI
  List<TermModel> get filteredTerms {
    List<TermModel> baseList = isShowingTerms.value ? majorTerms : MockData.allTerms;
    
    if (termSearchQuery.isEmpty) {
      return isShowingTerms.value ? baseList : []; // Don't show everything in global search if empty
    }

    final query = termSearchQuery.value.toLowerCase();
    return baseList.where((t) => 
      t.title.toLowerCase().contains(query) || 
      t.arabicTranslation.contains(termSearchQuery.value)
    ).toList();
  }
}
