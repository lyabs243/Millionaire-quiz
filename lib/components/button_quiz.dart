import 'package:flutter/material.dart';

class ButtonQuiz extends StatefulWidget{

  String title;
  String textLeft;
  TextAlign textAlign;
  Function buttonAction;

  ButtonQuiz(this.title, this.buttonAction, {this.textAlign: TextAlign.left, this.textLeft: ''});

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
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 68 / 100,
                    child: RichText(
                      textAlign: this.widget.textAlign,
                      text: new TextSpan(
                        children: [
                          (this.widget.textLeft.isNotEmpty)?
                          new TextSpan(
                            text: this.widget.textLeft,
                            style: new TextStyle(color: Colors.yellow,fontSize: 20.0),
                          ): TextSpan(),
                          TextSpan(text: '    '),
                          new TextSpan(
                            text: this.widget.title,
                            style: new TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
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