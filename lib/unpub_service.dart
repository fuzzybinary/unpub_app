import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models.dart';

class UnpubService {
  final String url = 'http://unpub.net/';

  Future<List<GameSummary>> fetchGameSummaries() async {
    final list = <GameSummary>[];
    final response = await http.get('${url}web/public/games2017.php');
    if (response.statusCode == 200) {
      final List jsonVal = json.decode(response.body);
      for (final val in jsonVal) {
        list.add(GameSummary.fromJson(val));
      }
    }
    return list;
  }

  Future<bool> submitFeedback(Map<String, String> fields) async {
    final response = await http.post(
      '${url}feedback/',
      body: fields,
    );
    final newUrl = response.request.url;
    print(newUrl);
  }
}
