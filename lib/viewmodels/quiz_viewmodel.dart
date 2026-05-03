import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/spec_model.dart';
import '../models/quiz_level_model.dart';
import '../models/quiz_question_model.dart';
import '../repositories/i_quiz_repository.dart';
import '../repositories/i_content_repository.dart';
import 'main_viewmodel.dart';

enum QuizViewType { majors, levels, questions, results }

class QuizViewModel extends GetxController {
  final IQuizRepository quizRepo;
  final IContentRepository contentRepo;
  QuizViewModel(this.quizRepo, this.contentRepo);

  final _storage = GetStorage();

  // ─── View state ────────────────────────────────────────────────────────────
  var currentView = QuizViewType.majors.obs;
  var searchQuery = ''.obs;

  // ─── Specs (majors) ────────────────────────────────────────────────────────
  var specs        = <SpecModel>[].obs;
  var isLoadingSpecs = false.obs;

  // ─── Levels ────────────────────────────────────────────────────────────────
  var levels        = <QuizLevelModel>[].obs;
  var isLoadingLevels = false.obs;
  var selectedSpec  = Rxn<SpecModel>();

  // ─── Questions ─────────────────────────────────────────────────────────────
  var questions       = <QuizQuestionModel>[].obs;
  var isLoadingQuestions = false.obs;
  var selectedLevel   = Rxn<QuizLevelModel>();

  // ─── Quiz session state ────────────────────────────────────────────────────
  var currentQuestionIndex = 0.obs;
  var selectedOptionId     = Rxn<int>();   // the chosen option's id
  var isAnswered           = false.obs;
  var isCorrect            = false.obs;
  var correctOptionId      = Rxn<int>();
  var answerMessage        = ''.obs;
  var correctAnswersCount  = 0.obs;
  var totalTrophies        = 0.obs;

  // Stores { questionId: optionId } for submit
  final _sessionAnswers = <int, int>{};

  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    totalTrophies.value = _storage.read('totalTrophies') ?? 0;
    fetchSpecs();
  }

  // ─── Fetch Specs ───────────────────────────────────────────────────────────

  Future<void> fetchSpecs() async {
    isLoadingSpecs.value = true;
    specs.value = await contentRepo.getSpecs();
    isLoadingSpecs.value = false;
    
    // Background fetch counts to match home screen
    _fetchCountsSilently();
  }

  Future<void> _fetchCountsSilently() async {
    for (var i = 0; i < specs.length; i++) {
      if (specs[i].termsCount == 0) {
        final terms = await contentRepo.getTermsBySpec(specs[i].id);
        if (terms.isNotEmpty) {
          specs[i] = specs[i].copyWith(termsCount: terms.length);
        }
      }
    }
  }

  // ─── Search ────────────────────────────────────────────────────────────────

  List<SpecModel> get filteredSpecs {
    if (searchQuery.value.isEmpty) return specs;
    final q = searchQuery.value.toLowerCase();
    return specs.where((s) =>
        s.name.toLowerCase().contains(q) ||
        s.nameAr.contains(searchQuery.value)).toList();
  }

  void updateSearchQuery(String query) => searchQuery.value = query;

  void clearSearch() {
    searchController.clear();
    updateSearchQuery('');
  }

  // ─── Select major (spec) ───────────────────────────────────────────────────

  Future<void> selectSpec(SpecModel spec) async {
    selectedSpec.value = spec;
    currentView.value  = QuizViewType.levels;
    await fetchLevels(spec.id);
  }

  Future<void> fetchLevels(int specId) async {
    isLoadingLevels.value = true;
    levels.value = await quizRepo.getLevels(specId);
    isLoadingLevels.value = false;
  }

  // ─── Start Quiz ────────────────────────────────────────────────────────────

  Future<void> startQuiz(QuizLevelModel level) async {
    if (level.isLocked) return;
    selectedLevel.value = level;
    _sessionAnswers.clear();
    resetQuiz();
    isLoadingQuestions.value = true;
    questions.value = await quizRepo.getQuestions(level.id);
    isLoadingQuestions.value = false;
    currentView.value = QuizViewType.questions;
  }

  void resetQuiz() {
    currentQuestionIndex.value = 0;
    selectedOptionId.value     = null;
    isAnswered.value           = false;
    isCorrect.value            = false;
    correctOptionId.value      = null;
    answerMessage.value        = '';
    correctAnswersCount.value  = 0;
    _sessionAnswers.clear();
  }

  void retryQuiz() {
    resetQuiz();
    currentView.value = QuizViewType.questions;
  }

  // ─── Answer ────────────────────────────────────────────────────────────────

  Future<void> selectOption(int optionId) async {
    if (isAnswered.value) return;
    selectedOptionId.value = optionId;

    final question = questions[currentQuestionIndex.value];
    _sessionAnswers[question.id] = optionId;

    // Call check-answer immediately for instant feedback
    final result = await quizRepo.checkAnswer(question.id, optionId);
    isAnswered.value = true;

    if (result != null) {
      isCorrect.value      = result.isCorrect;
      correctOptionId.value = result.correctOptionId;
      answerMessage.value  = result.message;
      if (result.isCorrect) correctAnswersCount.value++;
    }
  }

  // ─── Navigation ────────────────────────────────────────────────────────────

  Future<void> nextQuestion() async {
    if (currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex.value++;
      selectedOptionId.value  = null;
      isAnswered.value        = false;
      isCorrect.value         = false;
      correctOptionId.value   = null;
      answerMessage.value     = '';
    } else {
      // Submit quiz
      await _submitQuiz();
      currentView.value = QuizViewType.results;
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
      selectedOptionId.value = null;
      isAnswered.value       = false;
      isCorrect.value        = false;
      correctOptionId.value  = null;
      answerMessage.value    = '';
    }
  }

  Future<void> _submitQuiz() async {
    if (selectedLevel.value == null) return;
    final result = await quizRepo.submitQuiz(selectedLevel.value!.id, _sessionAnswers);
    
    if (result != null) {
      // Use backend results if available
      if (result['correct_answers'] != null) {
        correctAnswersCount.value = int.tryParse(result['correct_answers'].toString()) ?? correctAnswersCount.value;
      }
      
      // Update trophies based on points_earned from backend
      final earned = int.tryParse((result['points_earned'] ?? 0).toString()) ?? 0;
      if (earned > 0) {
        saveTrophies(earned);
      }

      // Store pass/fail result and message from backend
      final isPassed = result['is_passed'] ?? false;
      answerMessage.value = result['message'] ?? '';

      // ONLY re-fetch levels if the user passed — this ensures the next level
      // only appears unlocked when the backend actually unlocks it
      if (isPassed && selectedSpec.value != null) {
        await fetchLevels(selectedSpec.value!.id);
      }
    }
  }

  void goBack() {
    if (currentView.value == QuizViewType.results) {
      currentView.value = QuizViewType.levels;
    } else if (currentView.value == QuizViewType.questions) {
      currentView.value = QuizViewType.levels;
    } else if (currentView.value == QuizViewType.levels) {
      currentView.value = QuizViewType.majors;
    } else {
      final mainController = Get.find<MainViewModel>();
      mainController.changeIndex(0);
    }
  }

  // ─── Trophies ──────────────────────────────────────────────────────────────

  void saveTrophies(int amount) {
    totalTrophies.value += amount;
    _storage.write('totalTrophies', totalTrophies.value);
  }

  // ─── Result message ────────────────────────────────────────────────────────

  String get resultMessage {
    if (questions.isEmpty) return '';
    final pct = correctAnswersCount.value / questions.length;
    if (pct == 1.0) return 'nice_progress'.tr;
    if (pct >= 0.6) return 'good_job'.tr;
    return 'keep_practicing'.tr;
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
