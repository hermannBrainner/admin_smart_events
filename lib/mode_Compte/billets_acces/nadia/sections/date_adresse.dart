import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '/mode_Compte/_models/ceremonie.dart';
import '/mode_Compte/exports/components/billet_pdf/font_datas.dart';
import '/outils/extensions/time.dart';
import '/outils/pdf_tools.dart';
import '/providers/theme/strings.dart';

blocHeure(Rect cadre, PdfPage page, police, {String heure = "20h00"}) {
  page.graphics.drawString(
      heure, PdfStandardFont(PdfFontFamily.helvetica, police),
      brush: PdfBrushes.black,
      bounds: cadre,
      format: PdfStringFormat(
          lineAlignment: PdfVerticalAlignment.middle,
          alignment: PdfTextAlignment.center));
}

blocAnnee(Rect cadre, PdfPage page, PdfFont font, {String annee = "2022"}) {
  page.graphics.drawString(annee, font,
      brush: PdfBrushes.black,
      bounds: cadre,
      format: PdfStringFormat(
          lineAlignment: PdfVerticalAlignment.bottom,
          alignment: PdfTextAlignment.left));
}

blocMois(Rect cadre, PdfPage page, PdfFont font, {String mois = "FEVRIER"}) {
  page.graphics.drawString(
      mois, font, // PdfStandardFont(PdfFontFamily.helvetica, police),
      brush: PdfBrushes.black,
      bounds: cadre,
      format: PdfStringFormat(
          lineAlignment: PdfVerticalAlignment.bottom,
          alignment: PdfTextAlignment.left));
}

blocJour(Rect cadre, PdfPage page, PdfFont font, {String jour = "20"}) {
  page.graphics.drawString(jour, font,
      brush: PdfBrushes.black,
      bounds: cadre,
      format: PdfStringFormat(
          lineAlignment: PdfVerticalAlignment.top,
          alignment: PdfTextAlignment.right));
}

blocSemaine(Rect cadre, PdfPage page, police, Uint8List fontData,
    {String semaine = "SAMEDI"}) {
  final PdfFont font = getFont(police, fontData, coefFontGoudy);
  page.graphics.drawString(
      semaine, font, //  PdfStandardFont(PdfFontFamily.helvetica, police),
      brush: PdfBrushes.black,
      bounds: cadre,
      format: PdfStringFormat(
          lineAlignment: PdfVerticalAlignment.top,
          alignment: PdfTextAlignment.right));
}

blocDate(Ceremonie ceremonie, PdfPage page, Uint8List pacificoFontData,
    {required String heure,
    String annee = "2022",
    String mois = "FÉVRIER",
    String semaine = "SAMEDI",
    String jour = "19"}) {
  double yDebutBottom = heigthFromPercentage(0.52, page);

  double largeurTrait = 3;

  final PdfPen linePen = PdfPen(pdfColor(Colors.black),
      dashStyle: PdfDashStyle.custom, width: largeurTrait);

  double policeHeure = 30;
  double policeAnne = 60;
  double policeMois = 26;
  double policeJour = 60;
  double policeSemaine = 20;
  double largeurHeure = 100;

  double marge = 3;

  Rect cadreHeure = Rect.fromCenter(
      center: Offset(
        page.getClientSize().width / 2,
        yDebutBottom,
      ),
      width: largeurHeure,
      height: 1.17 * policeHeure);

  Rect cadreAnnee = Rect.fromLTWH(
      cadreHeure.center.dx + marge,
      cadreHeure.top - 40 - marge,
      getFont(policeAnne, pacificoFontData, coefFontGoudy)
          .measureString(annee)
          .width,
      getFont(policeAnne, pacificoFontData, coefFontGoudy)
              .measureString(annee)
              .height +
          marge);
  Rect cadreMois = Rect.fromLTWH(
      cadreHeure.center.dx + marge,
      cadreAnnee.top - marge,
      getFont(policeMois, pacificoFontData, coefFontGoudy)
          .measureString(mois)
          .width,
      getFont(policeMois, pacificoFontData, coefFontGoudy)
              .measureString(mois)
              .height +
          marge);

  Rect cadreSemaine = Rect.fromLTWH(
      cadreHeure.center.dx -
          getFont(policeSemaine, pacificoFontData, coefFontGoudy)
              .measureString(semaine)
              .width -
          marge,
      cadreHeure.top - 10 - marge,
      getFont(policeSemaine, pacificoFontData, coefFontGoudy)
          .measureString(semaine)
          .width,
      getFont(policeSemaine, pacificoFontData, coefFontGoudy)
              .measureString(semaine)
              .height +
          marge);
  Rect cadreJour = Rect.fromLTWH(
      cadreHeure.center.dx -
          getFont(policeJour, pacificoFontData, coefFontGoudy)
              .measureString(jour)
              .width -
          marge,
      cadreSemaine.top - marge - 45,
      getFont(policeJour, pacificoFontData, coefFontGoudy)
          .measureString(jour)
          .width,
      getFont(policeJour, pacificoFontData, coefFontGoudy)
              .measureString(jour)
              .height +
          marge);

  blocHeure(cadreHeure, page, policeHeure, heure: heure);
  blocAnnee(
      cadreAnnee, page, getFont(policeAnne, pacificoFontData, coefFontGoudy));
  blocMois(
      cadreMois, page, getFont(policeMois, pacificoFontData, coefFontGoudy),
      mois: mois);
  blocJour(
      cadreJour, page, getFont(policeJour, pacificoFontData, coefFontGoudy),
      jour: jour);
  blocSemaine(cadreSemaine, page, policeSemaine, pacificoFontData,
      semaine: semaine);

  // TRAIT Gauche

  page.graphics.drawLine(linePen, cadreHeure.centerRight,
      Offset(cadreAnnee.centerRight.dx, cadreHeure.centerRight.dy));

  // TRAIT Droit
  page.graphics.drawLine(
      linePen,
      cadreHeure.centerLeft,
      Offset(
          cadreHeure.centerLeft.dx -
              (cadreAnnee.centerRight.dx - cadreHeure.centerRight.dx),
          cadreHeure.centerRight.dy));

  // Trait Vertical
  page.graphics.drawLine(linePen, cadreHeure.topCenter,
      Offset(cadreHeure.topCenter.dx, cadreMois.top));
}

void adresse_date(
    Ceremonie ceremonie, PdfPage page, Uint8List pacificoFontData) {
  Intl.defaultLocale = Strings.localFr;

  blocDate(
    ceremonie,
    page,
    pacificoFontData,
    semaine: DateFormat('EEEE')
        .format(ceremonie.dateCeremonie.toDate())
        .toUpperCase(),
    heure: ceremonie.dateCeremonie.hourString(separator: "h"),
    jour:
        DateFormat('dd').format(ceremonie.dateCeremonie.toDate()).toUpperCase(),
    annee: DateFormat('yyyy')
        .format(ceremonie.dateCeremonie.toDate())
        .toUpperCase(),
    mois: DateFormat('MMMM')
        .format(ceremonie.dateCeremonie.toDate())
        .toUpperCase(),
  );

  String adresse = ceremonie.lieuCeremonie;

  page.graphics.drawString(
      adresse, PdfStandardFont(PdfFontFamily.helvetica, 20),
      brush: PdfBrushes.black,
      bounds: Rect.fromCenter(
          center: Offset(
            page.getClientSize().width / 2,
            heigthFromPercentage(0.65, page),
          ),
          width: page.getClientSize().width,
          height: 90),
      format: PdfStringFormat(
          lineAlignment: PdfVerticalAlignment.middle,
          alignment: PdfTextAlignment.center));
}
