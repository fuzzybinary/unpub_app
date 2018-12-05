// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameSummary _$GameSummaryFromJson(Map<String, dynamic> json) {
  return GameSummary()
    ..id = json['ID'] as String
    ..owner = json['owner'] as String
    ..game = json['game'] as String
    ..designer = json['designer'] as String
    ..description = json['description'] as String
    ..categories = json['categories'] == null
        ? null
        : GameSummary.categoryStringToIds(json['categories'] as String)
    ..categoryNames = json['categoryNames'] == null
        ? null
        : splitString(json['categoryNames'] as String);
}

Map<String, dynamic> _$GameSummaryToJson(GameSummary instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'owner': instance.owner,
      'game': instance.game,
      'designer': instance.designer,
      'description': instance.description,
      'categories': instance.categories,
      'categoryNames': instance.categoryNames
    };
