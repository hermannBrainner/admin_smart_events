import 'package:cloud_firestore/cloud_firestore.dart';

import '/mode_Compte/_models/table.dart';
import '/outils/constantes/collections.dart';
import '/outils/fonctions/fonctions.dart';
import '/providers/ceremonie.dart';

class Zone {
  String id;
  String nom;
  String? idParent;

  String couleur;

  List<dynamic> idsEnfants;
  bool estPleine;

  static CollectionReference collection =
      FirebaseFirestore.instance.collection(nomCollectionZones);

  delete() async {
    return await collection.doc(id).delete();
  }

  save() async {
    return await collection.doc(id).set(toMap());
  }

  static Comparator comparator = (t1, t2) {
    // ignore: prefer_function_declarations_over_variables

    int compEnfants =
        (t1.idsEnfants ?? []).length.compareTo((t2.idsEnfants ?? []).length);
    int compNom = t1.nom.compareTo(t2.nom);

    if (isNullOrEmpty(compEnfants)) {
      return compNom;
    } else {
      return compEnfants;
    }
  };

  List<TableInvite> getTables(CeremonieProvider provider) {
    return this
        .idsEnfants
        .cast<String>()
        .map((idEnfant) =>
            provider.tablesInv.firstWhere((t) => t.id == idEnfant))
        .toList();
  }

  int totalInvites(CeremonieProvider provider) {
    return this
        .getTables(provider)
        .fold(0, (int prev, table) => prev + table.totalInvites(provider));
  }

  Zone(
      {required this.id,
      required this.nom,
      required this.idsEnfants,
      this.idParent,
      required this.couleur,
      this.estPleine = false});

  Map<String, dynamic> toMap() {
    var data = Map<String, dynamic>();
    data[z_id] = id;
    data["nom"] = nom;
    data["couleur"] = couleur;
    data["idParent"] = idParent;
    data["idsEnfants"] = idsEnfants;
    data["estPleine"] = estPleine;

    return data;
  }

  static Zone fromSnapshot(DocumentSnapshot data) {
    return Zone(
        id: data[z_id],
        nom: data["nom"],
        idsEnfants: data["idsEnfants"] ?? [],
        idParent: data["idParent"],
        couleur: data["couleur"],
        estPleine: data["estPleine"]);
  }

  static const z_id = "id";

  Zone.fromJson(Map<String, dynamic> data)
      : this.id = data[z_id],
        this.nom = data["nom"],
        this.idParent = data["idParent"],
        this.couleur = data["couleur"],
        this.idsEnfants = data["idsEnfants"] ?? [],
        this.estPleine = data["estPleine"];

  static Stream<QuerySnapshot> all() {
    return collection.snapshots();
  }

  static Future<Zone> getById(String id) async {
    late Zone zone;
    await collection.where(z_id, isEqualTo: id).get().then((line) {
      if (line.docs.isNotEmpty) {
        zone = Zone.fromJson(line.docs.first.data() as Map<String, dynamic>);
      }
    }).catchError((e) {
      return null;
    });

    return zone;
  }

  static List<Zone> qsToList(QuerySnapshot data) {
    List<Zone> all = [];
    data.docs.forEach((element) {
      all.add(Zone.fromJson(element.data() as Map<String, dynamic>));
    });
    return all;
  }
}
