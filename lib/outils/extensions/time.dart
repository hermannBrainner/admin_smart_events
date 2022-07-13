import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../fonctions/fonctions.dart';

extension TimeTools on Timestamp {
  List<String> joursHeuresRestant() {
    List<int> jH_int = this.toDate().jHRestant();

    if (jH_int[1] < 0) {
      return ["00", "00"];
    } else if (jH_int[1] < 24) {
      return ["00", forcerAvec0_devant(jH_int[1].toString())];
    } else if (jH_int[0] > 99) {
      return [jH_int[0].toString(), forcerAvec0_devant(jH_int[1].toString())];
    }

    return [
      forcerAvec0_devant(jH_int[0].toString()),
      forcerAvec0_devant(jH_int[1].toString())
    ];
  }

  bool isBeforeToday() {
    return this.toDate().isBeforeToday();
  }

  bool isToday() {
    return this.toDate().isToday();
  }

  String toStringDMY() {
    return this.toDate().toStringDMY();
  }

  String toStringComplete() {
    return this.toDate().toStringComplete();
  }

  String toStringExt({String separator = '.'}) {
    String jour = ("0" + this.toDate().day.toString()).substring(
        ("0" + this.toDate().day.toString()).length - 2,
        ("0" + this.toDate().day.toString()).length);
    String mois = ("0" + this.toDate().month.toString()).substring(
        ("0" + this.toDate().month.toString()).length - 2,
        ("0" + this.toDate().month.toString()).length);
    String annEe = this.toDate().year.toString();

    return jour + separator + mois + separator + annEe;
  }

  String hourString({String separator = ':'}) {
    String heure = forcerAvec0_devant(this.toDate().hour.toString());
    String minute = forcerAvec0_devant(this.toDate().minute.toString());
    return heure + separator + minute;
  }
}

extension TimeTools_DateTime on DateTime {

  String toStringDMY(){
    return DateFormat('dd/MM/yyyy').format(this);
  }

  String toStringComplete() {
    return DateFormat('dd.MM.yyyy HH:mm:ss').format(this);
  }

  List<int> jHRestant() {
    int totalHeures = this.difference(DateTime.now()).inHours;

    int resteHeures = totalHeures % 24;
    int resteJours = ((totalHeures - resteHeures) / 24).truncate();

    return [resteJours, resteHeures];
  }

  bool isToday() {
    DateTime now = DateTime.now();
    return DateTime(this.year, this.month, this.day)
            .difference(DateTime(now.year, now.month, now.day))
            .inDays ==
        0;
  }

  bool isBeforeToday() {
    DateTime now = DateTime.now();

    return DateTime(this.year, this.month, this.day)
            .difference(DateTime(now.year, now.month, now.day))
            .inDays <
        0;
  }
}

extension TimeTools_TimeOfDay on TimeOfDay {
  String hourString({String separator = ':'}) {
    String heure = forcerAvec0_devant(this.hour.toString());
    String minute = forcerAvec0_devant(this.minute.toString());
    return heure + separator + minute;
  }
}
