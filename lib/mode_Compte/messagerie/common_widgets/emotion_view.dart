import 'package:flutter/material.dart';

oneEmoticone(String emo, int nbreEmo, double safeBlockHorizontal,
    {Color coulFond = const Color.fromRGBO(228, 230, 235, 1)}) {
  return Container(
    width: nbreEmo < 10 ? safeBlockHorizontal * 9 : safeBlockHorizontal * 12,
    height: safeBlockHorizontal * 7,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.white, width: 2.0),
      color: coulFond,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Center(
        child: Text(
      emo + nbreEmo.toString(),
      textAlign: TextAlign.center,
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: safeBlockHorizontal * 4),
    )),
  );
}
