import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

part 'models.g.dart';

final _dateFormat = DateFormat('yyyy-MM-dd');

List<String> splitString(String string) {
  return string.split(',');
}

DateTime parseDate(String string) {
  return _dateFormat.parse(string);
}

@JsonSerializable()
class GameSummary {
  String id;
  String owner;
  String game;
  String designer;
  String description;
  @JsonKey(fromJson: categoryStringToIds)
  List<int> categories;
  @JsonKey(name: 'group_concat(c.catname)', fromJson: splitString)
  List<String> categoryNames;

  GameSummary();

  factory GameSummary.fromJson(Map<String, dynamic> json) =>
      _$GameSummaryFromJson(json);

  String get categoryString {
    return categoryNames?.join(', ') ?? 'None';
  }

  static List<int> categoryStringToIds(String categories) {
    final categoryIds = <int>[];
    for (final idString in categories.split(',')) {
      final val = int.tryParse(idString);
      if (val != null) {
        categoryIds.add(val);
      }
    }

    return categoryIds;
  }
}

@JsonSerializable()
class EventsResponse {
  List<Event> recent;
  List<Event> future;

  EventsResponse({this.recent, this.future});

  factory EventsResponse.fromJson(Map<String, dynamic> json) =>
      _$EventsResponseFromJson(json);
}

@JsonSerializable()
class Event {
  @JsonKey(name: 'ID')
  String id;
  String name;
  @JsonKey(name: 'startdate', fromJson: parseDate)
  DateTime startDate;

  Event({this.id, this.name, this.startDate});

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}
