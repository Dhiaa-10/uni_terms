class QuizLevelModel {
  final int id;
  final String name;
  final String? nameAr;
  final int order;
  final bool isLocked;
  final int? specId;

  QuizLevelModel({
    required this.id,
    required this.name,
    this.nameAr,
    this.order = 0,
    this.isLocked = false,
    this.specId,
  });

  factory QuizLevelModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['level_id'] ?? json['id'];
    return QuizLevelModel(
      id: rawId is int ? rawId : int.tryParse(rawId?.toString() ?? '0') ?? 0,
      name: json['level_name'] ?? json['name'] ?? json['title'] ?? 'Level',
      nameAr: json['name_ar'] ?? json['title_ar'] ?? json['arabic_name'],
      order: json['level_order'] ?? json['order'] ?? 0,
      isLocked: !(json['is_unlocked'] ?? true),
      specId: json['spec_id'] is int
          ? json['spec_id']
          : int.tryParse(json['spec_id']?.toString() ?? ''),
    );
  }
}
