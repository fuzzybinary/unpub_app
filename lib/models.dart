import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

List<String> splitString(String string) {
  return string.split(',');
}

@JsonSerializable()
class GameSummary {
  @JsonKey(name:'ID')
  String id;
  String owner;
  String game;
  String designer;
  String description;
  @JsonKey(fromJson: categoryStringToIds)
  List<int> categories;
  @JsonKey(fromJson: splitString)
  List<String> categoryNames;

  GameSummary();
  
  factory GameSummary.fromJson(Map<String, dynamic> json) => _$GameSummaryFromJson(json);

  static List<int> categoryStringToIds(String categories) {
    final categoryIds = <int>[];
    for(final idString in categories.split(',')) {
      final val = int.tryParse(idString);
      if(val != null) {
        categoryIds.add(val);
      }
    }

    return categoryIds;
  }
}