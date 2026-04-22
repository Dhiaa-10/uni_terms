import 'package:flutter/material.dart';
import '../models/term_model.dart';

class MockData {
  static List<TermModel> get allTerms => terms;
  static final List<TermModel> terms = [
    // --- Medicine ---
    TermModel(
      id: 'm1',
      title: 'Pathophysiology',
      arabicTranslation: 'علم الأمراض الوظيفي',
      definition: 'The study of the disordered physiological processes associated with disease or injury.',
      arabicDefinition: 'دراسة العمليات الفسيولوجية المضطربة المرتبطة بمرض أو إصابة.',
      category: 'Medicine',
      isNew: true,
      isPopular: true,
      example: 'The study of how diseases change the normal functioning of the body.',
      arabicExample: 'دراسة كيف تغير الأمراض الوظائف الطبيعية للجسم.',
    ),
    TermModel(
      id: 'm2',
      title: 'Antibiotics',
      arabicTranslation: 'مضادات حيوية',
      definition: 'A medicine that inhibits the growth of or destroys microorganisms.',
      arabicDefinition: 'دواء يمنع نمو الكائنات الدقيقة أو يدمرها.',
      category: 'Medicine',
      isNew: true,
      example: 'Penicillin was one of the first antibiotics to be discovered.',
      arabicExample: 'كان البنسلين من أوائل المضادات الحيوية التي تم اكتشافها.',
    ),
    TermModel(
      id: 'm3',
      title: 'Clinical Trial',
      arabicTranslation: 'تجارب سريرية',
      definition: 'Experiments or observations done in clinical research.',
      arabicDefinition: 'تجارب أو ملاحظات تجرى في البحث السريري.',
      category: 'Medicine',
      isPopular: true,
    ),
    TermModel(
      id: 'm4',
      title: 'Hypotension',
      arabicTranslation: 'انخفاض ضغط الدم',
      definition: 'Abnormally low blood pressure.',
      arabicDefinition: 'انخفاض ضغط الدم بشكل غير طبيعي.',
      category: 'Medicine',
    ),
    TermModel(
      id: 'm5',
      title: 'Immunology',
      arabicTranslation: 'علم المناعة',
      definition: 'The branch of medicine and biology concerned with immunity.',
      arabicDefinition: 'فرع الطب والبيولوجيا المعني بالمناعة.',
      category: 'Medicine',
    ),
    TermModel(
      id: 'm6',
      title: 'Radiology',
      arabicTranslation: 'علم الأشعة',
      definition: 'The science dealing with X-rays and other high-energy radiation.',
      arabicDefinition: 'العلم الذي يتعامل مع الأشعة السينية وغيرها من الإشعاعات عالية الطاقة.',
      category: 'Medicine',
    ),

    // --- Engineering ---
    TermModel(
      id: 'e1',
      title: 'Structural Analysis',
      arabicTranslation: 'التحليل الإنشائي',
      definition: 'The determination of the effects of loads on physical structures.',
      arabicDefinition: 'تحديد تأثيرات الأحمال على الهياكل المادية.',
      category: 'Engineering',
      isNew: true,
      isPopular: true,
    ),
    TermModel(
      id: 'e2',
      title: 'Thermodynamics',
      arabicTranslation: 'الديناميكا الحرارية',
      definition: 'Phys Science dealing with relations between heat and other forms of energy.',
      arabicDefinition: 'العلوم الفيزيائية التي تتعامل مع العلاقات بين الحرارة وأشكال الطاقة الأخرى.',
      category: 'Engineering',
      isPopular: true,
    ),
    TermModel(
      id: 'e3',
      title: 'Fluid Mechanics',
      arabicTranslation: 'ميكانيكا الموائع',
      definition: 'The branch of physics concerned with the mechanics of fluids.',
      arabicDefinition: 'فرع الفيزياء المعني بميكانيكا الموائع.',
      category: 'Engineering',
    ),
    TermModel(
      id: 'e4',
      title: 'Concrete Design',
      arabicTranslation: 'تصميم الخرسانة',
      definition: 'The process of determining the specifications of concrete structures.',
      arabicDefinition: 'عملية تحديد مواصفات الهياكل الخرسانية.',
      category: 'Engineering',
    ),
    TermModel(
      id: 'e5',
      title: 'Aeronautics',
      arabicTranslation: 'الملاحة الجوية',
      definition: 'The science or practice of travel through the air.',
      arabicDefinition: 'علم أو ممارسة السفر عبر الهواء.',
      category: 'Engineering',
    ),

    // --- Computer ---
    TermModel(
      id: 'c1',
      title: 'Algorithm',
      arabicTranslation: 'خوارزمية',
      definition: 'A set of rules to be followed in calculations.',
      arabicDefinition: 'مجموعة من القواعد التي يجب اتباعها في الحسابات.',
      category: 'Computer',
      isNew: true,
      isPopular: true,
    ),
    TermModel(
      id: 'c2',
      title: 'Machine Learning',
      arabicTranslation: 'تعلم الآلة',
      definition: 'Type of AI that allows software to become more accurate in predicting outcomes.',
      arabicDefinition: 'نوع من الذكاء الاصطناعي يسمح للبرمجيات بأن تصبح أكثر دقة في التنبؤ بالنتائج.',
      category: 'Computer',
      isNew: true,
      isPopular: true,
    ),
    TermModel(
      id: 'c3',
      title: 'Cybersecurity',
      arabicTranslation: 'الأمن السيبراني',
      definition: 'The state of being protected against the criminal use of electronic data.',
      arabicDefinition: 'حالة الحماية ضد الاستخدام الإجرامي للبيانات الإلكترونية.',
      category: 'Computer',
      isPopular: true,
    ),
    TermModel(
      id: 'c4',
      title: 'Data Science',
      arabicTranslation: 'علم البيانات',
      definition: 'An interdisciplinary field that uses scientific methods and algorithms.',
      arabicDefinition: 'مجال متعدد التخصصات يستخدم الأساليب والوارزميات العلمية.',
      category: 'Computer',
    ),
    TermModel(
      id: 'c5',
      title: 'Cryptography',
      arabicTranslation: 'علم التشفير',
      definition: 'The art of writing or solving codes.',
      arabicDefinition: 'فن كتابة أو حل الأكواد.',
      category: 'Computer',
    ),

    // --- Management ---
    TermModel(
      id: 'mg1',
      title: 'Strategic Management',
      arabicTranslation: 'الإدارة الاستراتيجية',
      definition: 'Management of resources to achieve goals and objectives.',
      arabicDefinition: 'إدارة الموارد لتحقيق الغايات والأهداف.',
      category: 'Management',
      isNew: true,
    ),
    TermModel(
      id: 'mg2',
      title: 'Project Planning',
      arabicTranslation: 'تخطيط المشروع',
      definition: 'Discipline for stating how to complete a project.',
      arabicDefinition: 'نظام لتحديد كيفية إكمال المشروع.',
      category: 'Management',
      isPopular: true,
    ),
    TermModel(
      id: 'mg3',
      title: 'Human Resources',
      arabicTranslation: 'الموارد البشرية',
      definition: 'The department of a business or organization that deals with hiring and training.',
      arabicDefinition: 'قسم في شركة أو منظمة يتعامل مع التوظيف والتدريب.',
      category: 'Management',
    ),
    TermModel(
      id: 'mg4',
      title: 'Risk Assessment',
      arabicTranslation: 'تقييم المخاطر',
      definition: 'A systematic process of evaluating potential risks.',
      arabicDefinition: 'عملية منهجية لتقييم المخاطر المحتملة.',
      category: 'Management',
    ),

    // --- Law ---
    TermModel(
      id: 'l1',
      title: 'Litigation',
      arabicTranslation: 'التقاضي',
      definition: 'The process of taking legal action.',
      arabicDefinition: 'عملية اتخاذ إجراء قانوني.',
      category: 'Law',
      isNew: true,
    ),
    TermModel(
      id: 'l2',
      title: 'Jurisdiction',
      arabicTranslation: 'الاختصاص القضائي',
      definition: 'The official power to make legal decisions and judgments.',
      arabicDefinition: 'السلطة الرسمية لاتخاذ القرارات والأحكام القانونية.',
      category: 'Law',
      isPopular: true,
    ),
    TermModel(
      id: 'l3',
      title: 'Affidavit',
      arabicTranslation: 'إفادة مشفوعة بقسم',
      definition: 'A written statement confirmed by oath or affirmation.',
      arabicDefinition: 'بيان مكتوب مؤكد بالقسم أو الإقرار.',
      category: 'Law',
    ),

    // --- Accounting ---
    TermModel(
      id: 'a1',
      title: 'Ledger',
      arabicTranslation: 'دفتر الأستاذ',
      definition: 'A book or other collection of financial accounts.',
      arabicDefinition: 'كتاب أو مجموعة أخرى من الحسابات المالية.',
      category: 'Accounting',
      isNew: true,
    ),
    TermModel(
      id: 'a2',
      title: 'Audit',
      arabicTranslation: 'تدقيق الحسابات',
      definition: 'An official inspection of an individual\'s or organization\'s accounts.',
      arabicDefinition: 'تفتيش رسمي لحسابات فرد أو منظمة.',
      category: 'Accounting',
      isPopular: true,
    ),
    TermModel(
      id: 'a3',
      title: 'Depreciation',
      arabicTranslation: 'الاستهلاك',
      definition: 'A reduction in the value of an asset with the passage of time.',
      arabicDefinition: 'نقص في قيمة الأصل مع مرور الوقت.',
      category: 'Accounting',
    ),
  ];

  static List<Map<String, dynamic>> get majors {
    return _majorsData.map((major) {
      final count = terms.where((t) => t.category == major['title']).length;
      return {
        ...major,
        'count': count.toString(),
      };
    }).toList();
  }

  static final List<Map<String, dynamic>> _majorsData = [
    {
      'title': 'Medicine',
      'arabicTitle': 'الطب',
      'icon': Icons.medical_services_outlined,
    },
    {
      'title': 'Engineering',
      'arabicTitle': 'الهندسة',
      'icon': Icons.architecture_outlined,
    },
    {
      'title': 'Computer',
      'arabicTitle': 'الحاسب',
      'icon': Icons.laptop_mac_outlined,
    },
    {
      'title': 'Management',
      'arabicTitle': 'الإدارة',
      'icon': Icons.analytics_outlined,
    },
    {
      'title': 'Law',
      'arabicTitle': 'القانون',
      'icon': Icons.account_balance_outlined,
    },
    {
      'title': 'Accounting',
      'arabicTitle': 'المحاسبة',
      'icon': Icons.calculate_outlined,
    },
  ];
}
