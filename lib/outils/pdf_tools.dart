import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

pdfColor(Color c) {
  return PdfColor(c.red, c.green, c.blue, c.alpha);
}

widthFromPercentage(double pourcentage, PdfPage page) {
  return pourcentage * page.getClientSize().width;
}

heigthFromPercentage(double pourcentage, PdfPage page) {
  return pourcentage * page.getClientSize().height;
}

pointageCadre(PdfPage page, Rect cadre) {
  pointageMarkeur(page, cadre.centerLeft.dx, cadre.centerLeft.dy);
  pointageMarkeur(page, cadre.centerRight.dx, cadre.centerRight.dy);
  pointageMarkeur(page, cadre.topCenter.dx, cadre.topCenter.dy);
  pointageMarkeur(page, cadre.bottomCenter.dx, cadre.bottomCenter.dy);
}

pointageMarkeur(PdfPage page, double x, double y) {
  final PdfPen linePen = PdfPen(PdfColor(142, 170, 219, 255),
      dashStyle: PdfDashStyle.custom, width: 4);
  page.graphics.drawLine(linePen, Offset(x, y), Offset(x + 3, y));
}
