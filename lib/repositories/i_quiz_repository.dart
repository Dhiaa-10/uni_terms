import '../models/quiz_level_model.dart';
import '../models/quiz_question_model.dart';

abstract class IQuizRepository {
  /// Returns the quiz levels for the given spec.
  Future<List<QuizLevelModel>> getLevels(int specId);

  /// Returns the questions for the given level.
  Future<List<QuizQuestionModel>> getQuestions(int levelId);

  /// Checks a single answer. Returns [CheckAnswerResponse].
  Future<CheckAnswerResponse?> checkAnswer(int questionId, int optionId);

  /// Submits all answers for a level and returns the result map.
  /// [answers] is { questionId: optionId }
  Future<Map<String, dynamic>?> submitQuiz(
      int levelId, Map<int, int> answers);
}
