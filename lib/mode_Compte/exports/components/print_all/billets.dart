import 'dart:io';

import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '/mode_Compte/_models/billet.dart';
import '/outils/constantes/numbers.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/strings.dart';
import '../../../billets_acces/nadia/main.dart';

buildAll(List<Billet> billets, CeremonieProvider provider,
    Function editValeursEncours, Function saveFile) async {
  int compteurBillet = 0;
  double prct;

  final PdfDocument document = PdfDocument();

  for (Billet billet in billets) {
    compteurBillet++;
    prct = 100 * (compteurBillet / billets.length);

    final PdfPage page = document.pages.add();
    editValeursEncours(nom: billet.nom, prct: prct, isFini: false);

    await pageAccesNadia(
        fontDatas: provider.fontDatas,
        page: page,
        billet: billet,
        provider: provider,
        isTemplate: false);
    await billet.updateExport();
  }

  editValeursEncours(nom: "", prct: centDouble, isFini: true);

  final List<int> bytes = document.save();
  document.dispose();

  final Directory directory =
      await path_provider.getApplicationDocumentsDirectory();
  final String path = directory.path;
  final File file =
      File('$path/' + provider.ceremonie!.id + Strings.extensionPdf);
  await file.writeAsBytes(bytes);

  saveFile(file);

  //return file ;
}
