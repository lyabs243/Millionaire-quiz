/**
 * Transition to load new question when player answer correctly
 */

import 'package:flutter/material.dart';
import '../../../models/money_mangement.dart';

class DialogStepTransition extends StatefulWidget {

  int from, to;

  DialogStepTransition(this.from, this.to);

  @override
  _DialogStepTransitionState createState() {
    return _DialogStepTransitionState();
  }

}

class _DialogStepTransitionState extends State<DialogStepTransition> {

  double position, maxPostion;
  bool isAnimating = false;

  @override
  void initState() {
    super.initState();
    //for the first level (500) there is no animation
    if(this.widget.from == -1) {
      position = 530;
      maxPostion = MoneyManagement.jackpotsPositions[0];
    }
    else {
      position = MoneyManagement.jackpotsPositions[this.widget.from];
      maxPostion = MoneyManagement.jackpotsPositions[this.widget.to];
    }
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
    if(!isAnimating) {
      animTransition();
    }
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
                children: getStepsWidgets(),
              ),
              Positioned(
                  top: (position / 853) * MediaQuery.of(context).size.height,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 60 / 100,
                    height: (40.0 / 853) * MediaQuery.of(context).size.height,
                    decoration: new BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.rectangle,
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(Consts.padding),
                    ),
                    child: Container(),
                  )
              )
            ],
          ),
        );
  }

  Future animTransition() async{
    isAnimating = true;
    int start = position.toInt();
    int end = maxPostion.toInt();
    //transition from top to bottom
    if(end >= start) {
      for (int i = start; i <= end; i++) {
        await new Future.delayed(Duration(milliseconds: 25));
        if (mounted) {
          setState(() {
            position = i.toDouble();
          });
        }
      }
    }
    else {
      for (int i = start; i >= end; i--) {
        await new Future.delayed(Duration(milliseconds: 50));
        if (mounted) {
          setState(() {
            position = i.toDouble();
          });
        }
      }
    }
    await new Future.delayed(Duration(milliseconds: 400));
    Navigator.pop(context);
  }

  List<Widget> getStepsWidgets() {
    List<Widget> widgets = [];
    MoneyManagement.jackpotsText.reversed.forEach((element) {
      widgets.add(Container(
        width: MediaQuery.of(context).size.width * 70 /100,
        padding: EdgeInsets.only(top: (3.0 / 853) * MediaQuery.of(context).size.height, bottom: (1.0 / 853) * MediaQuery.of(context).size.height),
        child: Text(
          '\$ $element',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: (MoneyManagement.levelsMinimumMoney.contains(MoneyManagement.jackpots[MoneyManagement.
            jackpotsText.indexOf(element)]))? Colors.yellow : Colors.white,
            fontSize: (28.0 / 853) * MediaQuery.of(context).size.height
          ),
        ),
      ));
    });
    return widgets;
  }

}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}