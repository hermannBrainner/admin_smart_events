import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '/providers/theme/strings.dart';

double coefRebecca = 1.438;
double coefFontGoudy = 1.438;

enum FontNames { millGoudy, rebecca, aphrodite }

Future<Uint8List> millGoudyFontData() async {
  final fontData =
      (await rootBundle.load(Strings.pathAssetGoudy)).buffer.asUint8List();
  return fontData;
}

Future<Uint8List> rebeccaFontData() async {
  final fontData =
      (await rootBundle.load(Strings.pathAssetRebecca)).buffer.asUint8List();
  return fontData;
}

Future<Uint8List> aphroditeFontData() async {
  final fontData =
      (await rootBundle.load(Strings.pathAssetAphrodite)).buffer.asUint8List();
  return fontData;
}

PdfFont getFont(double police, Uint8List fontData, double coeff,
    {PdfFontStyle style = PdfFontStyle.regular}) {
  return PdfTrueTypeFont(fontData, police / coeff, style: style);
}
