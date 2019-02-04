import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart' as pp;

import 'models.dart';

class UnpubService {
  final Duration cacheExpiration = Duration(hours: 8);

  final String url = 'http://unpub.net/';

  List<GameSummary> _cachedGames;
  List<GameSummary> get cachedGames => _cachedGames;

  EventsResponse _cachedEvents;
  EventsResponse get cachedEvents => _cachedEvents;

  Future<String> _fetchFromCache(String fileName) async {
    final tempDir = await pp.getTemporaryDirectory();
    final files = tempDir.listSync();
    try {
      final cacheFile =
          files.firstWhere((f) => f.path.endsWith(fileName), orElse: null);
      final stats = await cacheFile.stat();
      if (DateTime.now().difference(stats.changed).compareTo(cacheExpiration) <
          0) {
        final file = File(cacheFile.path);
        return file.readAsString();
      }
    } catch (StateError) {
      // ignore: empty_catches
    }

    return null;
  }

  Future<void> _saveToCache(String fileName, String contents) async {
    final tempDir = await pp.getTemporaryDirectory();
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsString(contents);
  }

  Future<List<GameSummary>> fetchGameSummaries(
      {bool ignoreCache = true}) async {
    String responseText;
    if (!ignoreCache) {
      responseText = await _fetchFromCache('games.json');
    }

    if (responseText == null) {
      final response = await http.get('${url}web/public/games2017.php');
      if (response.statusCode == 200) {
        responseText = response.body;
        await _saveToCache('games.json', responseText);
      }
    }

    final list = <GameSummary>[];
    if (responseText != null) {
      final List jsonVal = json.decode(responseText);
      for (final val in jsonVal) {
        list.add(GameSummary.fromJson(val));
      }
    }

    _cachedGames = list;

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

  Future<EventsResponse> fetchEvents({bool ignoreCache = false}) async {
    String responseText;
    if (!ignoreCache) {
      responseText = await _fetchFromCache('events.json');
    }

    if (responseText == null) {
      final response = await http.get('http://unpub.net/web/public/events.php');
      if (response.statusCode == 200) {
        responseText = response.body;
        await _saveToCache('events.json', responseText);
      }
    }

    EventsResponse response;
    if (responseText != null) {
      final jsonVal = json.decode(responseText);
      response = EventsResponse.fromJson(jsonVal);
    }

    _cachedEvents = response;

    return response;
  }

  Future<List<GameSummary>> fetchGamesAtEvent(Event event) async {
    final list = <GameSummary>[];
    final response = await http
        .get('http://unpub.net/web/public/gamesevents.php?eid=${event.id}');
    if (response.statusCode == 200) {
      final List jsonVal = json.decode(response.body);
      if (jsonVal != null) {
        for (final val in jsonVal) {
          list.add(GameSummary.fromJson(val));
        }
      }
    }
    return list;
  }
}
