import 'package:flutter/material.dart';
import 'package:millionaire_quiz/services/localizations.dart';

class DialogTopLeadBoard extends StatefulWidget {

  @override
  _DialogTopLeadBoard createState() {
    return _DialogTopLeadBoard();
  }

}

class _DialogTopLeadBoard extends State<DialogTopLeadBoard> {

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
      width: MediaQuery.of(context).size.width * 80 / 100,
      height: MediaQuery.of(context).size.height * 85 / 100,
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
            children: <Widget>[
              Text(
                MyLocalizations.of(context).localization['top_leadboard'],
                textAlign: TextAlign.center,
                textScaleFactor: 2.2,
                style: TextStyle(
                    fontSize: (16.0 / 853) * MediaQuery.of(context).size.height,
                    color: Colors.white
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 10.0, bottom: 10.0),),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 25 / 100,
                      height: 40.0,
                      child: new RaisedButton(
                        onPressed: () {

                        },
                        highlightColor: Colors.orange,
                        child: //Row(
                        //children: <Widget>[
                        SizedBox(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: new TextSpan(
                              children: [
                                new TextSpan(
                                  text: MyLocalizations.of(context).map['this_week'],
                                  style: new TextStyle(color: Colors.white, fontSize: (15.0 / 853) * MediaQuery.of(context).size.height),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //],
                        //),
                        color: Colors.black,
                        elevation: 10.0,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                            side: BorderSide(color: Theme.of(context).primaryColor, width: 2.0)
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(left: 4.0, right: 4.0),),
                    Container(
                      width: MediaQuery.of(context).size.width * 25 / 100,
                      height: 40.0,
                      child: new RaisedButton(
                        onPressed: () {

                        },
                        highlightColor: Theme.of(context).primaryColor,
                        child: //Row(
                        //children: <Widget>[
                        SizedBox(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: new TextSpan(
                              children: [
                                new TextSpan(
                                  text: MyLocalizations.of(context).map['this_month'],
                                  style: new TextStyle(color: Colors.white, fontSize: (15.0 / 853) * MediaQuery.of(context).size.height),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //],
                        //),
                        color: Theme.of(context).primaryColor,
                        elevation: 10.0,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                            side: BorderSide(color: Theme.of(context).primaryColor, width: 2.0)
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 10.0, bottom: 10.0),),
              RichText(
                textAlign: TextAlign.center,
                text: new TextSpan(
                  children: [
                    new TextSpan(
                      text: '${MyLocalizations.of(context).localization['you_reached']} ',
                      style: new TextStyle(color: Colors.white, fontSize: (20.0 / 853) * MediaQuery.of(context).size.height),
                    ),
                    new TextSpan(
                      text: '\$ 440.5M',
                      style: new TextStyle(color: Colors.yellow,fontSize: (28.0 / 853) * MediaQuery.of(context).size.height),
                    ),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 10.0, bottom: 10.0),),
              Expanded(
                child: ListView.builder(itemBuilder: (context, index) {
                  return Container(
                    color: (index == 5)? Colors.blue[900]: Colors.black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 5 /100,
                          alignment: Alignment.center,
                          child: Text(
                            '${index + 1}',
                            textScaleFactor: 1.4,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Container(
                          child: Image.network(
                            'https://0.s3.envato.com/files/29646869/avatar1.jpg',
                            fit: BoxFit.cover,
                          ),
                          height: (60 / 853) * MediaQuery.of(context).size.height,
                          width: (60 / 853) * MediaQuery.of(context).size.height,
                          padding: EdgeInsets.all(5.0),
                          decoration: new BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.rectangle,
                            border: Border.all(color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(Consts.padding),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 35 /100,
                          alignment: Alignment.center,
                          child: Text(
                            'Loic Yabili Yabili Yabili Yabili Yabili',
                            maxLines: 2,
                            textScaleFactor: 1.5,
                            style: TextStyle(
                                color: Colors.white
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 20 /100,
                          alignment: Alignment.center,
                          child: Text(
                            '\$ 600.8 M',
                            maxLines: 1,
                            textScaleFactor: 1.2,
                            style: TextStyle(
                                color: Colors.yellow
                            ),
                          ),
                        )
                      ],
                    ),
                    margin: EdgeInsets.all(5.0),
                  );
                },
                  itemCount: 10,),
              ),
              listViewBottom()
            ],
          ),
        ],
      ),
    );
  }

  Widget listViewBottom() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop(); // To close the dialog
            },
            child: Text(
              MyLocalizations.of(context).localization['close'],
              style: TextStyle(
                  color: Theme.of(context).primaryColor
              ),
            ),
          )
        ],
      ),
    );
  }

}

class Consts {
  Consts._();

  static const double padding = 10.0;
  static const double avatarRadius = 66.0;
}