import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '/outils/constantes/collections.dart';
import '/outils/extensions/listes.dart';
import '/outils/extensions/string.dart';

class Filleul {
  final String id;

  final bool primeDebloquee;
  final bool primeRecue;
  final String idParrain;
  String? idUser;
  final String prenom;
  final String email;

  Filleul({
    required this.prenom,
    required this.email,
    required this.id,
    required this.primeDebloquee,
    required this.primeRecue,
    required this.idParrain,
    this.idUser,
  });

  static const f_prenom = "prenom";
  static const f_email = "email";
  static const f_id = "id";
  static const f_primeDebloquee = "primeDebloquee";
  static const f_primeRecue = "primeRecue";
  static const f_idParrain = "idParrain";
  static const f_idUser = "idUser";

  static CollectionReference collection =
      FirebaseFirestore.instance.collection(nomCollectionFilleuls);

  Map<String, dynamic> toMap() {
    var data = Map<String, dynamic>();

    data[f_prenom] = prenom;
    data[f_email] = email;
    data[f_id] = id;
    data[f_primeDebloquee] = primeDebloquee;
    data[f_primeRecue] = primeRecue;
    data[f_idParrain] = idParrain;
    data[f_idUser] = idUser;
    return data;
  }

  static List<Filleul> mockFilleuls(int nbre) {
    List<Filleul> liste = [];

    for (var i = 0; i < 10; i += 1) {
      liste.add(mockFilleul());
    }

    return liste;
  }

  static Filleul mockFilleul() {
    var primeRecue = Filleul(
        prenom: "primeRecue",
        email: "primeRecue@gmail.com",
        id: "id",
        idUser: "tgt",
        primeDebloquee: true,
        primeRecue: true,
        idParrain: "toto");
    var filleulDeclare = Filleul(
        prenom: "filleulDeclare",
        email: "filleulDeclare@gmail.com",
        id: "id",
        primeDebloquee: false,
        primeRecue: false,
        idParrain: "toto");

    var filleulCompteCree = Filleul(
        prenom: "filleulCompteCree",
        email: "filleulCompteCree@gmail.com",
        id: "id",
        idUser: "tgt",
        primeDebloquee: false,
        primeRecue: false,
        idParrain: "toto");
    var filleulAPaye = Filleul(
        prenom: "filleulAPaye",
        email: "filleulAPaye@gmail.com",
        id: "id",
        idUser: "tgt",
        primeDebloquee: true,
        primeRecue: false,
        idParrain: "toto");

    int randInt = (new Random()).nextInt(4);

    return [
      primeRecue,
      filleulDeclare,
      filleulCompteCree,
      filleulAPaye
    ][randInt];
  }

  static Future<Filleul> getById(String id) async {
    late Filleul filleul;
    await collection.where(f_id, isEqualTo: id).get().then((line) {
      if (line.docs.isNotEmpty) {
        filleul =
            Filleul.fromJson(line.docs.first.data() as Map<String, dynamic>);
      }
    }).catchError((e) {
      return null;
    });

    return filleul;
  }

  Filleul.fromJson(Map<String, dynamic> item)
      : prenom = item[f_prenom],
        email = item[f_email],
        id = item[f_id],
        primeDebloquee = item[f_primeDebloquee],
        primeRecue = item[f_primeRecue],
        idParrain = item[f_idParrain],
        idUser = item[f_idUser];

  delete() async {
    return await collection.doc(id).delete();
  }

  save() async {
    return await collection.doc(id).set(toMap());
  }

  static Future<Filleul?> getByEmail(String inEmail) async {
    Filleul? doc;

    await collection.where(f_email, isEqualTo: inEmail).get().then((snap) {
      if (snap.docs.isNotEmpty) {
        doc = Filleul.fromJson(snap.docs.first.data() as Map<String, dynamic>);
      }
    }).catchError((e) {});

    return doc;
  }

  static Future<bool> exists(String inEmail) async {
    var doc = (await collection.get()).docs.firstWhereOrNullListe((element) =>
        Filleul.fromJson(element.data() as Map<String, dynamic>)
            .email
            .toLowerAndTrim() ==
        inEmail.toLowerAndTrim());
    return (doc != null);
  }
}
