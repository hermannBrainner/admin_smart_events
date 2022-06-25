import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '/outils/fonctions/fonctions.dart';
import '/outils/pdf_tools.dart';
import '../models/tableInPage.dart';

class BuildTable {
  double yStart;
  TableInPage tableInPage;
  PdfPage page;

  static const double margeX = 50;
  static const double margePlaceY = 10;
  static const double margePlaceX = 3;

  static const double hauteurTitre = 80;

  BuildTable(
      {required this.page, required this.tableInPage, required this.yStart});

  ///Constantes
  double get r {
    return tableInPage.largeurTable / 2;
  }

  double get rayonPlace {
    return tableInPage.rayonPlace;
  }

  double get sin45 {
    return sin(pi / 4);
  }

  double get petitCote {
    return (r) * sin45;
  }

  double get ySommet {
    return yStart + hauteurTitre;
  }

  double get yMilieuTable {
    return ySommet + r;
  }

  double get longueur {
    return tableInPage.longueur;
  }

  double get xMilieuTable {
    return margeX + r;
  }

  Color get couleur {
    return tableInPage.couleur;
  }

  Color get couleurChaise {
    return tableInPage.couleurChaise;
  }

  Color get couleurNroChaise {
    return tableInPage.couleurNroChaise;
  }

  /// Fonctions

  void drawBoutTable(Offset center) {
    page.graphics.drawEllipse(Rect.fromCircle(center: center, radius: r),
        brush: PdfSolidBrush(pdfColor(couleur)));
  }

  get drawTableRectangle {
    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(margeX, ySommet + r, (2 * r), longueur),
        brush: PdfSolidBrush(pdfColor(couleur)));
  }

  get dessineTable {
    drawBoutTable(Offset((margeX + r), ySommet + r));
    drawTableRectangle;
    drawBoutTable(Offset((margeX + r), ySommet + r + longueur));
  }

  Offset placeEnHaut(int index) {
    double yLateral = ySommet + (r) - petitCote;
    double xLateralGauche = margeX + (r) - petitCote;
    double xLateralDroit = xLateralGauche + 2 * petitCote;

    Offset centre;
    if (index == 0) {
      centre = Offset(xMilieuTable, ySommet);
    } else if (index == 1) {
      centre = Offset(xLateralGauche, yLateral);
    } else {
      centre = Offset(xLateralDroit, yLateral);
    }

    return centre;
  }

  Rect placeEnBas(int index) {
    double plafondLateraux =
        ySommet + longueur + (2 * r) - (r) * (1 - sin45) - rayonPlace / 2;

    if (index - 3 == 0) {
      return Rect.fromLTWH(
          margeX + r - rayonPlace / 2,
          longueur + (2 * r) + ySommet - rayonPlace / 2,
          rayonPlace,
          rayonPlace);
    } else if (index - 3 == 1) {
      return Rect.fromLTWH(margeX + (r) * (1 - sin45) - rayonPlace / 2,
          plafondLateraux, rayonPlace, rayonPlace);
    } else {
      return Rect.fromLTWH(
          margeX + (2 * r) - ((r) * (1 - sin45) + rayonPlace / 2),
          plafondLateraux,
          rayonPlace,
          rayonPlace);
    }
  }

  Rect placeEnBasTableRonde(int index) {
    double yLateral = ySommet + (r) + petitCote;
    double xLateralGauche = margeX + (r) - petitCote;
    double xLateralDroit = xLateralGauche + 2 * petitCote;

    Offset centre;
    if (index - 3 == 0) {
      centre = Offset(xMilieuTable, ySommet + (2 * r));
    } else if (index - 3 == 1) {
      centre = Offset(xLateralGauche, yLateral);
    } else {
      centre = Offset(xLateralDroit, yLateral);
    }

    return Rect.fromCenter(
      center: centre,
      height: rayonPlace,
      width: rayonPlace,
    );
  }

  Offset placeLaterale(int index, int idxLateraux) {
    double Xo = margeX + (index % 2) * (2 * r);
    double Yo = ySommet + r + tableInPage.minL * idxLateraux;
    return Offset(Xo, Yo);
  }

  List<Rect> cadreInvite(int idx) {
    double h = tableInPage.minL / 2.5;
    double xStart = (2 * margeX) + (2 * r);
    double yTop = ySommet + (h * idx);
    return [
      Rect.fromLTWH(xStart, yTop, 25, h),
      Rect.fromLTWH(xStart + 25, yTop, 200, h)
    ];
  }

  get drawLegende {
    for (int i = 0; i < tableInPage.invites.length; i++) {
      page.graphics.drawRectangle(
          pen: PdfPen(pdfColor(couleur)), bounds: cadreInvite(i)[0]);

      page.graphics.drawString(
          forcerAvec0_devant((tableInPage.invites[i].index + 1).toString()),
          PdfStandardFont(PdfFontFamily.helvetica, 10),
          brush: PdfBrushes.black,
          bounds: cadreInvite(i)[0],
          format: PdfStringFormat(
              lineAlignment: PdfVerticalAlignment.middle,
              alignment: PdfTextAlignment.center));

      page.graphics.drawRectangle(
          pen: PdfPen(pdfColor(couleur)), bounds: cadreInvite(i)[1]);
      page.graphics.drawString("  " + tableInPage.invites[i].nom,
          PdfStandardFont(PdfFontFamily.helvetica, 10),
          brush: PdfBrushes.black,
          bounds: cadreInvite(i)[1],
          format: PdfStringFormat(
              lineAlignment: PdfVerticalAlignment.middle,
              alignment: PdfTextAlignment.left));
    }
  }

  get dessineLegende {
    final PdfGrid grid = PdfGrid();
    grid.columns.add(count: 2);

    for (int idx = 0; idx < (tableInPage.invites.length); idx++) {
      final PdfGridRow row = grid.rows.add();
      row.cells[0].value = "  " +
          forcerAvec0_devant((tableInPage.invites[idx].index + 1).toString());
      row.cells[1].value = "  " + tableInPage.invites[idx].nom;
    }
    grid.columns[0].width = 25;
    grid.columns[1].width = 160;

    grid.draw(
        page: page,
        bounds: Rect.fromLTWH(
            (2 * margeX) + (2 * r),
            ySommet,
            (2 * r) * 2,
            [
              tableInPage.minL * tableInPage.invites.length,
              tableInPage.hauteurTotale
            ].reduce(max)));
  }

  void drawPlace(Rect cadre, int idx) {
    page.graphics
        .drawEllipse(cadre, brush: PdfSolidBrush(pdfColor(couleurChaise)));

    page.graphics.drawString(forcerAvec0_devant((idx + 1).toString()),
        PdfStandardFont(PdfFontFamily.helvetica, 10),
        brush: PdfSolidBrush(pdfColor(couleurNroChaise)),
        bounds: cadre,
        format: PdfStringFormat(
            lineAlignment: PdfVerticalAlignment.middle,
            alignment: PdfTextAlignment.center));
  }

  get drawPlacesTableRonde {
    List<double> xAbscisse = [0, 0, -1, 1, sin45, -sin45, -sin45, sin45];
    List<double> yOrdonnes = [-1, 1, 0, 0, -sin45, sin45, -sin45, sin45];

    for (int idx = 0; idx < tableInPage.invites.length; idx++) {
      drawPlace(
          Rect.fromCenter(
              center: Offset(xMilieuTable + (xAbscisse[idx] * r),
                  yMilieuTable + (r * yOrdonnes[idx])),
              width: rayonPlace,
              height: rayonPlace),
          idx);
    }
  }

  get dessinePlaces {
    int cptLateraux = 0;
    Offset centre;
    for (int idx = 0; idx < tableInPage.invites.length; idx++) {
      if (idx < 3) {
        centre = placeEnHaut(idx);
      } else if (idx < 6) {
        centre = placeEnBas(idx).center;
      } else {
        centre = placeLaterale(idx, cptLateraux);
        if (idx % 2 != 0) {
          cptLateraux++;
        }
      }

      drawPlace(
          Rect.fromCenter(
              center: centre, width: rayonPlace, height: rayonPlace),
          idx);
    }
  }

  void get drawTitre {
    Rect cadre = Rect.fromCenter(
        center: Offset(
            page.getClientSize().width / 2, ySommet - (hauteurTitre / 1.5)),
        width: 300,
        height: hauteurTitre * 0.5);

    page.graphics
        .drawRectangle(pen: PdfPen(pdfColor(couleurChaise)), bounds: cadre);

    page.graphics.drawString(tableInPage.table!.nom.toUpperCase(),
        PdfStandardFont(PdfFontFamily.helvetica, 20),
        brush: PdfBrushes.black,
        bounds: cadre,
        format: PdfStringFormat(
            lineAlignment: PdfVerticalAlignment.middle,
            alignment: PdfTextAlignment.center));
  }

  draw() {
    drawTitre;

    dessineTable;

    if (tableInPage.invites.length < 9) {
      drawPlacesTableRonde;
    } else {
      dessinePlaces;
    }

    drawLegende; //  dessineLegende;
  }
}
