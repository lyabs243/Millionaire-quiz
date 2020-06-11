import 'package:flutter/material.dart';
import 'package:millionaire_quiz/services/localizations.dart';
import '../../../../models/money_mangement.dart';
import 'package:admob_flutter/admob_flutter.dart';
import '../../../../services/constants.dart' as constants;

class DialogGameFinished extends StatelessWidget {

  int earningValue = 0;
  bool jackpot, playAgain = false;
  String eaningValueDescription = '0';
  AdmobBanner admobBanner;
  AdmobInterstitial interstitialAd;
  BuildContext _context;

  DialogGameFinished(this.earningValue, {this.jackpot: false}) {
    if(constants.SHOW_ADMOB) {
      interstitialAd = AdmobInterstitial(
        adUnitId: constants.ADMOB_INTERSTITIAL_ID,
        listener: (AdmobAdEvent event, Map<String, dynamic> args) async {
          if (event == AdmobAdEvent.closed ||
              event == AdmobAdEvent.failedToLoad) {
            Navigator.of(_context).pop(playAgain);
          }
        },
      );
    }
    if(earningValue > 0) {
      eaningValueDescription =
          MoneyManagement.jackpotsText[MoneyManagement.jackpots.indexOf(
              this.earningValue)].trim();
    }
  }


  @override
  Widget build(BuildContext context) {
    _context = context;
    if(constants.SHOW_ADMOB) {
      interstitialAd.isLoaded.then((value) {
        if (!value) {
          interstitialAd.load();
        }
      });
      admobBanner = AdmobBanner(
        adUnitId: constants.ADMOB_BANNER_ID,
        adSize: AdmobBannerSize.LARGE_BANNER,
        listener: (AdmobAdEvent event, Map<String, dynamic> args) {},
      );
    }
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
    return WillPopScope(
      child: Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: Consts.avatarRadius + Consts.padding,
            bottom: Consts.padding,
            left: Consts.padding,
            right: Consts.padding,
          ),
          margin: EdgeInsets.only(top: Consts.avatarRadius),
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
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                (jackpot)? MyLocalizations.of(context).localization['jackpot']
                : MyLocalizations.of(context).localization['game_over'],
                style: TextStyle(
                  fontSize: (24.0 / 853) * MediaQuery.of(context).size.height,
                  fontWeight: FontWeight.w700,
                  color: Colors.white
                ),
              ),
              SizedBox(height: (8.0 / 853) * MediaQuery.of(context).size.height),
              (constants.SHOW_ADMOB)?
              Container(
                child: admobBanner,
              ): Container(),
              SizedBox(height: (8.0 / 853) * MediaQuery.of(context).size.height),
              Container(
                height: MediaQuery.of(context).size.height / 8,
                child: Image.asset(
                  'assets/ic_dol.png'
                ),
              ),
              SizedBox(height: (16.0 / 853) * MediaQuery.of(context).size.height),
              Text(
                (jackpot)? '${MyLocalizations.of(context).localization['congratulation_you_millionaire']}!'
                    ' ${MyLocalizations.of(context).localization['get_your_check_of']} \$ $eaningValueDescription !'
                : '${MyLocalizations.of(context).localization['you_not_millionaire']}... '
                    '${MyLocalizations.of(context).localization['you_earn']} \$ $eaningValueDescription !',
                textAlign: TextAlign.center,
                textScaleFactor: 1.2,
                style: TextStyle(
                  fontSize: (16.0 / 853) * MediaQuery.of(context).size.height,
                  color: Colors.white
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
                        playAgain = false;
                        if(constants.SHOW_ADMOB) {
                          interstitialAd.show();
                        }
                        else {
                          Navigator.of(_context).pop(playAgain);
                        }
                      },
                      child: Text(
                        MyLocalizations.of(context).localization['go_home'],
                        style: TextStyle(
                            color: Theme.of(context).primaryColor
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        playAgain = true;
                        if(constants.SHOW_ADMOB) {
                          interstitialAd.show();
                        }
                        else {
                          Navigator.of(_context).pop(playAgain);
                        }
                      },
                      child: Text(
                        MyLocalizations.of(context).localization['play_again'],
                        style: TextStyle(
                            color: Theme.of(context).primaryColor
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: Consts.padding,
          right: Consts.padding,
          child: Container(
            child: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                '${MoneyManagement.moneyDescriptionReduce(earningValue)}',
                textScaleFactor: 2.5,
                style: TextStyle(
                  color: Colors.yellow,
                  fontWeight: FontWeight.bold
                ),
              ),
              radius: Consts.avatarRadius,
            ),
          )
        ),//...top circlular image part,
      ],
    ),
      onWillPop: () {

      },
    );
  }

}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}