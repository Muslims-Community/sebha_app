import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'dhikr.g.dart';

@JsonSerializable()
class Dhikr {
  final String id;
  final String titleKey;
  final String arabicText;
  final int targetCount;
  final String categoryId;
  final String? transliteration;
  final String? meaningKey;
  final String? sourceReference;
  final List<String> benefits;
  final bool isCustom;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Dhikr({
    required this.id,
    required this.titleKey,
    required this.arabicText,
    required this.targetCount,
    required this.categoryId,
    this.transliteration,
    this.meaningKey,
    this.sourceReference,
    this.benefits = const [],
    this.isCustom = false,
    this.createdAt,
    this.updatedAt,
  });

  factory Dhikr.fromJson(Map<String, dynamic> json) => _$DhikrFromJson(json);
  Map<String, dynamic> toJson() => _$DhikrToJson(this);

  Dhikr copyWith({
    String? id,
    String? titleKey,
    String? arabicText,
    int? targetCount,
    String? categoryId,
    String? transliteration,
    String? meaningKey,
    String? sourceReference,
    List<String>? benefits,
    bool? isCustom,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Dhikr(
      id: id ?? this.id,
      titleKey: titleKey ?? this.titleKey,
      arabicText: arabicText ?? this.arabicText,
      targetCount: targetCount ?? this.targetCount,
      categoryId: categoryId ?? this.categoryId,
      transliteration: transliteration ?? this.transliteration,
      meaningKey: meaningKey ?? this.meaningKey,
      sourceReference: sourceReference ?? this.sourceReference,
      benefits: benefits ?? this.benefits,
      isCustom: isCustom ?? this.isCustom,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static Dhikr create({
    required String titleKey,
    required String arabicText,
    required int targetCount,
    required String categoryId,
    String? transliteration,
    String? meaningKey,
    String? sourceReference,
    List<String>? benefits,
    bool isCustom = false,
  }) {
    final now = DateTime.now();
    return Dhikr(
      id: const Uuid().v4(),
      titleKey: titleKey,
      arabicText: arabicText,
      targetCount: targetCount,
      categoryId: categoryId,
      transliteration: transliteration,
      meaningKey: meaningKey,
      sourceReference: sourceReference,
      benefits: benefits ?? [],
      isCustom: isCustom,
      createdAt: now,
      updatedAt: now,
    );
  }
}

@JsonSerializable()
class DhikrCategory {
  final String id;
  final String titleKey;
  final String descriptionKey;
  final String iconName;
  final int sortOrder;
  final bool isActive;
  final DateTime? createdAt;

  const DhikrCategory({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.iconName,
    this.sortOrder = 0,
    this.isActive = true,
    this.createdAt,
  });

  factory DhikrCategory.fromJson(Map<String, dynamic> json) => _$DhikrCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$DhikrCategoryToJson(this);

  DhikrCategory copyWith({
    String? id,
    String? titleKey,
    String? descriptionKey,
    String? iconName,
    int? sortOrder,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return DhikrCategory(
      id: id ?? this.id,
      titleKey: titleKey ?? this.titleKey,
      descriptionKey: descriptionKey ?? this.descriptionKey,
      iconName: iconName ?? this.iconName,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

@JsonSerializable()
class DhikrSession {
  final String id;
  final String dhikrId;
  final int currentCount;
  final int targetCount;
  final DateTime startedAt;
  final DateTime? completedAt;
  final bool isCompleted;
  final Duration? duration;

  const DhikrSession({
    required this.id,
    required this.dhikrId,
    required this.currentCount,
    required this.targetCount,
    required this.startedAt,
    this.completedAt,
    this.isCompleted = false,
    this.duration,
  });

  factory DhikrSession.fromJson(Map<String, dynamic> json) => _$DhikrSessionFromJson(json);
  Map<String, dynamic> toJson() => _$DhikrSessionToJson(this);

  DhikrSession copyWith({
    String? id,
    String? dhikrId,
    int? currentCount,
    int? targetCount,
    DateTime? startedAt,
    DateTime? completedAt,
    bool? isCompleted,
    Duration? duration,
  }) {
    return DhikrSession(
      id: id ?? this.id,
      dhikrId: dhikrId ?? this.dhikrId,
      currentCount: currentCount ?? this.currentCount,
      targetCount: targetCount ?? this.targetCount,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      isCompleted: isCompleted ?? this.isCompleted,
      duration: duration ?? this.duration,
    );
  }

  static DhikrSession create({
    required String dhikrId,
    required int targetCount,
  }) {
    return DhikrSession(
      id: const Uuid().v4(),
      dhikrId: dhikrId,
      currentCount: 0,
      targetCount: targetCount,
      startedAt: DateTime.now(),
    );
  }

  DhikrSession increment() {
    final newCount = currentCount + 1;
    final completed = newCount >= targetCount;
    final now = DateTime.now();

    return copyWith(
      currentCount: newCount,
      isCompleted: completed,
      completedAt: completed ? now : null,
      duration: completed ? now.difference(startedAt) : null,
    );
  }

  double get progress => targetCount > 0 ? (currentCount / targetCount).clamp(0.0, 1.0) : 0.0;
  bool get hasReachedTarget => currentCount >= targetCount;
}