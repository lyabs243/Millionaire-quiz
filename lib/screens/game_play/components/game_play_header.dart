import 'package:flutter/material.dart';
import 'package:millionaire_quiz/components/button_circle.dart';
import 'package:millionaire_quiz/services/localizations.dart';

class GamePlayHeader extends StatelessWidget {

  int currentMoney;
  Function onGetMoneyClicked, onBonusHideClicked, onBonusAskAudienceClicked, onBonusCallFriendClicked, onExitGame;
  Color callFriendBorderColor = Colors.blue, callFriendFillColor = Colors.black, askAudienceBorderColor = Colors.blue,
      askAudienceFillColor = Colors.black, hideAnswersBorderColor = Colors.blue, hideAnswersFillColor = Colors.black;

  GamePlayHeader(this.currentMoney, this.onBonusCallFriendClicked, this.onBonusAskAudienceClicked, this.onBonusHideClicked,
      this.onGetMoneyClicked, this.hideAnswersBorderColor, this.hideAnswersFillColor, this.askAudienceFillColor, this.askAudienceBorderColor,
      this.callFriendFillColor, this.callFriendBorderColor, this.onExitGame);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          child: ButtonCircle(
              Icon(
                Icons.arrow_back,
                size: (25.0 / 853) * MediaQuery.of(context).size.height,
                color: Colors.white,
              ),
              () {
                this.onExitGame();
              }
          ),
          width: (MediaQuery.of(context).size.width * 65 / 100) / 5,
          margin: EdgeInsets.only(left: (6.0 / 853) * MediaQuery.of(context).size.height, right: (6.0 / 853) * MediaQuery.of(context).size.height),
        ),
        (currentMoney > 0)?
        Container(
          height: (40.0 / 853) * MediaQuery.of(context).size.height,
          child: new RaisedButton(
            onPressed: this.onGetMoneyClicked,
            highlightColor: Colors.orange,
            child: SizedBox(
              child: Text(
                MyLocalizations.of(context).localization['get_money'],
                textAlign: TextAlign.center,
                style: new TextStyle(color: Colors.white, fontSize: (18.0 / 853) * MediaQuery.of(context).size.height),
              ),
              width: MediaQuery.of(context).size.width * 20 / 100,
            ),
            color: Colors.black,
            elevation: 10.0,
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
                side: BorderSide(color: Theme.of(context).primaryColor, width: 2.0)
            ),
          ),
        ): Container(),
        Container(
          child: ButtonCircle(
            ImageIcon(
              AssetImage('assets/ic_bonus/ic_hide_answers.png'),
              color: Colors.white,
              size: (25.0 / 853) * MediaQuery.of(context).size.height,
            ),
            this.onBonusHideClicked,
            borderColor: hideAnswersBorderColor,
            fillColor: hideAnswersFillColor,
          ),
          width: (MediaQuery.of(context).size.width * 65 / 100) / 5,
          margin: EdgeInsets.only(left: (6.0 / 853) * MediaQuery.of(context).size.height, right: (6.0 / 853) * MediaQuery.of(context).size.height),
        ),
        Container(
          child: ButtonCircle(
            ImageIcon(
              AssetImage('assets/ic_bonus/ic_call_friend.png'),
              color: Colors.white,
              size: (25.0 / 853) * MediaQuery.of(context).size.height,
            ),
            this.onBonusCallFriendClicked,
            borderColor: callFriendBorderColor,
            fillColor: callFriendFillColor,
          ),
          width: (MediaQuery.of(context).size.width * 65 / 100) / 5,
          margin: EdgeInsets.only(left: (6.0 / 853) * MediaQuery.of(context).size.height, right: (6.0 / 853) * MediaQuery.of(context).size.height),
        ),
        Container(
          child: ButtonCircle(
            ImageIcon(
              AssetImage('assets/ic_bonus/ic_ask_audience.png'),
              color: Colors.white,
              size: (25.0 / 853) * MediaQuery.of(context).size.height,
            ),
            this.onBonusAskAudienceClicked,
            borderColor: askAudienceBorderColor,
            fillColor: askAudienceFillColor,
          ),
          width: (MediaQuery.of(context).size.width * 65 / 100) / 5,
          margin: EdgeInsets.only(left: (6.0 / 853) * MediaQuery.of(context).size.height, right: (6.0 / 853) * MediaQuery.of(context).size.height),
        )
      ],
    );
  }

}