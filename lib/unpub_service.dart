import 'dart:convert';
import 'dart:io';

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
    bool success = false;
    if (response.statusCode == 302) {
      final location = response.headers[HttpHeaders.locationHeader];
      final uri = Uri.parse(location);
      final query = uri.queryParameters;
      success = query['status']?.toLowerCase()?.compareTo('true') == 0;
    }
    return success;
  }

  Future<EventsResponse> fetchEvents() async {
    final response = await http.get('http://unpub.net/web/public/events.php');
    if (response.statusCode == 200) {
      final jsonVal = json.decode(response.body);
      final val = EventsResponse.fromJson(jsonVal);
      return val;
    }
    return null;
  }

  Future<List<GameSummary>> fetchGamesAtEvent(Event event) async {
    final list = <GameSummary>[];
    final response = await http
        .get('http://unpub.net/web/public/gamesevents.php?eid=${event.id}');
    if (response.statusCode == 200) {
      final List jsonVal = json.decode(response.body);
      for (final val in jsonVal) {
        list.add(GameSummary.fromJson(val));
      }
    }
    return list;
  }
}
