import 'package:flutter/material.dart';
import 'package:spoty_try5/models/character_model.dart';
import 'package:spoty_try5/models/episode_model.dart';
import 'package:http/http.dart' as http;

class ApiProvider with ChangeNotifier {
  final _baseUrl = 'rickandmortyapi.com';
  List<Character> characters = [];
  List<Episode> episodes = [];

  Future<void> getCharacters(int page) async {
    final result = await http.get(Uri.https(_baseUrl, "/api/character", {
      'page': page.toString(),
    }));
    final response = characterResponseFromJson(result.body);
    characters.addAll(response.results!);
    notifyListeners();
  }

  Future<List<Episode>> getEpisodes(Character character) async {
    episodes = [];
    for (var i = 0; i < character.episode!.length; i++) {
      final result = await http.get(Uri.parse(character.episode![i]));
      final response = episodeFromJson(result.body);
      episodes.add(response);
      notifyListeners();
    }
    return episodes;
  }

  Future<List<Character>> getCharacter(String name) async {
    final result =
        await http.get(Uri.https(_baseUrl, "/api/character/", {'name': name}));

    final response = characterResponseFromJson(result.body);

    return response.results!;
  }
}
