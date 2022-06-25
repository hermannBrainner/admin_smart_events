import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

wait({int nbreSeconde = 5}) async {
  await Future.delayed(Duration(seconds: nbreSeconde), () {});
}

test() {
  Timestamp? lastExport;

  List<DateTime> times = [
    DateTime.now()
        .subtract(Duration(days: 3, hours: 2))
        .add(Duration(hours: 2))
        .subtract(Duration(days: 2)),
    DateTime.now().subtract(Duration(days: 3, hours: 2)),
    DateTime.now()
        .subtract(Duration(days: 3, hours: 2))
        .subtract(Duration(days: 2, minutes: 400)),
    DateTime.now().add(Duration(hours: 5)),
    DateTime.now()
        .subtract(Duration(days: 3, hours: 2))
        .add(Duration(hours: 5))
        .subtract(Duration(days: 2)),
  ];

  DateTime dateTemoin = DateTime(2099, 1, 1, 1, 0);
  print(times);
}
