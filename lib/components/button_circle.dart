import 'package:flutter/material.dart';

class ButtonCircle extends StatelessWidget {

  Widget icon;
  Color borderColor, fillColor;
  Function onPress;

  ButtonCircle(this.icon, this.onPress, {this.borderColor: Colors.blue, this.fillColor: Colors.black});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPress,
      highlightColor: Colors.orange,
      elevation: 2.0,
      fillColor: this.fillColor,
      child: this.icon,
      padding: EdgeInsets.all(15.0),
      shape: CircleBorder(side: BorderSide(color: this.borderColor, width: 4.0)),
    );
  }

}