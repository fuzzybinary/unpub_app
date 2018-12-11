import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

List<String> splitString(String string) {
  return string.split(',');
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
