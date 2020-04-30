import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {

  String title = 'Millionaire quiz';

  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(),
        );
  }
}