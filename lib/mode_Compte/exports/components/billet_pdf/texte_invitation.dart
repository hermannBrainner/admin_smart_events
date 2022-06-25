import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '/outils/pdf_tools.dart';
import 'font_datas.dart';

texteInvitation(PdfPage page, Uint8List fontData) {
  String texte =
      "Seraient heureux de vous compter parmi leurs invités à la soirée dansante";

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
