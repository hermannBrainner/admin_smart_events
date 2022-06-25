import 'package:cloud_firestore/cloud_firestore.dart';

import '/mode_Compte/_models/billet.dart';
import '/mode_Compte/_models/ceremonie.dart';
import '/outils/constantes/collections.dart';
import '/outils/constantes/numbers.dart';
import '/outils/fonctions/fonctions.dart';

class BilletCtrl {
  CollectionReference coll =
      FirebaseFirestore.instance.collection(nomCollectionBillets);

  static List<Billet> qsToList(QuerySnapshot data) {
    List<Billet> all = [];
    data.docs.forEach((element) {
      all.add(Billet.fromJson(element.data() as Map<String, dynamic>));
    });

    all.sort(Billet.compParent_Nom);
    return all;
  }

  static int nbreAlert(Ceremonie ceremonie, List<Billet> billets) {
    if (isNullOrEmpty(billets)) {
      return 0;
    }

    int nbre = billets.where((billet) => isNullOrEmpty(billet.idParent)).length;

    return ceremonie.withTables ? nbre : 0;
  }

  List<dynamic> controllerBillet(String lecture) {
    String? idProbable;

    bool isBonCode = false;
    String splitCode = "/code/";

    try {
      lecture = lecture.split(splitCode).last;

      String code = lecture.split("_")[1];

      String key = lecture.split("_")[2];

      idProbable = code + "_" + key;
      isBonCode = ((double.parse(code) - double.parse(key)) % 1) == 0;
    } on FormatException {
    } on RangeError {}

    return [isBonCode, idProbable];
  }

  /* static Stream<Billet> getById(String id) {
    return Billet.collection.doc(id).snapshots().map(Billet.fromSnapshot);
  }*/

  static Future<List<Billet>> manyById(List<String> ids) async {
    // await wait( nbreSeconde: 15);
    List<Billet> all = [];

    for (String id in ids) {
      Billet billet = await Billet.getById(id);
      all.add(billet);
    }
    all.sort(Billet.compParent_Nom);

    return all;
  }

  static String makeQrCode() {
    String qrCodeFirst = genererCodeRandom(nbreDigits: BILLET_ID_NBRE_DIGITS);

    double num_id = double.parse(qrCodeFirst);
    double qrCode_Reste = num_id % DIVISEUR_GLOBAL;

    return qrCodeFirst +
        "_" +
        forcerAvec0_devant(qrCode_Reste.toString().replaceAll(".0", ""));
  }

  static delete(String? id, {List<String>? ids}) async {
    if (isNullOrEmpty(ids)) {
      return await Billet.collection.doc(id).delete();
    } else {
      for (var id in ids!) {
        await Billet.collection.doc(id).delete();
      }
    }
  }

  static rmvHierachieByIds(List<String> ids) async {
    for (String id in ids) {
      await rmvHierachieById(id);
    }
  }

  static rmvHierachieById(String id) async {
    dynamic element = await Billet.getById(id);
    element.idParent = null;
    await element.save();
  }
}
