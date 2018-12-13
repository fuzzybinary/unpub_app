// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameSummary _$GameSummaryFromJson(Map<String, dynamic> json) {
  return GameSummary()
    ..id = json['id'] as String
    ..owner = json['owner'] as String
    ..game = json['game'] as String
    ..designer = json['designer'] as String
    ..description = json['description'] as String
    ..categories = json['categories'] == null
        ? null
        : GameSummary.categoryStringToIds(json['categories'] as String)
    ..categoryNames = json['group_concat(c.catname)'] == null
        ? null
        : splitString(json['group_concat(c.catname)'] as String);
}

Map<String, dynamic> _$GameSummaryToJson(GameSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'owner': instance.owner,
      'game': instance.game,
      'designer': instance.designer,
      'description': instance.description,
      'categories': instance.categories,
      'group_concat(c.catname)': instance.categoryNames
    };

EventsResponse _$EventsResponseFromJson(Map<String, dynamic> json) {
  return EventsResponse(
      recent: (json['recent'] as List)
          ?.map((e) =>
              e == null ? null : Event.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      future: (json['future'] as List)
          ?.map((e) =>
              e == null ? null : Event.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$EventsResponseToJson(EventsResponse instance) =>
    <String, dynamic>{'recent': instance.recent, 'future': instance.future};

Event _$EventFromJson(Map<String, dynamic> json) {
  return Event(
      id: json['ID'] as String,
      name: json['name'] as String,
      startDate: json['startdate'] == null
          ? null
          : parseDate(json['startdate'] as String));
}

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'ID': instance.id,
      'name': instance.name,
      'startdate': instance.startDate?.toIso8601String()
    };
