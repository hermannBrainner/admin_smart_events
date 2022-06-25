import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '/outils/constantes/collections.dart';
import '/outils/extensions/string.dart';
import '/outils/widgets/main.dart';

class IdentifiantEvent {
  final String id;
  String username;
  String password;
  final String idEvent;

  IdentifiantEvent({
    required this.id,
    required this.username,
    required this.password,
    required this.idEvent,
  });

  static const i_username = "username";
  static const i_password = "password";
  static const i_idEvent = "idEvent";

  static CollectionReference collection =
      FirebaseFirestore.instance.collection(nomCollectionIdentifiants);

  Map<String, dynamic> toMap() {
    var data = Map<String, dynamic>();
    data['id'] = id;
    data[i_password] = password.toLowerAndTrim();
    data[i_username] = username.toLowerAndTrim();
    data[i_idEvent] = idEvent.toLowerAndTrim();
    return data;
  }

  IdentifiantEvent.fromJson(Map<String, dynamic> item)
      : id = item['id'],
        password = item[i_password],
        username = item[i_username],
        idEvent = item[i_idEvent];

  static Future<IdentifiantEvent?> getOne(BuildContext? context,
      {required String inUserName}) async {
    IdentifiantEvent? idEvent;

    await collection
        .where(i_username, isEqualTo: inUserName)
        .get()
        .then((event) {
      if (event.docs.isNotEmpty) {
        idEvent = IdentifiantEvent.fromJson(
            event.docs.first.data() as Map<String, dynamic>);
      }
    }).catchError((e) {
      if (context != null) showFlushbar(context, false, "", e.toString());
    });

    return idEvent;
  }

  static Future<bool> exists(String inUserName) async {
    var doc = (await collection.get()).docs.firstWhereOrNull((element) =>
        IdentifiantEvent.fromJson(element.data() as Map<String, dynamic>)
            .username
            .toLowerAndTrim() ==
        inUserName.toLowerAndTrim());
    return (doc != null);
  }

  delete() async {
    return await collection.doc(id).delete();
  }

  save() async {
    return await collection.doc(id).set(toMap());
  }

  static Stream<QuerySnapshot> all() {
    return collection.snapshots();
  }
}
