import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '/mode_Compte/_models/table.dart';
import '/mode_Compte/_models/zone.dart';
import '/outils/extensions/listes.dart';
import '/outils/extensions/string.dart';
import '/outils/fonctions/fonctions.dart';
import '/outils/pdf_tools.dart';
import '/providers/ceremonie.dart';
import '../models/tableInCercle.dart';

class BuildZone {
  PdfPage page;

  int nbreTables = 21;
  static const double hauteurTitre = 80;

  CeremonieProvider provider;
  Zone zone;

  BuildZone({required this.page, required this.provider, required this.zone});

  double get sin45 {
    return sin(pi / 4);
  }

  double get ySommet {
    return hauteurTitre;
  }

  double get largeurPage {
    return page.getClientSize().width;
  }

  double get hauteurLegendes {
    return page.getClientSize().height - largeurPage - ySommet;
  }

  List<CercleOfTables> get cerclesData {
    return CercleOfTables.build_Cercles(provider, zone);
  }

  double get rayonDisque {
    return largeurPage / 2;
  }

  double rCentreTable(int nroCercle) {
    return -10 + coteCadreTable * (nroCercle - 0.5);
  }

  double get coteCadreTable {
    return rayonDisque / 3;
  }

  Offset get centreDisque {
    return Offset(rayonDisque, ySommet + rayonDisque);
  }

  void drawTable({required Rect cadre, required TableInvite table}) {
    page.graphics.drawEllipse(cadre,
        brush: PdfSolidBrush(pdfColor(table.couleur.couleurFromHex())));

    page.graphics.drawString(
        forcerAvec0_devant(
            (zone.idsEnfants.cast<String>().indexOf(table.id) + 1).toString()),
        PdfStandardFont(PdfFontFamily.helvetica, rayonCercle / 4),
        brush: PdfSolidBrush(pdfColor(
            blackOrWhite_formLuminance(table.couleur.couleurFromHex()))),
        bounds: cadre,
        format: PdfStringFormat(
            lineAlignment: PdfVerticalAlignment.middle,
            alignment: PdfTextAlignment.center));
  }

  double get rayonCercle {
    return 30 * (5 - cerclesData.length).toDouble() * 0.9;
  }

  void get drawTables {
    List<double> xAbscisse = [0, 0, -1, 1, sin45, -sin45, -sin45, sin45];
    List<double> yOrdonnes = [-1, 1, 0, 0, -sin45, sin45, -sin45, sin45];

    for (CercleOfTables cercle
        in cerclesData.where((c) => c.idx != 4).toList()) {
      double r = rCentreTable(cercle.idx);

      for (int i = 0; i < cercle.tablesEnfatns.length; i++) {
        drawTable(
          table: cercle.tablesEnfatns[i],
          cadre: Rect.fromCenter(
              center: Offset(centreDisque.dx + (xAbscisse[i] * r),
                  centreDisque.dy + (r * yOrdonnes[i])),
              width: rayonCercle,
              height: rayonCercle),
        );
      }
    }
  }

  List<TableInvite> get tables {
    return provider.tablesInv
        .where((t) => zone.idsEnfants.cast<String>().contains(t.id))
        .toList();
  }

  fupdateCompteurs({required int cptColonne, required int cptLigne}) {
    cptColonne++;
    if (cptColonne > 4) {
      cptLigne++;
      cptColonne = 0;
    }
  }

  drawOneLegende(TableInvite table, rect) {
    page.graphics.drawRectangle(
        brush: PdfSolidBrush(pdfColor(table.couleur.couleurFromHex())),
        bounds: rect);
    var s = table.nom.upperDebut();
    if (s.length > 16) s = (s.substring(0, 14) + "...");

    page.graphics.drawString(s, PdfStandardFont(PdfFontFamily.helvetica, 15),
        brush: PdfBrushes.black,
        bounds: rect,
        format: PdfStringFormat(
            lineAlignment: PdfVerticalAlignment.middle,
            alignment: PdfTextAlignment.center));
  }

  void get drawLegendes {
    int nbreColonnes = 4;
    double largCell = largeurPage / nbreColonnes;
    double longCell = hauteurLegendes / 5;

    int nbreLigneBesoin = (tables.length / nbreColonnes).ceil();

    double yStart = page.getClientSize().height -
        hauteurLegendes +
        (5 - nbreLigneBesoin) * longCell;

    // Cercle 3

    int cptColonne = 0;
    int cptLigne = 0;

    if (cerclesData.firstWhereOrNullListe((c) => c.idx == 3) != null) {
      for (TableInvite table
          in cerclesData.firstWhere((c) => c.idx == 3).tablesEnfatns) {
        Rect rect = Rect.fromLTWH(cptColonne * largCell,
            yStart + cptLigne * longCell, largCell, longCell);
        cptColonne++;
        if (cptColonne > nbreColonnes - 1) {
          cptLigne++;
          cptColonne = 0;
        }
        drawOneLegende(table, rect);
      }
    }

    if (cerclesData.firstWhereOrNullListe((c) => c.idx == 2) != null) {
      for (TableInvite table
          in cerclesData.firstWhere((c) => c.idx == 2).tablesEnfatns) {
        Rect rect = Rect.fromLTWH(cptColonne * largCell,
            yStart + cptLigne * longCell, largCell, longCell);
        cptColonne++;
        if (cptColonne > nbreColonnes - 1) {
          cptLigne++;
          cptColonne = 0;
        }
        drawOneLegende(table, rect);
      }
    }

    if (cerclesData.firstWhereOrNullListe((c) => c.idx == 1) != null) {
      for (TableInvite table
          in cerclesData.firstWhere((c) => c.idx == 1).tablesEnfatns) {
        Rect rect = Rect.fromLTWH(cptColonne * largCell,
            yStart + cptLigne * longCell, largCell, longCell);
        cptColonne++;
        if (cptColonne > nbreColonnes - 1) {
          cptLigne++;
          cptColonne = 0;
        }
        drawOneLegende(table, rect);
      }
    }
  }

  Color get couleurTextTable {
    return zone.couleur.couleurFromHex().computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;
  }

  void get drawTitre {
    Rect cadre = Rect.fromCenter(
        center: Offset(
            page.getClientSize().width / 2, ySommet - (hauteurTitre / 1.5)),
        width: 300,
        height: hauteurTitre * 0.5);

    page.graphics.drawRectangle(
        brush: PdfSolidBrush(pdfColor(zone.couleur.couleurFromHex())),
        bounds: cadre);

    page.graphics.drawString(
        zone.nom.toUpperCase(), PdfStandardFont(PdfFontFamily.helvetica, 20),
        brush: PdfSolidBrush(pdfColor(couleurTextTable)),
        bounds: cadre,
        format: PdfStringFormat(
            lineAlignment: PdfVerticalAlignment.middle,
            alignment: PdfTextAlignment.center));
  }

  void draw() {
    drawTitre;
    drawTables;
    drawLegendes;
  }
}
