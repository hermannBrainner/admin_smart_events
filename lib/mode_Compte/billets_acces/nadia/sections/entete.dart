import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '/mode_Compte/exports/components/billet_pdf/font_datas.dart';
import '/outils/extensions/string.dart';
import '/outils/pdf_tools.dart';

dessineEntete(PdfPage page, Size pageSize, Uint8List fontData,
    {required String titre}) {
  Rect cadre = Rect.fromCenter(
      center: Offset(
        page.getClientSize().width / 2,
        heigthFromPercentage(0.15, page),
      ),
      width: page.getClientSize().width,
      height: 150);

  page.graphics.drawString(titre.upperDebut(),
      getFont(60, fontData, coefRebecca, style: PdfFontStyle.bold),
      brush: PdfBrushes.black,
      bounds: cadre,
      format: PdfStringFormat(
          lineAlignment: PdfVerticalAlignment.middle,
          alignment: PdfTextAlignment.center));
}
