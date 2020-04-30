import 'package:flutter/material.dart';

class ButtonQuiz extends StatefulWidget{

  String title;
  Function buttonAction;

  ButtonQuiz(this.title, this.buttonAction);

  @override
  _ButtonQuizState createState() {
    return new _ButtonQuizState();
  }

}

class _ButtonQuizState extends State<ButtonQuiz>{

  BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 2.0,
            width: MediaQuery.of(context).size.width * 10 / 100,
            color: Theme.of(context).primaryColor,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 75 / 100,
            child: new RaisedButton(
              onPressed: this.widget.buttonAction,
              highlightColor: Colors.blue,
              child: new Text(this.widget.title,textScaleFactor: 1.2,),
              color: Colors.black,
              elevation: 10.0,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
                side: BorderSide(color: Theme.of(context).primaryColor, width: 2.0)
              ),
            ),
          ),
          Container(
            height: 2.0,
            width: MediaQuery.of(context).size.width * 10 / 100,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

}