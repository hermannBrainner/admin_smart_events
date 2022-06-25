import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '/mode_Compte/_models/billet.dart';
import '/mode_Compte/_models/billet_acces.dart';
import '/mode_Compte/exports/components/billet_pdf/font_datas.dart';
import '/outils/pdf_tools.dart';
import '/providers/ceremonie.dart';
import 'sections/date_adresse.dart';
import 'sections/entete.dart';
import 'sections/invitations.dart';
import 'sections/qrcode.dart';

// todo [lastPage client size] Size(595.0, 841.0)

pageAccesNadia(
    {required bool isTemplate,
    required Map<FontNames, Uint8List> fontDatas,
    required PdfPage page,
    required Billet billet,
    required CeremonieProvider provider}) async {
  final Size pageSize = page.getClientSize();
  page.graphics.drawRectangle(
      bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
      pen: PdfPen(pdfColor(Colors.red), width: 3));

  Map<String, dynamic> input =
      await BilletAcces(provider: provider, fontDatas: fontDatas)
          .getNadiaValues;

  ByteData dataQr = await billet.qrCodeMaker(provider.ceremonie!);
  texteInvitation(page, fontDatas[FontNames.rebecca]!,
      texte: input[BilletAcces.TEXTE]);
  adresse_date(provider.ceremonie!, page, fontDatas[FontNames.millGoudy]!);
  cadreQrCode(dataQr, page,
      drawQr: !isTemplate,
      inNomInvites: billet.nom,
      fontData: fontDatas[FontNames.rebecca]!);
  dessineEntete(
    page,
    pageSize,
    fontDatas[FontNames.aphrodite]!,
    titre: input[BilletAcces.TITRE],
  );
}
