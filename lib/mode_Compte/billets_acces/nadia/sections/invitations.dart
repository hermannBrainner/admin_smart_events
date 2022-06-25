import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '/mode_Compte/exports/components/billet_pdf/font_datas.dart';
import '/outils/pdf_tools.dart';

texteInvitation(PdfPage page, Uint8List fontData, {required texte}) {
  Rect cadre = Rect.fromCenter(
      center: Offset(
        page.getClientSize().width / 2,
        heigthFromPercentage(0.36, page),
      ),
      width: page.getClientSize().width * 0.67,
      height: 90);

  page.graphics.drawString(texte, getFont(30, fontData, coefRebecca),
      brush: PdfBrushes.black,
      bounds: cadre,
      format: PdfStringFormat(
          lineAlignment: PdfVerticalAlignment.middle,
          alignment: PdfTextAlignment.center));
}
