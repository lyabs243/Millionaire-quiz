import 'package:flutter/material.dart';
import 'package:millionaire_quiz/components/layout_load.dart';
import 'package:millionaire_quiz/models/money_mangement.dart';
import 'package:millionaire_quiz/models/user.dart';
import 'package:millionaire_quiz/services/localizations.dart';
import '../models/leaderboard.dart';

class DialogTopLeadBoard extends StatefulWidget {

  @override
  _DialogTopLeadBoard createState() {
    return _DialogTopLeadBoard();
  }

}

class _DialogTopLeadBoard extends State<DialogTopLeadBoard> {

  List<LeaderBoard> leaderBoards = [];
  LeaderBoard currentUserLeaderBoard;
  bool isLoading = true, listviewBottom = false;
  int selectedButton = 0;
  int page = 1, numberItems = 10, perWeek;
  ScrollController _controller;
  User currentUser;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    User.getInstance().then((_user) {
      setState(() {
        currentUser = _user;
      });
      initLeaderBoard();
    });
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      addLeaderBoard();
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

  void initLeaderBoard({perWeek: 1}) {
    setState(() {
      isLoading = true;
      page = 1;
    });
    int start = (page-1) * numberItems;
    LeaderBoard.getLeaderBoard(context, start, numberItems, perWeek: perWeek).then((value) {
      setState(() {
        leaderBoards = value;
        if (value.length > 0) {
          page++;
        }
      });
      //get leaderboard of current user
      LeaderBoard.getLeaderBoard(context, 0, 0, perWeek: perWeek, idAccount: currentUser.id).then((value) {
        setState(() {
          currentUserLeaderBoard = null;
          if (value != null && value.length > 0) {
            currentUserLeaderBoard = value[0];
          }
          isLoading = false;
        });
      });
    });
  }

  void addLeaderBoard() {
    setState(() {
      listviewBottom = true;
    });
    int start = (page-1) * numberItems;
    LeaderBoard.getLeaderBoard(context, start, numberItems, perWeek: perWeek).then((value) {
      setState(() {
        //add or init values
        leaderBoards.addAll(value);
        if (value.length > 0) {
          page++;
        }
        listviewBottom = false;
      });
    });
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
            children: dialogWidgets(),
          ),
        ],
      ),
    );
  }

  Widget dialogBottomBar() {
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

  List<Widget> dialogWidgets() {
    List<Widget> widgets = [];

    widgets.add(Text(
      MyLocalizations.of(context).localization['top_leadboard'],
      textAlign: TextAlign.center,
      textScaleFactor: 2.2,
      style: TextStyle(
          fontSize: (16.0 / 853) * MediaQuery.of(context).size.height,
          color: Colors.white
      ),
    ));
    widgets.add(Padding(padding: EdgeInsets.only(top: 10.0, bottom: 10.0),));
    widgets.add(Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 25 / 100,
            height: 40.0,
            child: new RaisedButton(
              onPressed: () {
                setState(() {
                  selectedButton = 0;
                  page = 1;
                });
                perWeek = 1;
                initLeaderBoard(perWeek: 1);
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
                        style: new TextStyle(
                            color: Colors.white,
                            fontSize: (15.0 / 853) * MediaQuery.of(context).size.height
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              color: (selectedButton == 0)? Theme.of(context).primaryColor: Colors.black,
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
                setState(() {
                  selectedButton = 1;
                  page = 1;
                });
                perWeek = 0;
                initLeaderBoard(perWeek: 0);
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
                        style: new TextStyle(
                            color: Colors.white,
                            fontSize: (15.0 / 853) * MediaQuery.of(context).size.height
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //],
              //),
              color: (selectedButton == 1)? Theme.of(context).primaryColor: Colors.black,
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
    ));
    widgets.add(Padding(padding: EdgeInsets.only(top: 10.0, bottom: 10.0),));

    if (!isLoading) {
      if (currentUserLeaderBoard != null) {
        widgets.add(RichText(
          textAlign: TextAlign.center,
          text: new TextSpan(
            children: [
              new TextSpan(
                text: '${MyLocalizations.of(context).localization['you_reached']} ',
                style: new TextStyle(color: Colors.white, fontSize: (20.0 / 853) * MediaQuery.of(context).size.height),
              ),
              new TextSpan(
                text: '\$ ${MoneyManagement.moneyDescriptionReduce(currentUserLeaderBoard.total)}',
                style: new TextStyle(color: Colors.yellow,fontSize: (28.0 / 853) * MediaQuery.of(context).size.height),
              ),
            ],
          ),
        ));
      }
      widgets.add(Padding(padding: EdgeInsets.only(top: 10.0, bottom: 10.0),));
      widgets.add(Expanded(
        child: ListView.builder(
          controller: _controller,
          itemBuilder: (context, index) {
          return Container(
            color: (currentUser.id == leaderBoards[index].idAccount)? Colors.blue[900]: Colors.black,
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
                    leaderBoards[index].urlProfilPic,
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
                    leaderBoards[index].fullName,
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
                    '\$ ${MoneyManagement.moneyDescriptionReduce(leaderBoards[index].total)}',
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
          itemCount: leaderBoards.length,),
      ));
      if (listviewBottom) {
        widgets.add(Container(
          height: 55.0,
          child: Center(child:CircularProgressIndicator()),
        ));
      }
    }
    else {
      widgets.add(Container(
        child: LayoutLoad(),
        height: MediaQuery.of(context).size.height * 60 / 100,
      ));
    }

    widgets.add(dialogBottomBar());

    return widgets;
  }

}

class Consts {
  Consts._();

  static const double padding = 10.0;
  static const double avatarRadius = 66.0;
}