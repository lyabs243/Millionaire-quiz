import 'package:flutter/material.dart';
import 'package:millionaire_quiz/components/button_circle.dart';

class GamePlayHeader extends StatelessWidget {

  int currentMoney;
  Function onGetMoneyClicked, onBonusHideClicked, onBonusAskAudienceClicked, onBonusCallFriendClicked;
  Color callFriendBorderColor = Colors.blue, callFriendFillColor = Colors.black, askAudienceBorderColor = Colors.blue,
      askAudienceFillColor = Colors.black, hideAnswersBorderColor = Colors.blue, hideAnswersFillColor = Colors.black;

  GamePlayHeader(this.currentMoney, this.onBonusCallFriendClicked, this.onBonusAskAudienceClicked, this.onBonusHideClicked,
      this.onGetMoneyClicked, this.hideAnswersBorderColor, this.hideAnswersFillColor, this.askAudienceFillColor, this.askAudienceBorderColor,
      this.callFriendFillColor, this.callFriendBorderColor);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        (currentMoney > 0)?
        Container(
          height: (40.0 / 853) * MediaQuery.of(context).size.height,
          child: new RaisedButton(
            onPressed: this.onGetMoneyClicked,
            highlightColor: Colors.orange,
            child: SizedBox(
              child: Text(
                'Get money',
                textAlign: TextAlign.center,
                style: new TextStyle(color: Colors.white, fontSize: (18.0 / 853) * MediaQuery.of(context).size.height),
              ),
              width: MediaQuery.of(context).size.width * 25 / 100,
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
            Icon(
              Icons.filter_center_focus,
              size: (25.0 / 853) * MediaQuery.of(context).size.height,
              color: Colors.white,
            ),
                this.onBonusHideClicked,
            borderColor: hideAnswersBorderColor,
            fillColor: hideAnswersFillColor,
          ),
          width: (MediaQuery.of(context).size.width * 70 / 100) / 4,
        ),
        Container(
          child: ButtonCircle(
            Icon(
              Icons.call,
              size: (25.0 / 853) * MediaQuery.of(context).size.height,
              color: Colors.white,
            ),
            this.onBonusCallFriendClicked,
            borderColor: callFriendBorderColor,
            fillColor: callFriendFillColor,
          ),
          width: (MediaQuery.of(context).size.width * 70 / 100) / 4,
        ),
        Container(
          child: ButtonCircle(
            Icon(
              Icons.group,
              size: (25.0 / 853) * MediaQuery.of(context).size.height,
              color: Colors.white,
            ),
            this.onBonusAskAudienceClicked,
            borderColor: askAudienceBorderColor,
            fillColor: askAudienceFillColor,
          ),
          width: (MediaQuery.of(context).size.width * 70 / 100) / 4,
        )
      ],
    );
  }

}