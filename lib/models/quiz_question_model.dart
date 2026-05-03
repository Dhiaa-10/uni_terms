class QuizOptionModel {
  final int id;
  final String text;
  final String? textAr;

  QuizOptionModel({
    required this.id,
    required this.text,
    this.textAr,
  });

  factory QuizOptionModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['option_id'] ?? json['id'];
    return QuizOptionModel(
      id: rawId is int ? rawId : int.tryParse(rawId?.toString() ?? '0') ?? 0,
      text: json['option_text'] ?? json['text'] ?? json['option'] ?? '',
      textAr: json['option_text_ar'] ?? json['text_ar'] ?? json['option_ar'] ?? json['text'],
    );
  }
}

class QuizQuestionModel {
  final int id;
  final String question;
  final String? questionAr;
  final int levelId;
  final List<QuizOptionModel> options;
  final int? correctOptionId;  // Only provided after answering

  QuizQuestionModel({
    required this.id,
    required this.question,
    this.questionAr,
    required this.levelId,
    required this.options,
    this.correctOptionId,
  });

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    final optionsList = (json['options'] as List<dynamic>? ?? [])
        .map((o) => QuizOptionModel.fromJson(o as Map<String, dynamic>))
        .toList();

    final rawId = json['question_id'] ?? json['id'];
    return QuizQuestionModel(
      id: rawId is int ? rawId : int.tryParse(rawId?.toString() ?? '0') ?? 0,
      question: json['question_text'] ?? json['question'] ?? json['text'] ?? '',
      questionAr: json['question_text_ar'] ?? json['question_ar'] ?? json['text_ar'],
      levelId: json['level_id'] is int
          ? json['level_id']
          : int.tryParse(json['level_id']?.toString() ?? '0') ?? 0,
      options: optionsList,
      correctOptionId: json['correct_option_id'] is int
          ? json['correct_option_id']
          : int.tryParse(json['correct_option_id']?.toString() ?? ''),
    );
  }
}

/// Response returned by /api/check-answer
/// { "status": true, "is_correct": false, "correct_option_id": 29, "message": "إجابة خاطئة!" }
class CheckAnswerResponse {
  final bool status;
  final bool isCorrect;
  final int correctOptionId;
  final String message;

  CheckAnswerResponse({
    required this.status,
    required this.isCorrect,
    required this.correctOptionId,
    required this.message,
  });

  factory CheckAnswerResponse.fromJson(Map<String, dynamic> json) {
    return CheckAnswerResponse(
      status: json['status'] ?? false,
      isCorrect: json['is_correct'] ?? false,
      correctOptionId: json['correct_option_id'] is int
          ? json['correct_option_id']
          : int.tryParse(json['correct_option_id']?.toString() ?? '0') ?? 0,
      message: json['message'] ?? '',
    );
  }
}
