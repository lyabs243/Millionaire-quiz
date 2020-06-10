import 'package:flutter/material.dart';

class LayoutLoad extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
            Padding(padding: EdgeInsets.only(bottom: 10.0),),
            Container(
              child: Text(
                'Please wait...',
                textScaleFactor: 2.0,
                style: TextStyle(
                    color: Colors.white
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}