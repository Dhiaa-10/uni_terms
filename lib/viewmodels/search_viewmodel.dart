import 'dart:math';
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
  final isAllToggled = false.obs;

  final categories = <String>[].obs;
  final searchResults = <TermModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    categories.value = MockData.majors
        .map((m) => m['title'] as String)
        .toList();

    debounce(
      searchQuery,
      (_) => updateResults(),
      time: const Duration(milliseconds: 250),
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
    isAllToggled.value = true;
  }

  bool get isAnyFilterSelected =>
      selectedCategories.isNotEmpty || isPopularOnly.value || isNewOnly.value;

  bool get isAllSelected => !isAnyFilterSelected;

  // ─────────────────────────────────────────────────────────────────────────────
  // Arabic normalisation
  // ─────────────────────────────────────────────────────────────────────────────
  /// Normalises Arabic text so that differences in tashkeel (diacritics) and
  /// alef variants don't prevent a match.
  ///
  /// Rules applied:
  ///   1. Remove tashkeel (U+064B–U+065F and tatweel U+0640)
  ///   2. Normalise all alef variants → ا  (ء أ إ آ ا → ا)
  ///   3. Normalise teh marbuta → ه
  ///   4. Normalise alef maqsura → ي
  String _normaliseArabic(String text) {
    // 1. Remove tashkeel & tatweel
    text = text.replaceAll(RegExp(r'[\u064B-\u065F\u0640]'), '');
    // 2. Normalise alef variants
    text = text.replaceAll(RegExp(r'[أإآء]'), 'ا');
    // 3. Teh marbuta → heh
    text = text.replaceAll('ة', 'ه');
    // 4. Alef maqsura → ya
    text = text.replaceAll('ى', 'ي');
    return text;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Cross-keyboard layout mapping (Windows Arabic 101 ↔ QWERTY)
  // ─────────────────────────────────────────────────────────────────────────────
  /// Maps each QWERTY key to its corresponding Arabic character in the
  /// standard Windows Arabic (101) keyboard layout.
  static const Map<String, String> _englishToArabic = {
    'q': 'ض', 'w': 'ص', 'e': 'ث', 'r': 'ق', 't': 'ف',
    'y': 'غ', 'u': 'ع', 'i': 'ه', 'o': 'خ', 'p': 'ح',
    'a': 'ش', 's': 'س', 'd': 'ي', 'f': 'ب', 'g': 'ل',
    'h': 'ا', 'j': 'ت', 'k': 'ن', 'l': 'م',
    'z': 'ئ', 'x': 'ء', 'c': 'ؤ', 'v': 'ر', 'b': 'لا',
    'n': 'ى', 'm': 'ة', ',': 'و', '.': 'ز', ';': 'ك',
  };

  /// The reverse map: Arabic character → its QWERTY key position.
  static final Map<String, String> _arabicToEnglish = {
    for (final entry in _englishToArabic.entries) entry.value: entry.key,
  };

  /// Converts [text] by swapping each character according to the opposite
  /// keyboard layout.  If the text is mostly Latin it tries Arabic→English;
  /// if it is mostly Arabic it tries English→Arabic.  Characters with no
  /// mapping are kept as-is.
  String _swapKeyboardLayout(String text) {
    if (text.isEmpty) return text;

    // Detect dominant script by counting mapped characters.
    int latinCount = 0;
    int arabicCount = 0;
    for (final ch in text.characters) {
      if (_englishToArabic.containsKey(ch)) latinCount++;
      if (_arabicToEnglish.containsKey(ch)) arabicCount++;
    }

    final map = latinCount >= arabicCount ? _englishToArabic : _arabicToEnglish;
    final buffer = StringBuffer();
    for (final ch in text.characters) {
      buffer.write(map[ch] ?? ch);
    }
    return buffer.toString();
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Main search logic
  // ─────────────────────────────────────────────────────────────────────────────

  void updateResults() {
    if (searchQuery.isEmpty && !isAnyFilterSelected && !isAllToggled.value) {
      searchResults.clear();
      return;
    }

    // Apply hard filters first (popular / new / category)
    var pool = MockData.terms.where((term) {
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

    final rawQuery = searchQuery.value.trim();
    if (rawQuery.isEmpty) {
      searchResults.assignAll(pool);
      return;
    }

    // Split the query into tokens → each token must match somewhere in the term.
    // This enables Google-style multi-word queries:
    //   "mach lea" → ["mach", "lea"] both must match "Machine Learning"
    final queryTokens = rawQuery
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .toList();

    final scores = <String, int>{}; // lower score = better match

    final matched = pool.where((term) {
      // Searchable text surfaces: English title + Arabic translation (normalised)
      final enTitle = term.title.toLowerCase();
      final arTitle = _normaliseArabic(term.arabicTranslation.toLowerCase());

      // Each query token must match at least one of the text surfaces.
      // We also try the layout-swapped version to support users who forgot
      // to switch their keyboard language (e.g. typing Arabic layout on
      // an English term, or vice versa).
      for (final token in queryTokens) {
        final normToken = _normaliseArabic(token); // harmless for English
        final swappedToken = _swapKeyboardLayout(token);
        final normSwapped = _normaliseArabic(swappedToken);

        final enScore  = min(_scoreToken(token,        enTitle), _scoreToken(swappedToken,  enTitle));
        final arScore  = min(_scoreToken(normToken,    arTitle), _scoreToken(normSwapped,   arTitle));
        final bestScore = min(enScore, arScore);

        if (bestScore == 999) { return false; } // this token didn't match → reject term
      }

      // All tokens matched → compute overall relevance score for sorting.
      int totalScore = 0;
      for (final token in queryTokens) {
        final normToken    = _normaliseArabic(token);
        final swappedToken = _swapKeyboardLayout(token);
        final normSwapped  = _normaliseArabic(swappedToken);

        final enScore = min(_scoreToken(token,     enTitle), _scoreToken(swappedToken, enTitle));
        final arScore = min(_scoreToken(normToken, arTitle), _scoreToken(normSwapped,  arTitle));
        totalScore += min(enScore, arScore);
      }
      scores[term.id] = totalScore;
      return true;
    }).toList();

    // Sort by relevance: lower score = better match (exact first, then prefix, then fuzzy)
    matched.sort((a, b) => (scores[a.id] ?? 999).compareTo(scores[b.id] ?? 999));
    searchResults.assignAll(matched);
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Relevance scoring — 5-tier system (lower = better)
  // ─────────────────────────────────────────────────────────────────────────────
  //
  // Tier 0 → Exact substring match   ("algorithm" contains "algor")         score = 0
  // Tier 1 → Exact word prefix        ("algo" is prefix of word "algorithm") score = 1
  // Tier 2 → Fuzzy prefix (1 typo)    ("algr" ≈ "algo")                     score = 2
  // Tier 3 → Fuzzy prefix (2 typos)   ("alxr" ≈ "algo")                     score = 3
  // Tier 4 → Fuzzy word-level match   falls back to sliding-window distance  score = 4+distance
  // 999    → No match
  //
  int _scoreToken(String token, String target) {
    if (token.isEmpty) return 0;

    // Tier 0: exact substring
    if (target.contains(token)) return 0;

    final targetWords = target.split(RegExp(r'\s+'));
    int bestScore = 999;

    for (final word in targetWords) {
      if (word.isEmpty) continue;

      // --- Prefix-based scoring ---
      if (word.length >= token.length) {
        final prefix = word.substring(0, token.length);
        final prefixDist = _levenshteinDistance(token, prefix);

        if (prefixDist == 0) {
          // Tier 1: exact prefix
          if (bestScore > 1) bestScore = 1;
        } else if (prefixDist == 1) {
          // Tier 2: prefix with 1 typo (allowed for queries ≥ 3 chars)
          if (token.length >= 3 && bestScore > 2) bestScore = 2;
        } else if (prefixDist == 2) {
          // Tier 3: prefix with 2 typos (allowed for queries ≥ 5 chars)
          if (token.length >= 5 && bestScore > 3) bestScore = 3;
        }
      }

      // --- Sliding-window fuzzy scoring (covers mid-word & short words) ---
      final windowLen = min(token.length, word.length);
      for (int start = 0; start <= word.length - windowLen; start++) {
        final sub = word.substring(start, start + windowLen);
        final dist = _levenshteinDistance(token, sub);
        final maxAllowed = token.length > 4 ? 2 : (token.length > 2 ? 1 : 0);
        if (dist <= maxAllowed) {
          final score = 4 + dist;
          if (score < bestScore) bestScore = score;
        }
      }
    }

    return bestScore;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Levenshtein distance (Wagner–Fischer)
  // ─────────────────────────────────────────────────────────────────────────────
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

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    updateResults();
  }
}
