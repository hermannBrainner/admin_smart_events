import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:validators/validators.dart';

import '/outils/extensions/string.dart';
import '/providers/theme/strings.dart';
import '../constantes/collections.dart';
import '../constantes/strings.dart';

envoieSMS(BuildContext context, {required String message}) async {
  final RenderBox box = context.findRenderObject() as RenderBox;

  await Share.share(message,
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);

  /*String _result = await sendSMS(message: message, recipients: [ ])
      .catchError((onError) {
    print(onError);
  });
  print(_result);*/
}

blackOrWhite_formLuminance(Color color) {
  return color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
}

saveFile({required File file, required String chemin}) async {
  Reference fichier = FirebaseStorage.instance.ref().child(chemin);

  UploadTask uploadTask = fichier.putFile(file);
  TaskSnapshot taskSnapshot = await uploadTask.snapshotEvents.first;

  taskSnapshot.ref.getDownloadURL().then((value) {});
}

Future<String?> getFileUrl({required String chemin}) async {
  Reference fichier = FirebaseStorage.instance.ref().child(chemin);
  try {
    var urlFichier = await fichier.getDownloadURL();

    return urlFichier;
  } catch (err) {
    return null;
  }
}

deleteFile({required String chemin}) async {
  String? url = await getFileUrl(chemin: chemin);

  if (!isNullOrEmpty(url)) {
    await FirebaseStorage.instance.refFromURL(url!).delete();
  }
}

Future<File?> getFile_storage() async {
  FilePickerResult? result = (await FilePicker.platform.pickFiles(
    type: FileType.any,
    allowMultiple: false,
  ));

  if (!isNullOrEmpty(result)) {
    return File(result!.files.first.path!);
  } else {
    return null;
  }
}

bool isUrlValid(String val) {
  if (isNullOrEmpty(val)) return false;

  return Uri.parse(val).isAbsolute && isURL(val);
}

Future<Map<String, String>> getAppInfos() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  var retour = {
    "APP": packageInfo.appName,
    "PACKAGE": packageInfo.packageName,
    "VERSION": packageInfo.version,
    "BUIL_NUMBER": packageInfo.buildNumber,
  };

  return retour;
}

bool isNullOrEmpty(dynamic val) {
  return ["", Strings.na, null, false, 0, Null].contains(val);
}

supprimerCollection(String col) async {
  CollectionReference c = FirebaseFirestore.instance.collection(col);

  await c.get().then((snapshot) {
    for (DocumentSnapshot ds in snapshot.docs) {
      ds.reference.delete();
    }
  });
}

String toTrimAndCase(var string,
    {bool replaceWhiteInside = true, bool isLower = true}) {
  String s = string.toString().trim().toLowerCase();

  if (replaceWhiteInside) s = s.replaceAll(" ", "");
  if (!isLower) s = s.toUpperCase();

  return s;
}

saveCodeRandom() {
  CollectionReference collectionOutils =
      FirebaseFirestore.instance.collection(nomCollectionOutils);

  String code = genererCodeRandom();

  collectionOutils
      .doc("CodeValidation")
      .set({"code": code}).whenComplete(() {});
}

Stream<QuerySnapshot> allOutils() {
  CollectionReference c =
      FirebaseFirestore.instance.collection(nomCollectionOutils);
  return c.snapshots();
}

bool stringAreEqual(String first, String second) {
  return first.toLowerCase().trim() == second.toLowerCase().trim();
}

Future<void> phoneCall(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Map<String, String> jsonNAME(var person) {
  if (person == null) {
    return {
      "NOM": NA,
      "PRENOM": NA,
      "NOM_PRENOM": NA,
      "PRENOM_NOM": NA,
      "INITIALS": NA
    };
  } else {
    return {
      "NOM": person.nom.trim().toUpperCase(),
      "PRENOM": person.prenom.trim().capitalize(),
      "NOM_PRENOM": person.nom.trim().toUpperCase() +
          " " +
          person.prenom.trim().capitalize(),
      "PRENOM_NOM": person.prenom.trim().capitalize() +
          " " +
          person.nom.trim().toUpperCase(),
      "INITIALS": (person.prenom.trim().substring(0, 1) +
              person.nom.trim().substring(0, 1))
          .toUpperCase()
    };
  }
}

bool boolValue(dynamic val) {
  return val.toString().toLowerCase() == "true";
}

Map<String, String> jsonName(String inNom) {
  inNom = inNom.trim();
  var pipe = '|';
  var prenom = (inNom.split(pipe)[1].toLowerCase());
  var nom = inNom.split(pipe)[0].toLowerCase();

  return {
    "NOM": nom.toUpperCase(),
    "PRENOM": prenom.upperDebut(),
    "PRENOM_NOM": prenom.upperDebut() + " " + nom.toUpperCase(),
    "INITIALS": (prenom.substring(0, 1) + nom.substring(0, 1)).toUpperCase()
  };
}

Future<bool> objectExists(String idObject,
    {String nomCollection = nomCollectionUsers}) async {
  DocumentSnapshot ds = await FirebaseFirestore.instance
      .collection(nomCollection)
      .doc(idObject)
      .get();
  return ds.exists;
}

supprimerObjet(String id, String col) {
  CollectionReference c = FirebaseFirestore.instance.collection(col);
  return c.doc(id).delete();
}

int getRandom({int max = 100}) {
  var rng = new Random();
  return rng.nextInt(max);
}

//generer code aléatoire
String genererCodeRandom({int nbreDigits = 4}) {
  var rng = new Random();
  String code = "";
  for (var i = 0; i < nbreDigits; i++) {
    code += rng.nextInt(10).toString();
  }
  return code;
}

//Make SnackBar

makeSnackBar(BuildContext context, String msge, ColorSwatch<int> couleurTexte) {
  final SnackBar s = SnackBar(
    content: Text(msge),
    action: SnackBarAction(
      label: "OK",
      textColor: couleurTexte,
      onPressed: () {},
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(s);
}

Future<File> fileFromDocsDir(String filename) async {
  Directory _appDocsDir = await getApplicationDocumentsDirectory();
  String pathName = p.join(_appDocsDir.path, filename);
  return File(pathName);
}

String cleanId(String texte) {
  return texte
      .replaceAll(new RegExp(r"#"), "")
      .replaceAll(new RegExp(r"\["), "")
      .replaceAll(new RegExp(r"\]"), "");
}

Timestamp stringToTimestamp(String inDate) {
  var pipe = '/';
  return Timestamp.fromDate(DateTime(int.parse(inDate.split(pipe)[2]),
      int.parse(inDate.split(pipe)[1]), int.parse(inDate.split(pipe)[0]), 12));
}

String montantFCFA(double montant) {
  return NumberFormat.simpleCurrency(locale: 'eu')
      .format(montant)
      .replaceAll(",00", "")
      .replaceAll("€", "FCFA");
}

String doubleToString(double d, {int precision = 2}) {
  String s = d.toStringAsFixed(precision);

  try {
    if (int.parse(s.split('.')[1]) == 0) {
      s = s.replaceAll("." + s.split('.')[1], '');
    }
  } on RangeError {
    s = "0";
  }

  return s;
}

montantMilliers(double montant) {
  var data = Map<String, String>();

  int millier = (montant / 1000).truncate();
  int centaines = ((montant / 1000 - millier) * 1000).round();

  data[MILLIERS] = millier.toString();
  data[CENTAINES] =
      forcerAvec0_derriere(centaines.toString(), nbreCaracteres: 3);

  return data;
}

String formatageMontant(String mtt) {
  if (mtt.isEmpty) {
    return montantFCFA(0);
  } else if (mtt == "") {
    return montantFCFA(0);
  } else if (mtt == NA) {
    return montantFCFA(0);
  } else {
    return montantFCFA(stringToDouble(mtt));
  }
}

String _doubleToString(double montant) {
  int coeff = 100;

  bool isNegative = montant < 0;
  montant = (isNegative ? (-1) : (1)) * montant;
  int valEntier = int.parse(montant.toStringAsFixed(0));
  if (!isNegative && valEntier > montant) {
    valEntier = valEntier - 1;
  }
  int valDec = int.parse(((montant - valEntier) * coeff).toStringAsFixed(0));

  String signe = isNegative ? "-" : "";

  return (valDec == 0)
      ? signe + valEntier.toString()
      : signe +
          valEntier.toString() +
          "," +
          forcerAvec0_derriere(valDec.toString() + "00");
}

double stringToDouble(String s) {
  return double.parse(s.replaceAll(' ', '').replaceAll(',', '.'));
}

bool isStringNumeric(String s) {
  if (s == null) {
    return false;
  } else {
    s = s.replaceAll(' ', '').replaceAll(',', '.');
    return double.tryParse(s) != null;
  }
}

String forcerAvec0_derriere(String val, {int nbreCaracteres = 2}) {
  String ver = val.toString() + "000";

  return ver.substring(0, nbreCaracteres);
}

String forcerAvec0_devant(String val, {int nbreCaracteres = 2}) {
  String ver = "0000000000" + val.toString();

  return ver.substring(ver.length - nbreCaracteres, ver.length);
}

String transformNumber(String nro, {String prefix = "+33"}) {
  return forcerAvec0_devant(nro, nbreCaracteres: 10).replaceRange(0, 1, prefix);
}

getTempsPassE_String(DateTime maintenant, DateTime heurePost) {
  Duration difference = maintenant.difference(heurePost);
  if (difference.inSeconds < 60) {
    return "il y a " +
        forcerAvec0_devant(difference.inSeconds.toString()) +
        " secondes";
  } else if (difference.inMinutes < 60) {
    return "il y a " +
        forcerAvec0_devant(difference.inMinutes.toString()) +
        " minutes";
  } else if (difference.inHours > maintenant.hour) {
    return "Hier à " +
        forcerAvec0_devant(heurePost.hour.toString()) +
        ":" +
        forcerAvec0_devant(heurePost.minute.toString());
  } else {
    return "il y a " +
        forcerAvec0_devant(difference.inHours.toString()) +
        " heures";
  }
}

//Contrôler si un numéro de téléphone est bon

bool checkPhoneNumber(String? nro) {
  if (isNullOrEmpty(nro)) {
    return false;
  }

  String pattern = r'(^(?:[+0]3)?[0-9]{9,12}$)';
  RegExp regExp = new RegExp(pattern);
  if (nro!.length == 0) {
    return false;
  } else if (!regExp.hasMatch(toTrimAndCase(nro))) {
    return false;
  }
  return true;
}

write(var msge, [var objet]) {
  dev.log(msge.toString(), name: objet == null ? "LOG" : objet.toString());
}

// Checker si un id est déjà utilisé
Future<String> getNewID(String nomCollection) async {
  bool Bon = false;
  String? id;

  final snapshot =
      await FirebaseFirestore.instance.collection(nomCollection).get();
  if (snapshot.docs.length > 0) {
    while (!Bon) {
      id = UniqueKey().toString();
      DocumentSnapshot ds = await FirebaseFirestore.instance
          .collection(nomCollection)
          .doc(id)
          .get();
      Bon = !ds.exists;
    }
  } else {
    id = UniqueKey().toString();
  }

  return id!;
}

orientationEcran() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

// Ele
