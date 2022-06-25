import '/mode_Compte/_controllers/billet.dart';
import '/mode_Compte/_models/billet.dart';
import '/mode_Compte/_models/ceremonie.dart';
import '/mode_Compte/_models/prefs.dart';

const INVITES = "INVITES";
const BILLETS = "BILLETS";

Future<Map<String, int?>> saveValues(
    {required String idCeremonie, required List<Billet> billets}) async {
  var data = Map<String, int?>();
  data["${idCeremonie}_INVITES"] =
      billets.fold(0, (int prev, billet) => prev + billet.nbrePersonnes) as int;
  data["${idCeremonie}_BILLETS"] = billets.length;

  await Prefs.setInts(data);

  return data;
}

Future<Map<String, int?>> getValues(Ceremonie ceremonie) async {
  var data = Map<String, int?>();

  data = await Prefs.getInts(
      [INVITES, BILLETS].map((e) => "${ceremonie.id}_${e}").toList());

  if (data.values.contains(null)) {
    List<Billet> billets =
        await BilletCtrl.manyById(ceremonie.idsBillets.cast<String>());
    data = await saveValues(idCeremonie: ceremonie.id, billets: billets);
  }

  return data;
}
