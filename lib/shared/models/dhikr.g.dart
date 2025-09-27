// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dhikr.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Dhikr _$DhikrFromJson(Map<String, dynamic> json) => Dhikr(
  id: json['id'] as String,
  titleKey: json['titleKey'] as String,
  arabicText: json['arabicText'] as String,
  targetCount: (json['targetCount'] as num).toInt(),
  categoryId: json['categoryId'] as String,
  transliteration: json['transliteration'] as String?,
  meaningKey: json['meaningKey'] as String?,
  sourceReference: json['sourceReference'] as String?,
  benefits:
      (json['benefits'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  isCustom: json['isCustom'] as bool? ?? false,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$DhikrToJson(Dhikr instance) => <String, dynamic>{
  'id': instance.id,
  'titleKey': instance.titleKey,
  'arabicText': instance.arabicText,
  'targetCount': instance.targetCount,
  'categoryId': instance.categoryId,
  'transliteration': instance.transliteration,
  'meaningKey': instance.meaningKey,
  'sourceReference': instance.sourceReference,
  'benefits': instance.benefits,
  'isCustom': instance.isCustom,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

DhikrCategory _$DhikrCategoryFromJson(Map<String, dynamic> json) =>
    DhikrCategory(
      id: json['id'] as String,
      titleKey: json['titleKey'] as String,
      descriptionKey: json['descriptionKey'] as String,
      iconName: json['iconName'] as String,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$DhikrCategoryToJson(DhikrCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'titleKey': instance.titleKey,
      'descriptionKey': instance.descriptionKey,
      'iconName': instance.iconName,
      'sortOrder': instance.sortOrder,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

DhikrSession _$DhikrSessionFromJson(Map<String, dynamic> json) => DhikrSession(
  id: json['id'] as String,
  dhikrId: json['dhikrId'] as String,
  currentCount: (json['currentCount'] as num).toInt(),
  targetCount: (json['targetCount'] as num).toInt(),
  startedAt: DateTime.parse(json['startedAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  isCompleted: json['isCompleted'] as bool? ?? false,
  duration: json['duration'] == null
      ? null
      : Duration(microseconds: (json['duration'] as num).toInt()),
);

Map<String, dynamic> _$DhikrSessionToJson(DhikrSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dhikrId': instance.dhikrId,
      'currentCount': instance.currentCount,
      'targetCount': instance.targetCount,
      'startedAt': instance.startedAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'isCompleted': instance.isCompleted,
      'duration': instance.duration?.inMicroseconds,
    };
