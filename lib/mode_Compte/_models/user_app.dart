import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/mode_Compte/_models/filleul.dart';
import '/outils/constantes/collections.dart';
import '/outils/constantes/colors.dart';
import '/outils/extensions/listes.dart';
import '/outils/extensions/string.dart';
import '/outils/fonctions/dates.dart';
import '/providers/theme/elements/main.dart';
import '/providers/user_app.dart';

class UserPhone {
  String id;
  bool isAnonymous;

  UserPhone({required this.id, this.isAnonymous = false});
}

class UserApp {
  bool isAdmin;
  String id;
  String email;
  String nom;
  String prenom;
  String nroTel;
  List<dynamic> idsCeremonies;
  List<dynamic> idsFilleuls;
  String? token;
  static CollectionReference collection =
      FirebaseFirestore.instance.collection(nomCollectionUsers);

  static const u_id = "id";
  static const u_email = "email";
  static const u_nom = "nom";
  static const u_prenom = "prenom";
  static const u_nroTel = "nroTel";
  static const u_idsCeremonies = "idsCeremonies";
  static const u_idsFilleuls = "idsFilleuls";
  static const u_token = "token";
  static const u_isAdmin = "isAdmin";

  UserApp(
      {required this.id,
      required this.email,
      required this.nom,
      required this.prenom,
      required this.nroTel,
      required this.idsCeremonies,
      this.isAdmin = false,
      this.token,
      required this.idsFilleuls});

  save(BuildContext context) async {
    context.read<UserAppProvider>().refresh(this);
    return await collection.doc(id).set(toMap());
  }

  static Future<void> saveToken(String idAdh, String token) async {
    return await collection.doc(idAdh).update({u_token: token});
  }

  Map<String, dynamic> toMap() {
    var data = Map<String, dynamic>();

    data[u_id] = id;
    data[u_nom] = nom;
    data[u_prenom] = prenom;
    data[u_email] = email;
    data[u_nroTel] = nroTel;
    data[u_token] = token;
    data[u_isAdmin] = isAdmin;
    data[u_idsCeremonies] = idsCeremonies;
    data[u_idsFilleuls] = idsFilleuls;

    return data;
  }

  UserApp.fromJson(Map<String, dynamic> item)
      : this.id = item[u_id],
        this.nom = item[u_nom],
        this.prenom = item[u_prenom],
        this.email = item[u_email],
        this.nroTel = item[u_nroTel],
        this.token = item[u_token],
        this.isAdmin = item[u_isAdmin] ?? false,
        this.idsCeremonies = item[u_idsCeremonies],
        this.idsFilleuls = item[u_idsFilleuls] ?? [];

  Comparator<UserApp> comparator = (a1, a2) {
    int comparePrenom = a1.nom.compareTo(a2.nom);
    int compareNom = a1.prenom.compareTo(a2.prenom);

    if (comparePrenom == 0) {
      return compareNom;
    } else {
      return comparePrenom;
    }
  };

  Stream<QuerySnapshot> getListeAdherents() {
    return collection.snapshots();
  }

  List<UserApp> qsToList(QuerySnapshot data) {
    List<UserApp> all = [];
    data.docs.forEach((element) {
      all.add(UserApp.fromJson(element.data() as Map<String, dynamic>));
    });

    all.sort(comparator);

    return all;
  }

  Future<List<Filleul>> filleuls() async {
    await wait(nbreSeconde: 2);
    return await Future.wait(
        this.idsFilleuls.map((i) async => await Filleul.getById(i)));
  }
  String get nomPrenom {
    return this.prenom.trim().upperDebut() + " " + this.nom.trim().toUpperCase();
  }

  static Future<bool> exists(String inEmail) async {
    var doc = (await collection.get()).docs.firstWhereOrNullListe((element) =>
        UserApp.fromJson(element.data() as Map<String, dynamic>)
            .email
            .toLowerAndTrim() ==
        inEmail.toLowerAndTrim());
    return (doc != null);
  }

  String initials() {
    return (prenom.substring(0, 1) + nom.substring(0, 1)).toUpperCase();
  }

  Widget avatar(BuildContext context, {double radius = 20}) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius * 2),
          border: Border.all(
              color: ThemeElements(context: context).whichBlue, width: 1)),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.yellowAccent,
        child: Text(
          initials(),
          style: ThemeElements(context: context).styleText(
              color: dBlack,
              fontWeight: FontWeight.bold,
              fontSize: radius * 0.8),
        ),
      ),
    );
  }
}
