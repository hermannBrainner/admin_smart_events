import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '/mode_Compte/_models/billet.dart';
import '/mode_Compte/_models/ceremonie.dart';
import '/outils/constantes/numbers.dart';
import '/outils/pdf_tools.dart';
import '/providers/theme/strings.dart';

const LARGEUR_TOTALE = "LARGEUR_TOTALE";
const COTE_IMAGE = "COTE_IMAGE";
const NOMBRE_LIGNE_PAR_PAGE = "NOMBRE_LIGNE_PAR_PAGE";
const NOMBRE_TOTAL_BILLETS = "NOMBRE_TOTAL_BILLETS";

// TODO : Mettre une page de garde qui explique comment utiliser le document

buildQrCodes(List<Billet> billets, Ceremonie ceremonie,
    Function editValeursEncours, Function saveFile) async {
  int nbreColonnes = 5;

  Map<String, dynamic> dataValues = getPageValues(nbreColonnes);
  dataValues[NOMBRE_TOTAL_BILLETS] = billets.length;

  final PdfDocument document = PdfDocument();

  List<List<Billet>> gridBillets =
      buildGrid(billets, nbreColonnes, editValeursEncours);

  Map<int, List<List<Billet>>> pagesQrCodes = repartitionParPage(gridBillets,
      nbreLigneParPage: dataValues[NOMBRE_LIGNE_PAR_PAGE]);

  await draw(document, pagesQrCodes, dataValues, editValeursEncours, ceremonie);

  editValeursEncours(nom: "", prct: centDouble, isFini: true);

  final List<int> bytes = document.save();
  document.dispose();

  final Directory directory =
      await path_provider.getApplicationDocumentsDirectory();
  final String path = directory.path;
  final File file = File('$path/' + ceremonie.id + Strings.extensionPdf);
  await file.writeAsBytes(bytes);

  saveFile(file);

  //return file ;
}

List<List<Billet>> buildGrid(
    List<Billet> billets, int nbreColonnes, Function editValeursEncours) {
  int compteurBillet = 0;

  List<List<Billet>> grid = [];

  List<Billet> values = [];

  for (Billet billet in billets) {
    compteurBillet++;
    double prct = 100 * (compteurBillet / billets.length);

    values.add(billet);
    if (values.length == nbreColonnes) {
      grid.add(values);
      values = [];
    } else if (prct >= 100 && values.isNotEmpty) {
      grid.add(values);
    }
  }

  return grid;
}

Map<String, dynamic> getPageValues(int nbreColonnes) {
  final PdfDocument tempDoc = PdfDocument();

  var data = Map<String, dynamic>();
  PdfPage page = tempDoc.pages.add();
  data[LARGEUR_TOTALE] = page.getClientSize().width;
  data[COTE_IMAGE] = page.getClientSize().width / nbreColonnes;
  data[NOMBRE_LIGNE_PAR_PAGE] =
      (page.getClientSize().height / data[COTE_IMAGE]).toInt();
  tempDoc.pages.remove(page);

  return data;
}

Map<int, List<List<Billet>>> repartitionParPage(List<List<Billet>> grid,
    {required int nbreLigneParPage}) {
  var PagesQrCodePar = Map<int, List<List<Billet>>>();

  int idxPage = 1;

  List<List<Billet>> valeurs = [];

  for (List<Billet> ligne in grid) {
    valeurs.add(ligne);

    if (valeurs.length >= nbreLigneParPage) {
      PagesQrCodePar[idxPage] = valeurs;
      valeurs = [];
      idxPage++;
    }
  }

  if (valeurs.isNotEmpty) {
    PagesQrCodePar[idxPage] = valeurs;
  }

  return PagesQrCodePar;
}

//Draws the grid
draw(PdfDocument document, Map<int, List<List<Billet>>> tableau, var dataValues,
    Function editValeursEncours, Ceremonie ceremonie) async {
  int compteurBillet = 0;
  double prct;
  Billet billet;

  for (int indexPage = 1; indexPage <= tableau.length; indexPage++) {
    PdfPage page = document.pages.add();
    Size pageSize = page.getClientSize();
    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
        pen: PdfPen(pdfColor(Colors.blueAccent), width: 3));

    List<List<Billet>> lignes = tableau[indexPage]!;

    for (int iLigne = 0; iLigne < lignes.length; iLigne++) {
      List<Billet> colonnes = lignes[iLigne];

      for (int jColonne = 0; jColonne < colonnes.length; jColonne++) {
        billet = colonnes[jColonne];

        compteurBillet++;
        prct = 100 * (compteurBillet / dataValues[NOMBRE_TOTAL_BILLETS]);

        editValeursEncours(nom: billet.nom, prct: prct, isFini: false);

        ByteData dataQr = await billet.qrCodeMaker(ceremonie);
        await billet.updateExport();
        final buffer = dataQr.buffer;
        Uint8List image =
            buffer.asUint8List(dataQr.offsetInBytes, dataQr.lengthInBytes);

        Rect cadre = Rect.fromLTWH(
            (jColonne * dataValues[COTE_IMAGE]).toDouble(),
            (iLigne * dataValues[COTE_IMAGE]).toDouble(),
            dataValues[COTE_IMAGE],
            dataValues[COTE_IMAGE]);

        Rect cadreQrCode = Rect.fromCenter(
            center: Offset(
                (jColonne * dataValues[COTE_IMAGE] + dataValues[COTE_IMAGE] / 2)
                    .toDouble(),
                (iLigne * dataValues[COTE_IMAGE] + dataValues[COTE_IMAGE] / 2)
                    .toDouble()),
            width: dataValues[COTE_IMAGE] * 0.5,
            height: dataValues[COTE_IMAGE] * 0.5);

        if (compteurBillet <= 34) {
          PdfBitmap pdfBitmap = PdfBitmap(image);
          page.graphics.drawImage(pdfBitmap, cadreQrCode);
        }

        page.graphics.drawRectangle(
            bounds: cadre,
            pen: PdfPen(pdfColor(Colors.red),
                width: 1, dashStyle: PdfDashStyle.dash));

        // await  fichier.delete();
      }
    }
  }
}
