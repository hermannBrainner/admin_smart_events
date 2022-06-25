import 'package:flutter/material.dart';

import 'widgets/main.dart';

class Chargement extends StatefulWidget {
  @override
  _ChargementState createState() => _ChargementState();
}

class _ChargementState extends State<Chargement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      alignment: Alignment.center,
      child: Column(children: <Widget>[
        Image.asset("assets/logo.png", height: 100, width: 100),
        SizedBox(height: 30.0),
        getLoadingWidget(context)
      ]),
    ));
  }
}
