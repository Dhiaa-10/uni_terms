class TermModel {
  final String id;
  final String title; // English title
  final String arabicTranslation;
  final String definition; // English definition
  final String arabicDefinition;
  final String category;
  final String? major;
  final bool isNew;
  final bool isPopular;
  final String? example;
  final String? arabicExample;

  TermModel({
    required this.id,
    required this.title,
    required this.arabicTranslation,
    required this.definition,
    required this.arabicDefinition,
    required this.category,
    this.major,
    this.isNew = false,
    this.isPopular = false,
    this.example,
    this.arabicExample,
  });

  factory TermModel.fromJson(Map<String, dynamic> json) {
    return TermModel(
      id: json['id'],
      title: json['title'],
      arabicTranslation: json['arabicTranslation'],
      definition: json['definition'],
      arabicDefinition: json['arabicDefinition'],
      category: json['category'],
      major: json['major'],
      isNew: json['isNew'] ?? false,
      isPopular: json['isPopular'] ?? false,
      example: json['example'],
      arabicExample: json['arabicExample'],
    );
  }

  String get majorName => major ?? category;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'arabicTranslation': arabicTranslation,
      'definition': definition,
      'arabicDefinition': arabicDefinition,
      'category': category,
      'major': major,
      'isNew': isNew,
      'isPopular': isPopular,
      'example': example,
      'arabicExample': arabicExample,
    };
  }
}
