/// Represents a Spec (تخصص) from the backend.
class SpecModel {
  final int id;
  final String name;     // English name
  final String nameAr;   // Arabic name
  final int termsCount;

  SpecModel({
    required this.id,
    required this.name,
    required this.nameAr,
    this.termsCount = 0,
  });

  factory SpecModel.fromJson(Map<String, dynamic> json) {
    // Try to find ANY string field to use as a fallback name
    String? fallbackName;
    json.forEach((key, value) {
      if (value is String && fallbackName == null && value.isNotEmpty) {
        fallbackName = value;
      }
    });

    final rawId = json['spec_id'] ?? json['id'] ?? json['specId'];
    final name = json['spec_name'] ?? json['name'] ?? json['title'] ?? json['name_en'] ?? json['title_en'] ?? json['label'] ?? fallbackName ?? 'Unknown';
    
    // Check if we have an explicit Arabic name field
    final rawNameAr = json['spec_name_ar'] ?? json['name_ar'] ?? json['title_ar'] ?? json['name_ar_title'];
    
    // Logic: if we have an explicit Arabic field, use it. 
    // Otherwise, try to translate the English name for common terms.
    String nameAr;
    if (rawNameAr != null && rawNameAr.toString().isNotEmpty) {
      nameAr = rawNameAr.toString();
    } else {
      nameAr = _translateCommon(name);
      // If translation returned same as English name, and we have a fallback, use that as last resort
      if (nameAr == name && fallbackName != null && fallbackName != name) {
        nameAr = fallbackName!;
      }
    }

    return SpecModel(
      id: rawId is int ? rawId : int.tryParse(rawId?.toString() ?? '0') ?? 0,
      name: name,
      nameAr: nameAr,
      termsCount: int.tryParse((json['terms_count'] ?? json['count'] ?? json['total'] ?? json['total_terms'] ?? 0).toString()) ?? 0,
    );
  }

  static String _translateCommon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('computer')) return 'حاسوب';
    if (lower.contains('medicine')) return 'طب';
    if (lower.contains('engineer')) return 'هندسة';
    if (lower.contains('manage')) return 'إدارة';
    if (lower.contains('account')) return 'محاسبة';
    if (lower.contains('law')) return 'حقوق';
    if (lower.contains('science')) return 'علوم';
    if (lower.contains('art')) return 'فنون';
    return name;
  }

  SpecModel copyWith({int? termsCount}) {
    return SpecModel(
      id: id,
      name: name,
      nameAr: nameAr,
      termsCount: termsCount ?? this.termsCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'spec_id': id,
      'spec_name': name,
      'spec_name_ar': nameAr,
      'terms_count': termsCount,
    };
  }

  /// Converts to the map format expected by existing Home/Quiz widgets
  Map<String, dynamic> toUiMap({String? iconPath}) {
    return {
      'id': id,
      'title': name,
      'arabicTitle': nameAr,
      'icon': iconPath ?? _iconForSpec(name),
      'count': termsCount.toString(),
    };
  }

  static String _iconForSpec(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('medicine') || lower.contains('طب')) {
      return 'assets/icons/medicine.svg';
    } else if (lower.contains('engineer') || lower.contains('هندسة')) {
      return 'assets/icons/engineering.svg';
    } else if (lower.contains('computer') || lower.contains('حاسب') || lower.contains('حاسوب')) {
      return 'assets/icons/computer.svg';
    } else if (lower.contains('manage') || lower.contains('إدارة')) {
      return 'assets/icons/management.svg';
    }
    return 'assets/icons/computer.svg'; // default
  }
}
