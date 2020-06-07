import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Settings {

  bool audioEnable = true;
  static Settings settingsInstance;

  //get static instance of settings
  //so you don't have to read the sharepreferences all the time.
  static Future<Settings> getInstance() async {
    if(settingsInstance == null) {
      settingsInstance = await Settings.getSettings();
    }
    return settingsInstance;
  }

  static Future<Settings> getSettings() async {
    Settings result = Settings();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString('settings');

    if (data != null && data.length > 0) {
      try {
        Map map = json.decode(data);
        //get audio enable setting
        if (map['audio_enable'] != null) {
          result.audioEnable = map['audio_enable'];
        }
      } catch (e) {

      }
    }

    return result;
  }

  static Future setSettings(Settings settings) async {
    String map = """{
        "audio_enable": ${settings.audioEnable}
      }
    """;

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('settings', map);
  }
}