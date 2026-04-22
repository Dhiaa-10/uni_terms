import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../core/mock_data.dart';
import 'main_viewmodel.dart';

enum QuizViewType { majors, levels, questions, results }

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });
}

class QuizViewModel extends GetxController {
  final _storage = GetStorage();
  
  var currentView = QuizViewType.majors.obs;
  var searchQuery = ''.obs;
  var selectedMajor = Rxn<Map<String, dynamic>>();
  var selectedLevel = 0.obs;
  
  // Quiz Session State
  var currentQuestionIndex = 0.obs;
  var selectedOptionIndex = (-1).obs;
  var isAnswered = false.obs;
  var quizQuestions = <QuizQuestion>[].obs;
  var correctAnswersCount = 0.obs;
  var totalTrophies = 0.obs;

  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    totalTrophies.value = _storage.read('totalTrophies') ?? 0;
  }

  void saveTrophies(int amount) {
    totalTrophies.value += amount;
    _storage.write('totalTrophies', totalTrophies.value);
  }

  List<Map<String, dynamic>> get filteredMajors {
    if (searchQuery.value.isEmpty) {
      return MockData.majors;
    }
    return MockData.majors.where((major) {
      final title = major['title'].toString().toLowerCase();
      final arabicTitle = major['arabicTitle'].toString().toLowerCase();
      final query = searchQuery.value.toLowerCase();
      return title.contains(query) || arabicTitle.contains(query);
    }).toList();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void clearSearch() {
    searchController.clear();
    updateSearchQuery('');
  }

  void selectMajor(Map<String, dynamic> major) {
    selectedMajor.value = major;
    currentView.value = QuizViewType.levels;
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

  bool isLevelLocked(int levelIndex) {
    return levelIndex > 0;
  }

  void startQuiz(int levelIndex) {
    if (isLevelLocked(levelIndex)) return;
    
    selectedLevel.value = levelIndex + 1;
    _loadMockQuestions();
    resetQuiz();
    currentView.value = QuizViewType.questions;
  }

  void resetQuiz() {
    currentQuestionIndex.value = 0;
    selectedOptionIndex.value = -1;
    isAnswered.value = false;
    correctAnswersCount.value = 0;
  }

  void retryQuiz() {
    resetQuiz();
    currentView.value = QuizViewType.questions;
  }

  void _loadMockQuestions() {
    quizQuestions.value = [
      QuizQuestion(
        question: "What is an Algorithm?",
        options: [
          "A programming language",
          "A step-by-step method for solving problems",
          "A type of computer hardware",
          "A software application"
        ],
        correctAnswerIndex: 1,
      ),
      QuizQuestion(
        question: "What does HTML stand for?",
        options: [
          "Hyper Text Markup Language",
          "High Tech Modern Language",
          "Hyperlink and Text Management",
          "Home Tool Markup Language"
        ],
        correctAnswerIndex: 0,
      ),
      QuizQuestion(
        question: "Which data structure follows FIFO?",
        options: [
          "Stack",
          "Tree",
          "Queue",
          "Graph"
        ],
        correctAnswerIndex: 2,
      ),
    ];
  }

  void selectOption(int index) {
    if (isAnswered.value) return;
    selectedOptionIndex.value = index;
    isAnswered.value = true;
    
    if (index == quizQuestions[currentQuestionIndex.value].correctAnswerIndex) {
      correctAnswersCount.value++;
    }
  }

  void nextQuestion() {
    if (currentQuestionIndex.value < quizQuestions.length - 1) {
      currentQuestionIndex.value++;
      selectedOptionIndex.value = -1;
      isAnswered.value = false;
    } else {
      // Award 10 trophies for each correct answer
      saveTrophies(correctAnswersCount.value * 10);
      currentView.value = QuizViewType.results;
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
      selectedOptionIndex.value = -1;
      isAnswered.value = false;
    }
  }

  String get resultMessage {
    double percentage = correctAnswersCount.value / quizQuestions.length;
    if (percentage == 1.0) return 'nice_progress'.tr;
    if (percentage >= 0.6) return 'good_job'.tr;
    return 'keep_practicing'.tr;
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
