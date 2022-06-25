/*
import 'package:cloud_firestore/cloud_firestore.dart';

import '/outils/strings.dart';  import '/providers/theme/primary_box_decoration.dart';  import '/providers/theme/main.dart';
import '/outils/extensions/string.dart'; import '/outils/validation.dart';

class Compte {
  String? id;

  String? mdp;
  String? type;
  String? idCeremonie;

 static CollectionReference collection =
      FirebaseFirestore.instance.collection(nomCollectionComptes);

  Compte({this.id, this.mdp, this.type, this.idCeremonie});

  Compte.fromJson(Map<String, dynamic> item)
      : this.id = item['id'],
        this.mdp = item['mdp'],
        this.type = item['type'],
        this.idCeremonie = item['idCeremonie'];

 static Compte fromSnapshot(DocumentSnapshot item) {
    return Compte(
        id: item['id'],
        mdp: item['mdp'],
        type: item['type'],
        idCeremonie: item['idCeremonie']);
  }

  Map<String, dynamic> toMap() {
    var data = Map<String, dynamic>();
    data['id'] = toTrimAndCase(id);
    data['mdp'] = mdp;
    data['type'] = type;
    data['idCeremonie'] = idCeremonie;
    return data;
  }



  update(String ancienUserName, String newUserName, String mdp) async {
    Compte c = await getById(ancienUserName).first;
    await c.delete();
    c.id = newUserName;
    c.mdp = mdp;

    await c.save();
  }

  delete() async {
    return await collection.doc(id) .delete();
  }

  save() async {
    return await collection.doc(id).set(toMap());
  }

 static Stream<Compte> getById(String id) {
    return collection.doc(id).snapshots().map(fromSnapshot);
  }

  Future<Compte> getCompte(String id) async {
    DocumentSnapshot ds = await collection.doc(id).get();

    return Compte.fromJson(ds.data() as Map<String, dynamic>);
  }
}
*/
