class TermModel {
  final String id;
  final String title;           // English title
  final String arabicTranslation;
  final String definition;      // English definition
  final String arabicDefinition;
  final String category;        // spec name (English)
  final int? specId;
  final String? major;
  final bool isNew;
  final bool isPopular;
  final bool isFavorite;
  final String? example;
  final String? arabicExample;

  final DateTime? createdAt;

  TermModel({
    required this.id,
    required this.title,
    required this.arabicTranslation,
    required this.definition,
    required this.arabicDefinition,
    required this.category,
    this.specId,
    this.major,
    this.isNew = false,
    this.isPopular = false,
    this.isFavorite = false,
    this.example,
    this.arabicExample,
    this.createdAt,
  });

  /// Creates a TermModel from the real backend JSON response.
  factory TermModel.fromJson(Map<String, dynamic> json) {
    // Support both backend keys and the old mock keys for safety
    final rawId = json['id'];
    
    // Find any fallback string if title is missing
    String? fallbackStr;
    json.forEach((k, v) { if (v is String && fallbackStr == null) fallbackStr = v; });

    // Determine if it's new based on created_at if is_new is missing
    bool isActuallyNew = json['is_new'] ?? false;
    DateTime? created;
    if (json['created_at'] != null) {
      try {
        // Handle possible backend date formats
        String dateStr = json['created_at'].toString();
        // If it contains a space but no T, replace space with T for better ISO 8601 parsing
        if (dateStr.contains(' ') && !dateStr.contains('T')) {
          dateStr = dateStr.replaceFirst(' ', 'T');
        }
        created = DateTime.tryParse(dateStr);
      } catch (e) {
        // Ignore parse errors
      }

      if (created != null && !isActuallyNew) {
        // If created in the last 30 days, consider it new
        final now = DateTime.now();
        // .difference can be negative if created is technically in the "future" due to timezone differences
        final diff = now.difference(created).inDays;
        if (diff <= 30) isActuallyNew = true;
      }
    }

    return TermModel(
      id: (json['term_id'] ?? json['id'] ?? rawId)?.toString() ?? '',
      title: json['term_name'] ?? json['title'] ?? json['title_en'] ?? json['name'] ?? fallbackStr ?? '',
      arabicTranslation: json['translation'] ?? json['title_ar'] ?? json['name_ar'] ?? '',
      definition: json['definition'] ?? json['definition_en'] ?? json['desc'] ?? '',
      arabicDefinition: json['definition_ar'] ?? json['arabic_definition'] ?? json['definition'] ?? '',
      category: json['spec']?['name'] ?? json['category'] ?? json['major'] ?? json['spec_name'] ?? '',
      specId: json['spec_id'] is int
          ? json['spec_id']
          : int.tryParse(json['spec_id']?.toString() ?? json['specId']?.toString() ?? ''),
      major: json['major'] ?? json['category'],
      isNew: isActuallyNew,
      isPopular: json['is_popular'] ?? false,
      isFavorite: json['is_favorite'] ?? false,
      example: json['example'] ?? json['example_en'] ?? '',
      arabicExample: json['example_ar'] ?? json['arabic_example'] ?? json['example'] ?? '',
      createdAt: created,
    );
  }

  String get majorName => major ?? category;

  TermModel copyWith({
    bool? isFavorite,
    String? category,
    bool? isNew,
    bool? isPopular,
  }) {
    return TermModel(
      id: id,
      title: title,
      arabicTranslation: arabicTranslation,
      definition: definition,
      arabicDefinition: arabicDefinition,
      category: category ?? this.category,
      specId: specId,
      major: major,
      isNew: isNew ?? this.isNew,
      isPopular: isPopular ?? this.isPopular,
      isFavorite: isFavorite ?? this.isFavorite,
      example: example,
      arabicExample: arabicExample,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'title_ar': arabicTranslation,
      'definition': definition,
      'definition_ar': arabicDefinition,
      'category': category,
      'spec_id': specId,
      'major': major,
      'is_new': isNew,
      'is_popular': isPopular,
      'is_favorite': isFavorite,
      'example': example,
      'example_ar': arabicExample,
    };
  }
}
