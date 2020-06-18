import 'package:flutter/material.dart';
import 'package:millionaire_quiz/services/api.dart';
import '../services/constants.dart' as constants;

class LeaderBoard {

  String idAccount = '';
  String  urlProfilPic = '';
  String fullName = '';
  int total = 0;

  static final String URL_GET_LEADERBOARD = constants.BASE_URL + 'index.php/playerScore/get_top_leadboard/';
  static final String URL_ADD_PLAYER_SCORE = constants.BASE_URL + 'index.php/playerScore/add/';

  LeaderBoard(this.idAccount, this.urlProfilPic, this.fullName, this.total);

  static Future getLeaderBoard(BuildContext context, int start, int length, {perWeek: 0, idAccount: ''}) async {
    List<LeaderBoard> list = [];
    list = await _getLeadboardFromServer(context,  start, length, perWeek, idAccount);
    return list;
  }

  static Future _getLeadboardFromServer(BuildContext context, int start, int length, int perWeek, String idAccount) async {
    List<LeaderBoard> leaderBoards = [];
    await Api(context).getJsonFromServer(
        URL_GET_LEADERBOARD + start.toString() + '/' + length.toString() + '/' + perWeek.toString() + '/' + idAccount
        , null).then((map) {
      if (map != null) {
        if(map['data'] != null) {
          for (int i = 0; i < map['data'].length; i++) {
            LeaderBoard leaderBoard = LeaderBoard.getFromMap(map['data'][i]);
            leaderBoards.add(leaderBoard);
          }
        }
      }
    });
    return leaderBoards;
  }

  static Future<bool> addGameResult(BuildContext context, String idAccount, int score) async {
    bool result = true;
    Map<String, dynamic> params = new Map<String, dynamic>();
    params['id_account'] = idAccount;
    params['score'] = score;
    await Api(context).getJsonFromServer(URL_ADD_PLAYER_SCORE, params).then((map) {
      if (map != null) {
        if(map['result'] != null || map['result'] == '0') {
          result = false;
        }
      }
    });
    return result;
  }

  static LeaderBoard getFromMap(Map item) {

    String idAccount = item['id_account'];
    String fullName = item['full_name'];
    String urlProfilPic = item['url_profil_pic'];
    int total = int.parse(item['total']);

    LeaderBoard leaderBoard = LeaderBoard(idAccount, urlProfilPic, fullName, total);

    return leaderBoard;
  }
}