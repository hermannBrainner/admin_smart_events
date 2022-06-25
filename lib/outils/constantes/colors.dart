import 'dart:math';

import 'package:flutter/material.dart';

const dBlack = Color.fromRGBO(12, 18, 30, 0.9);

const dBlackLeger = Color.fromRGBO(36, 43, 53, 0.9);
const dBlackLegerLeger = Color.fromRGBO(68, 84, 84, 0.9);

const dBlue = Color.fromRGBO(50, 234, 253, 0.9);

const dWhite = Colors.white;
const dWhiteLeger = Colors.white60;

const couleurJauneOr = Color.fromRGBO(255, 235, 211, 0.9);

const colorBleuclair = Color.fromRGBO(240, 255, 255, 1);
const Color couleurVertClair = Color.fromRGBO(154, 205, 51, 0.5);
const Color couleurTheme = dBlue; // Color.fromRGBO(214, 179, 160, 0.8);
const Color couleurBeigeClair = Color.fromRGBO(242, 227, 204, 0.5);
const Color couleurBeigeSombre = Color.fromRGBO(221, 208, 192, 1);
const Color couleurJauneMoutardeClair = Color.fromRGBO(234, 206, 121, 1);
const Color couleurOrange = Color.fromRGBO(255, 153, 51, .9);
const Color couleurRose = Color.fromRGBO(255, 153, 153, .9);
const Color couleurDoree = Color.fromRGBO(196, 170, 109, 1);
const Color couleurDoreeClair = Color.fromRGBO(196, 170, 109, 0.5);
const Color couleurJauneClair = Colors.amberAccent;

const Color couleurBleue = Color.fromRGBO(8, 37, 69, 0.9);

//Couleur Message boxe
const Color couleurSendChat = Color.fromRGBO(68, 190, 199, 1);
const Color couleurReceiveChat = Color.fromRGBO(228, 230, 235, 1);

List<Color> allColors() {
  List<Color> all = [];
  all.addAll(Colors.primaries);
  all.addAll(Colors.accents);

  return all;
}

Color randColor() {
  int taille = allColors().length;

  int randInt = (new Random()).nextInt(taille);

  return allColors()[randInt];
}
