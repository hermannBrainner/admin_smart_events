import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/mode_Compte/_controllers/ceremonie.dart';
import '/mode_Compte/_models/billet.dart';
import '/mode_Compte/_models/identifiants.dart';
import '/mode_Compte/_models/table.dart';
import '/mode_Compte/_models/zone.dart';
import '/outils/constantes/collections.dart';
import '/outils/constantes/strings.dart';
import '/outils/extensions/time.dart';
import '/outils/file_manager.dart';
import '/outils/fonctions/fonctions.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/strings.dart';
import '/providers/user_app.dart';
import '../_controllers/billet.dart';
import '../_controllers/table.dart';
import '../_controllers/zone.dart';
import '../billets_acces/imported/main.dart';
import 'user_app.dart';

class Ceremonie {
  String id;

  String titreCeremonie;
  String? urlPhoto_Profil;
  String username;

  String idAdmin;

  String lieuCeremonie;

  String mdp;
  double nbreBillets;
  Timestamp dateCeremonie;

  String? urlPrefix;
  bool withTables;

  bool withZones;

  bool yaFirstPage;
  bool yaCouverture;
  List<dynamic> idsTables;

  List<dynamic> idsZones;

  List<dynamic> idsBillets;

  List<dynamic> qrCodesDispo;

  String modePage;

  static CollectionReference collection =
      FirebaseFirestore.instance.collection(nomCollectionCeremonies);

  static const c_id = "id";
  static const c_lieu = "lieu";
  static const c_nbreBillets = "nbreBillets";
  static const c_titreCeremonie = "titreCeremonie";
  static const c_urlPhoto_Profil = "urlPhoto_Profil";
  static const c_username = "username";
  static const c_mdp = "mdp";
  static const c_urlPrefix = "urlPrefix";
  static const c_idAdmin = "idAdmin";
  static const c_dateCeremonie = "dateCeremonie";
  static const c_withTables = "withTables";
  static const c_withZones = "withZones";

  static const c_idsZones = "idsZones";

  static const c_idsTables = "idsTables";

  static const c_idsBillets = "idsBillets";

  static const c_qrCodesDispo = "qrCodesDispo";

  static const c_yaFirstPage = "yaFirstPage";

  static const c_yaCouverture = "yaCouverture";

  static const c_modePage = "modePage";

  static const String billetTemplate = "billet_acces_template";

  static const modeLast = "ModePage.LastPage";
  static const modeDefault = "ModePage.Default";

  Ceremonie(
      {required this.id,
      required this.titreCeremonie,
      required this.nbreBillets,
      required this.urlPhoto_Profil,
      required this.username,
      required this.mdp,
      required this.lieuCeremonie,
      required this.urlPrefix,
      required this.idAdmin,
      required this.dateCeremonie,
      required this.withTables,
      required this.withZones,
      required this.qrCodesDispo,
      required this.idsZones,
      required this.idsTables,
      required this.idsBillets,
      this.yaFirstPage = false,
      this.yaCouverture = false,
      this.modePage = modeDefault});

  String toString() {
    var m = toMap();

    m[Ceremonie.c_dateCeremonie] = dateCeremonie.toStringExt(separator: "/");

    return json.encode(m);
  }

  Map<String, dynamic> toMap() {
    var data = Map<String, dynamic>();

    data[Ceremonie.c_id] = id;
    data[Ceremonie.c_nbreBillets] = nbreBillets;
    data[Ceremonie.c_titreCeremonie] = titreCeremonie;
    data[Ceremonie.c_urlPhoto_Profil] = urlPhoto_Profil;
    data[Ceremonie.c_username] = username;
    data[Ceremonie.c_mdp] = mdp;
    data[Ceremonie.c_urlPrefix] = urlPrefix;
    data[Ceremonie.c_idAdmin] = idAdmin;
    data[Ceremonie.c_lieu] = lieuCeremonie;
    data[Ceremonie.c_dateCeremonie] = dateCeremonie;
    data[Ceremonie.c_withTables] = withTables;
    data[Ceremonie.c_withZones] = withZones;
    data[Ceremonie.c_idsTables] = idsTables;
    data[Ceremonie.c_idsZones] = idsZones;
    data[Ceremonie.c_idsBillets] = idsBillets;
    data[Ceremonie.c_qrCodesDispo] = qrCodesDispo;
    data[Ceremonie.c_yaFirstPage] = yaFirstPage;
    data[Ceremonie.c_yaCouverture] = yaCouverture;
    data[Ceremonie.c_modePage] = modePage;
    return data;
  }

  String quelleDispo() {
    if (withZones && withTables) {
      return Strings.dispoMax;
    } else if (!withZones && withTables) {
      return Strings.dispoMoyen;
    } else {
      return Strings.dispoMin;
    }
  }

  editDisposAndSave(String disposition) async {
    switch (disposition) {
      case Strings.dispoMax:
        withTables = true;
        withZones = true;
        break;
      case Strings.dispoMoyen:
        withTables = true;
        withZones = false;
        break;
      case Strings.dispoMin:
        withTables = false;
        withZones = false;
        break;
      default:
        withTables = true;
        withZones = true;
        break;
    }

    await retraitAllHierachies();
    await save();
  }

  retraitAllHierachies() async {
    // Pour les zones

    await ZoneCtrl.rmvHierachieByIds(idsZones.cast<String>());
    await TableCtrl.rmvHierachieByIds(idsTables.cast<String>());
    await BilletCtrl.rmvHierachieByIds(idsBillets.cast<String>());
  }

  switchModePage() async {
    modePage =
        [modeDefault, modeLast].firstWhere((element) => element != modePage);
    await save();
  }

  save() async {
    return await collection.doc(id).set(toMap());
  }

  delete() async {
    await deletePhoto();
    return await collection.doc(id).delete();
  }

  addDefaultsValues() async {
    List<String> noms = ["M & Mme Test", "M. Test", "Mlle Test"];

    List<Billet> billetsInv = [];

    late String qrCode;
    late Billet billet;

    while ((billetsInv.length < this.nbreBillets) && (billetsInv.length < 3)) {
      qrCode = CeremonieCtrl.getUnusedQrCode(this, billetsInv);
      billet = Billet(
          id: await getNewID(nomCollectionBillets),
          nom: noms[billetsInv.length],
          qrCode: qrCode,
          nbrePersonnes: 1 + (billetsInv.isEmpty ? 1 : 0));
      billetsInv.add(billet);
      await CeremonieCtrl.addBillet(this, billetsInv, billetsInv.last);
    }

    /// Ajout Tables

    late TableInvite tableFamille;
    late TableInvite tableAmis;

    if (this.withTables) {
      tableFamille = TableInvite(
          id: await getNewID(nomCollectionTableInvites),
          nom: "Famille",
          idsEnfants: [billetsInv[0].id],
          couleur: Colors.green.toString());
      await CeremonieCtrl.addTable(this, tableFamille);

      tableAmis = TableInvite(
          id: await getNewID(nomCollectionTableInvites),
          nom: "Amis",
          idsEnfants: List<String>.generate(
              billetsInv.length - 1, (index) => billetsInv[index + 1].id),
          couleur: Colors.orange.toString());
      await CeremonieCtrl.addTable(this, tableAmis);

      /// Assign Billet Parents
      billetsInv.forEach((billet) async {
        if (billetsInv.indexOf(billet) == 0) {
          billet.idParent = tableFamille.id;
        } else {
          billet.idParent = tableAmis.id;
        }

        await billet.save();
      });
    }

    if (this.withZones) {
      Zone zone = Zone(
          id: await getNewID(nomCollectionZones),
          nom: "Aile Ouest",
          idsEnfants: [tableFamille.id, tableAmis.id],
          couleur: Colors.pink.toString());
      await CeremonieCtrl.addZone(this, zone);

      /// Assign Tables a zone Parents

      tableFamille.idParent = zone.id;
      tableAmis.idParent = zone.id;
      await tableFamille.save();
      await tableAmis.save();
    }
  }

  static Comparator<Ceremonie> compDate = (b1, b2) {
    return (b1.dateCeremonie.toDate()).compareTo(b2.dateCeremonie.toDate());
  };

  creation(BuildContext context) async {
    qrCodesDispo = CeremonieCtrl.makeQrCodeList(nbreBillets.toInt());
    await save();

    IdentifiantEvent identifiantEvent = IdentifiantEvent(
        id: (await getNewID(nomCollectionIdentifiants)),
        username: username,
        password: mdp,
        idEvent: id);

    await identifiantEvent.save();

    UserApp userApp = context.read<UserAppProvider>().userApp!;

    userApp.idsCeremonies.add(id);

    await userApp.save(context);
  }

  bool zonesNonDefinies() {
    return withZones && idsZones.cast<String>().isEmpty;
  }

  bool tablesNonDefinies() {
    return withTables && idsTables.cast<String>().isEmpty;
  }

  isSettingFinished() {
    return tablesNonDefinies() || zonesNonDefinies();
  }

  deletePhoto() async {
    await deleteFile(
        chemin: Strings.dossierCouvertures + this.id + Strings.extensionJpg);
  }

  deleteBilletFirstPages() async {
    await deleteFile(chemin: firebasePaths()[c_yaFirstPage]!);
    yaFirstPage = false;
    await save();
  }

  savePhoto(File file) async {
    await saveFile(file: file, chemin: firebasePaths()[c_yaCouverture]!);
    yaCouverture = true;
    await save();
  }

  Future<File?> saveDebutBillet(BuildContext context, File? file) async {
    if (!isNullOrEmpty(file)) {
      file = await addQrCodeOnBillet(file!, this,
          isTemplate: true,
          billet: null,
          fontDatas: context.read<CeremonieProvider>().fontDatas);
      await saveLocalFile(file, firebasePaths()[c_yaFirstPage]!);
      yaFirstPage = true;
      await save();
    }
    return file;
  }

  Map<String, String> firebasePaths() {
    var data = Map<String, String>();

    data[c_yaFirstPage] = localPathBillets + id + Strings.extensionPdf;
    data[c_yaCouverture] =
        Strings.dossierCouvertures + id + Strings.extensionJpg;
    data[billetTemplate] =
        localPathBilletsAccesTemplate + id + Strings.extensionPdf;
    return data;
  }

  Ceremonie.fromJson(Map<String, dynamic> item)
      : this.id = item[c_id],
        this.nbreBillets = item[c_nbreBillets],
        this.titreCeremonie = item[c_titreCeremonie],
        this.urlPhoto_Profil = item[c_urlPhoto_Profil],
        this.username = item[c_username],
        this.mdp = item[c_mdp],
        this.lieuCeremonie = item[c_lieu],
        this.urlPrefix = item[c_urlPrefix],
        this.idAdmin = item[c_idAdmin],
        this.dateCeremonie = item[c_dateCeremonie],
        this.withTables = item[c_withTables],
        this.withZones = item[c_withZones],
        this.idsTables = item[c_idsTables] ?? [],
        this.idsZones = item[c_idsZones] ?? [],
        this.idsBillets = item[c_idsBillets] ?? [],
        this.qrCodesDispo = item[c_qrCodesDispo] ?? [],
        this.yaCouverture = item[c_yaCouverture] ?? false,
        this.yaFirstPage = item[c_yaFirstPage] ?? false,
        this.modePage = item[c_modePage] ?? modeDefault;

  static Ceremonie fromSnapshot(DocumentSnapshot item) {
    return Ceremonie(
        id: item[c_id],
        nbreBillets: item[c_nbreBillets],
        titreCeremonie: item[c_titreCeremonie],
        urlPhoto_Profil: item[c_urlPhoto_Profil],
        username: item[c_username],
        mdp: item[c_mdp],
        lieuCeremonie: item[c_lieu],
        urlPrefix: item[c_urlPrefix],
        idAdmin: item[c_idAdmin],
        dateCeremonie: item[c_dateCeremonie],
        withTables: item[c_withTables],
        withZones: item[c_withZones],
        idsTables: item[c_idsTables] ?? [],
        idsZones: item[c_idsZones] ?? [],
        idsBillets: item[c_idsBillets] ?? [],
        qrCodesDispo: item[c_qrCodesDispo] ?? [],
        modePage: item.data().toString().contains(c_modePage)
            ? item[c_modePage]
            : modeDefault,
        yaCouverture: item.data().toString().contains(c_yaCouverture)
            ? item[c_yaCouverture]
            : false,
        yaFirstPage: item.data().toString().contains(c_yaFirstPage)
            ? item[c_yaFirstPage]
            : false);
  }

  static Comparator<Ceremonie> comparator = (s1, s2) =>
      (s2.dateCeremonie).toDate().compareTo((s1.dateCeremonie).toDate());

  static Future<List<Ceremonie>> userCeremonies(List<String> ids) async {
    List<Ceremonie> all = [];

    for (String id in ids) {
      Ceremonie ceremonie = await CeremonieCtrl.getById(id);
      all.add(ceremonie);
    }

    return all;
  }

  static Stream<QuerySnapshot> all() {
    return collection.snapshots();
  }

  static List<Ceremonie> qsToList(QuerySnapshot data) {
    List<Ceremonie> all = [];
    data.docs.forEach((element) {
      all.add(Ceremonie.fromJson(element.data() as Map<String, dynamic>));
    });

    all.sort(comparator);
    return all;
  }
}
