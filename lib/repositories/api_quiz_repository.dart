import 'package:get/get.dart';
import '../core/api_constants.dart';
import '../core/api_service.dart';
import '../models/quiz_level_model.dart';
import '../models/quiz_question_model.dart';
import 'i_quiz_repository.dart';

class ApiQuizRepository implements IQuizRepository {
  final ApiService _api = Get.find<ApiService>();

  @override
  Future<List<QuizLevelModel>> getLevels(int specId) async {
    final response = await _api.get(ApiConstants.specLevels(specId));
    if (!response.success || response.data == null) return [];

    List list;
    if (response.data is List) {
      list = response.data as List;
    } else if (response.data is Map) {
      final data = response.data as Map<String, dynamic>;
      final inner = data['data'] ?? data;
      if (inner is List) {
        list = inner;
      } else if (inner is Map) {
        list = (inner['levels'] ?? inner['data'] ?? inner['items'] ?? []) as List;
      } else {
        list = [];
      }
    } else {
      return [];
    }

    return list
        .map((e) => QuizLevelModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<QuizQuestionModel>> getQuestions(int levelId) async {
    final response = await _api.get(ApiConstants.levelQuestions(levelId));
    if (!response.success || response.data == null) return [];

    List list;
    if (response.data is List) {
      list = response.data as List;
    } else if (response.data is Map) {
      final data = response.data as Map<String, dynamic>;
      final inner = data['data'] ?? data;
      if (inner is List) {
        list = inner;
      } else if (inner is Map) {
        list = (inner['questions'] ?? inner['items'] ?? inner['results'] ?? []) as List;
      } else {
        list = [];
      }
    } else {
      return [];
    }

    return list
        .map((e) => QuizQuestionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<CheckAnswerResponse?> checkAnswer(
      int questionId, int optionId) async {
    final response = await _api.post(ApiConstants.checkAnswer, body: {
      'question_id': questionId,
      'option_id': optionId,
    });

    if (response.success && response.data != null) {
      return CheckAnswerResponse.fromJson(
          response.data as Map<String, dynamic>);
    }
    return null;
  }

  @override
  Future<Map<String, dynamic>?> submitQuiz(
      int levelId, Map<int, int> answers) async {
    // Convert {questionId: optionId} to {"questionId": optionId} string-keyed map
    final answersPayload = answers.map(
      (qId, oId) => MapEntry(qId.toString(), oId),
    );

    final response = await _api.post(ApiConstants.submitQuiz, body: {
      'level_id': levelId,
      'answers': answersPayload,
    });

    if (response.success && response.data != null) {
      return response.data as Map<String, dynamic>;
    }
    return null;
  }
}
