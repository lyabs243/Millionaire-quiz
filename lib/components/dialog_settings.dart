/**
 * Transition to load new question when player answer correctly
 */

import 'package:flutter/material.dart';
import '../models/settings.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DialogSettings extends StatefulWidget {

  DialogSettings();

  @override
  _DialogSettingsState createState() {
    return _DialogSettingsState();
  }

}

class _DialogSettingsState extends State<DialogSettings> {

  bool audioEnable = true;
  Settings settings;

  @override
  void initState() {
    super.initState();
    Settings.getSettings().then((value) {
      setState(() {
        settings = value;
        audioEnable = settings.audioEnable;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Container(
          width: MediaQuery.of(context).size.width * 70 / 100,
          padding: EdgeInsets.only(
            top: Consts.padding,
            bottom: Consts.padding,
            left: Consts.padding,
            right: Consts.padding,
          ),
          decoration: new BoxDecoration(
            color: Colors.black,
            shape: BoxShape.rectangle,
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(Consts.padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min, // To make the card compact
                children: [
                  SizedBox(height: (16.0 / 853) * MediaQuery.of(context).size.height),
                  Text(
                    'Settings',
                    textAlign: TextAlign.center,
                    textScaleFactor: 2.2,
                    style: TextStyle(
                        fontSize: (16.0 / 853) * MediaQuery.of(context).size.height,
                        color: Colors.white
                    ),
                  ),
                  SizedBox(height: (16.0 / 853) * MediaQuery.of(context).size.height),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          child: Text(
                            'Audio',
                            textScaleFactor: 1.4,
                            style: TextStyle(
                              color: Colors.white
                            ),
                          ),
                        ),
                        Container(
                          child: Switch(
                            value: audioEnable,
                            onChanged: (val) {
                              setState(() {
                                audioEnable = val;
                              });
                            }
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: (24.0 / 853) * MediaQuery.of(context).size.height),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop(settings);
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor
                            ),
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            settings.audioEnable = audioEnable;
                            Settings.setSettings(settings).then((value) {
                              Fluttertoast.showToast(
                                  msg: "Settings updated",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.blue,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                              Navigator.of(context).pop(settings);
                            });
                          },
                          child: Text(
                            'Save',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        );
  }

}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}