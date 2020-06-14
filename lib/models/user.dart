import 'dart:convert';

import 'package:millionaire_quiz/services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import '../services/constants.dart' as constants;

class User {

  String id = '';
  String fullName = '';
  String urlProfilPic = '';

  static User currentUserInstance;

  static final String URL_ADD_PLAYER = constants.BASE_URL + 'index.php/player/add/';

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

  static Future<bool> handleSignIn(BuildContext _context) async {
    bool success = true;
    try {
      GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/contacts.readonly',
        ],
      );
      var result = await _googleSignIn.signIn();

      //add user to server
      Map<String, dynamic> map = new Map<String, dynamic>();
      map['id_account'] = result.id;
      map['full_name'] = result.displayName;
      map['url_profil_pic'] = result.photoUrl;

      await Api(_context).getJsonFromServer(
          URL_ADD_PLAYER
          , map).then((map) {
        if(map['result'] == null || map['result'] == '0') {
            success = false;
            //print('${map['result']}------------------------------------------');
        }
        else {
          User user = User();
          user.id = result.id;
          user.fullName = result.displayName;
          user.urlProfilPic = result.photoUrl;
          User.setUser(user);
        }
      });

    } catch (error) {
      success = false;
      //print('$error-----------------------------');
    }

    return success;
  }

}