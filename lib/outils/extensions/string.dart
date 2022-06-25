import 'package:flutter/material.dart';

import '../fonctions/fonctions.dart';

/// NUM Extensions

extension NumberExtension on num {
  bool get isInteger => (this % 1) == 0;

  bool get isDecimal => (this % 1) != 0;
}

/// STRING EXTENSION

extension StringEtendu on String {
  String toStringDate() {
    var pipe = '/';

    return forcerAvec0_devant(this.split(pipe)[0]) +
        pipe +
        forcerAvec0_devant(this.split(pipe)[1]) +
        pipe +
        this.split(pipe)[2];
  }

  bool isInt() {
    num? chiffre = double.tryParse(this);

    if (chiffre != null) return chiffre.isInteger;

    return false;
  }

  Color couleurFromHex() {
    return Color(
        int.parse(this.split("Color(").last.replaceAll(")", "").trim()));
  }

  String toLowerAndTrim() {
    return this.toLowerCase().replaceAll(" ", "").trim();
  }

  String upperDebut() {
    if (isNullOrEmpty(this.trim())) {
      return "Null";
    }

    String space = " ";
    String s = this;

    while (s.contains(space + space)) {
      s = s.replaceAll(space + space, space).trim();
    }

    String cap = "";

    for (String elt in s.trim().split(space)) {
      cap = cap + space + elt[0].toUpperCase() + elt.toLowerCase().substring(1);
    }

    return cap;
  }

  bool isValidEmail() {
    if (isNullOrEmpty(this)) {
      return false;
    }

    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this.toLowerAndTrim());
  }
}

extension EmailValidator on String {}
