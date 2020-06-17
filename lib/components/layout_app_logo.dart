import 'package:flutter/cupertino.dart';

class LayoutAppLogo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (180.0 / 853) * MediaQuery.of(context).size.height,
      height: (180.0 / 853) * MediaQuery.of(context).size.height,
      child: Image.asset(
          'assets/logo.png'
      ),
    );
  }

}