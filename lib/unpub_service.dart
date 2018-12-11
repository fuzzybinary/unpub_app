import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models.dart';

class UnpubService {
  Future<List<GameSummary>> fetchGameSummaries() async {
    final list = <GameSummary>[];
    final response =
        await http.get('http://unpub.net/web/public/games2017.php');
    if (response.statusCode == 200) {
      final List jsonVal = json.decode(response.body);
      for (final val in jsonVal) {
        list.add(GameSummary.fromJson(val));
      }
    }
    return list;
  }
}
