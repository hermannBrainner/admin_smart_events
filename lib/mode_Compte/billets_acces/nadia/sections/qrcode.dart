import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '/mode_Compte/exports/components/billet_pdf/font_datas.dart';
import '/outils/pdf_tools.dart';

double hauteurDefaut = 762;

void cadreQrCode(ByteData dataQr, PdfPage page,
    {required bool drawQr,
    required String inNomInvites,
    required Uint8List fontData}) {
  double coeffEchelle = page.getClientSize().height / hauteurDefaut;

  double yDebut = heigthFromPercentage(0.72, page);

  double largeurTrait = widthFromPercentage(0.06, page);

  double coteQrCode = widthFromPercentage(0.15, page) * coeffEchelle;

  double marge = coteQrCode * 0.1;

  double xDebut = (page.getClientSize().width - coteQrCode) / 2 - marge;
  final PdfPen linePen =
      PdfPen(PdfColor(142, 170, 219, 255), dashStyle: PdfDashStyle.custom);

  Offset pointHG = Offset(xDebut, yDebut);
  cadreHautGauche(pointHG, page, linePen, coteQrCode, largeurTrait);

  Offset pointHD = Offset(
    xDebut + (coteQrCode + 2 * marge),
    yDebut,
  );
  cadreHautDroit(pointHD, page, linePen, coteQrCode, largeurTrait);

  Offset pointBG = Offset(
    xDebut,
    yDebut + (coteQrCode + 2 * marge),
  );
  cadreBasGauche(pointBG, page, linePen, coteQrCode, largeurTrait);

  Offset pointBD = Offset(
    xDebut + (coteQrCode + 2 * marge),
    yDebut + (coteQrCode + 2 * marge),
  );
  cadreBasDroit(pointBD, page, linePen, coteQrCode, largeurTrait);

  final buffer = dataQr.buffer;
  Uint8List image =
      buffer.asUint8List(dataQr.offsetInBytes, dataQr.lengthInBytes);

  if (drawQr) {
    page.graphics.drawImage(PdfBitmap(image),
        Rect.fromLTWH(xDebut + marge, yDebut + marge, coteQrCode, coteQrCode));
  }

  page.graphics.drawString(
      inNomInvites,
      getFont(20 * coeffEchelle, fontData, coefRebecca,
          style: PdfFontStyle.bold),
      brush: PdfBrushes.black,
      bounds: Rect.fromCenter(
          center: Offset(
              page.getClientSize().width / 2,
              yDebut +
                  (coteQrCode + 2 * marge) +
                  heigthFromPercentage(0.04, page) * coeffEchelle),
          width: coteQrCode * 4,
          height: 90),
      format: PdfStringFormat(
          lineAlignment: PdfVerticalAlignment.middle,
          alignment: PdfTextAlignment.center));
}

void cadreBasDroit(Offset point1, PdfPage page, PdfPen linePen,
    double coteQrCode, double largeurTrait) {
  Offset point2 = Offset(point1.dx - largeurTrait, point1.dy);
  Offset point3 = Offset(point1.dx, point1.dy - largeurTrait);

  page.graphics.drawLine(linePen, point1, point2);
  page.graphics.drawLine(linePen, point1, point3);
}

void cadreBasGauche(Offset point1, PdfPage page, PdfPen linePen,
    double coteQrCode, double largeurTrait) {
  Offset point2 = Offset(point1.dx + largeurTrait, point1.dy);
  Offset point3 = Offset(point1.dx, point1.dy - largeurTrait);

  page.graphics.drawLine(linePen, point1, point2);
  page.graphics.drawLine(linePen, point1, point3);
}

void cadreHautDroit(Offset point1, PdfPage page, PdfPen linePen,
    double coteQrCode, double largeurTrait) {
  Offset point2 = Offset(point1.dx - largeurTrait, point1.dy);
  Offset point3 = Offset(point1.dx, point1.dy + largeurTrait);

  page.graphics.drawLine(linePen, point1, point2);
  page.graphics.drawLine(linePen, point1, point3);
}

void cadreHautGauche(Offset point1, PdfPage page, PdfPen linePen,
    double coteQrCode, double largeurTrait) {
  Offset point2 = Offset(point1.dx + largeurTrait, point1.dy);
  Offset point3 = Offset(point1.dx, point1.dy + largeurTrait);

  page.graphics.drawLine(linePen, point1, point2);
  page.graphics.drawLine(linePen, point1, point3);
}
