import 'package:flutter/material.dart';

class DialogGameFinished extends StatelessWidget {

  int earningValue = 50;

  DialogGameFinished(this.earningValue);

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
    return Stack(
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
                'Game Over',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.white
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                height: MediaQuery.of(context).size.height / 8,
                child: Image.asset(
                  'assets/ic_dol.png'
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'You are not millionaire... Your earn $earningValue \$ !',
                textAlign: TextAlign.center,
                textScaleFactor: 1.2,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white
                ),
              ),
              SizedBox(height: 24.0),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(false); // To close the dialog
                      },
                      child: Text(
                        'Go Home',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(true); // To close the dialog
                      },
                      child: Text(
                        'Play Again',
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
                '$earningValue',
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
    );
  }

}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}