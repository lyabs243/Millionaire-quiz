import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:millionaire_quiz/components/layout_load.dart';
import 'package:millionaire_quiz/screens/home/home.dart';
import 'package:millionaire_quiz/screens/sign_in/sign_in_page.dart';
import 'package:millionaire_quiz/services/localizations.dart';
import 'package:millionaire_quiz/styles/style.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'models/user.dart';
import 'services/constants.dart' as constants;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {

  String langCode = constants.LANG_CODE;
  bool isLoading = true;
  User currentUser;

  @override
  void initState() {
    super.initState();
    User.getInstance().then((value) {
      setState(() {
        currentUser = value;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Admob.initialize(constants.ADMOB_APP_ID);
    return MaterialApp(
      localizationsDelegates: [
        MyLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      onGenerateTitle: (BuildContext context) =>
        MyLocalizations.of(context).localization['app_title'],
      locale: Locale(langCode),
      supportedLocales: [Locale(constants.LANG_CODE)],
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      home:
      (isLoading)?
          LayoutLoad():
        ((constants.USING_SERVER && currentUser.id.length == 0)?
        SignInPage():
        HomePage()),
    );
  }
}
