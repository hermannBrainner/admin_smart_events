import 'package:cloud_firestore/cloud_firestore.dart';

import '/mode_Compte/_models/billet.dart';
import '/outils/constantes/collections.dart';
import '/outils/fonctions/fonctions.dart';
import '/providers/ceremonie.dart';

class TableInvite {
  String id;
  String nom;
  String? idParent;

  String couleur;

  List<dynamic> idsEnfants;
  bool? estPleine;

  static CollectionReference collection =
      FirebaseFirestore.instance.collection(nomCollectionTableInvites);

  TableInvite(
      {required this.id,
      required this.nom,
      required this.idsEnfants,
      this.idParent,
      required this.couleur,
      this.estPleine = false});

  static const t_id = "id";

  Map<String, dynamic> toMap() {
    var data = Map<String, dynamic>();
    data[t_id] = id;
    data["nom"] = nom;
    data["couleur"] = couleur;
    data["idParent"] = idParent;
    data["idsEnfants"] = idsEnfants;
    data["estPleine"] = estPleine;

    return data;
  }

  TableInvite.fromJson(Map<String, dynamic> data)
      : this.id = data["id"],
        this.nom = data["nom"],
        this.idParent = data["idParent"],
        this.couleur = data["couleur"],
        this.idsEnfants = data["idsEnfants"] ?? [],
        this.estPleine = data["estPleine"];

  static TableInvite fromSnapshot(DocumentSnapshot data) {
    return TableInvite(
        id: data["id"],
        nom: data["nom"],
        idsEnfants: data["idsEnfants"] ?? [],
        idParent: data["idParent"],
        couleur: data["couleur"],
        estPleine: data["estPleine"]);
  }

  save() async {
    return await collection.doc(id).set(toMap());
  }

  static List<TableInvite> qsToList(QuerySnapshot data) {
    List<TableInvite> all = [];
    data.docs.forEach((element) {
      all.add(TableInvite.fromJson(element.data() as Map<String, dynamic>));
    });
    return all;
  }

  Stream<TableInvite> byId(String id) {
    return collection.doc(id).snapshots().map(fromSnapshot);
  }

  delete() async {
    return await collection.doc(id).delete();
  }

  static Comparator<TableInvite> comparator = (t1, t2) {
    // ignore: prefer_function_declarations_over_variables
    int compParent = (t1.idParent ?? "").compareTo(t2.idParent ?? "");
    int compEnfants = t1.idsEnfants.length.compareTo(t2.idsEnfants.length);
    int compNom = t1.nom.compareTo(t2.nom);

    if (isNullOrEmpty(compParent)) {
      if (isNullOrEmpty(compEnfants)) {
        return compNom;
      } else {
        return compEnfants;
      }
    } else {
      return compParent;
    }
  };

  List<Billet> getBillets(CeremonieProvider provider) {
    return this
        .idsEnfants
        .cast<String>()
        .map((idEnfant) =>
            provider.billetsInv.firstWhere((b) => b.id == idEnfant))
        .toList();
  }

  int totalInvites(CeremonieProvider provider) {
    return getBillets(provider)
        .fold(0, (prev, billet) => prev + billet.nbrePersonnes);
  }

  static Stream<QuerySnapshot> all() {
    return collection.snapshots();
  }

  static Future<TableInvite> getById(String id) async {
    late TableInvite tableInvite;

    await collection.where(t_id, isEqualTo: id).get().then((line) {
      if (line.docs.isNotEmpty) {
        tableInvite = TableInvite.fromJson(
            line.docs.first.data() as Map<String, dynamic>);
      }
    }).catchError((e) {
      return null;
    });

    return tableInvite;
  }
}
