import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Score {

  int value;

  Score(this.value);

  static Future<List<Score>> getLatestResults() async {
    List<Score> results = [];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String scoresData = prefs.getString('latest_results');

    if (scoresData != null && scoresData.length > 0) {
      try {
        Map map = json.decode(scoresData);
        if (map['data'] != null) {
          for (int i = 0; i < map['data'].length; i++) {
            Score score = Score.getFromMap(map['data'][i]);
            results.add(score);
          }
        }
      } catch (e) {

      }
    }

    return results;
  }

  static Future addLastResult(Score score) async {
    List<Score> scores = await Score.getLatestResults();
    scores.add(score);
    if (scores.length > 5) {
      scores.removeAt(0);
    }
    String map = """{
      "data": [
    """;

    for (int i=0; i< scores.length; i++) {
      map += """
      {
        "value": ${scores[i].value}
      }""";
      if (i < scores.length-1) {
        map += ",";
      }
    }

    map += """
      ]
    }""";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('latest_results', map);
  }

  static Score getFromMap(Map item){

    int value = item['value'];

    Score score = Score(value);

    return score;
  }
}