import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class User {

  String id = '';
  String fullName = '';
  String urlProfilPic = '';

  static User currentUserInstance;

  static Future<User> getInstance() async {
    if(currentUserInstance == null) {
      currentUserInstance = await User.getCurrentUser();
    }
    return currentUserInstance;
  }

  static Future<User> getCurrentUser() async {
    User result = User();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString('user');

    if (data != null) {
      try {
        Map map = json.decode(data);
        if (map['id'] != null) {
          result.id = map['id'];
        }
        if (map['full_name'] != null) {
          result.fullName = map['full_name'];
        }
        if (map['url_profil_pic'] != null) {
          result.urlProfilPic = map['url_profil_pic'];
        }
      } catch (e) {
        //print('$e----------------------------');
      }
    }

    return result;
  }

  static Future setUser(User user) async {
    String map = """{
        "id": "${user.id}",
        "full_name": "${user.fullName}",
        "url_profil_pic": "${user.urlProfilPic}"
      }
    """;

    currentUserInstance = user;

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('user', map);
  }

}