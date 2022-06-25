import 'dart:typed_data';

import 'package:syncfusion_flutter_pdf/pdf.dart';

import '/mode_Compte/exports/components/billet_pdf/font_datas.dart';
import '/providers/ceremonie.dart';
import '../../billets_acces/nadia/sections/date_adresse.dart';
import '../../billets_acces/nadia/sections/entete.dart';
import '../../billets_acces/nadia/sections/invitations.dart';
import '../main.dart';

pageGarde(
    {required PdfDocument document,
    required CeremonieProvider provider}) async {
  PdfPage page = document.pages.add();
  await provider.refreshFontsData();
  Map<FontNames, Uint8List> fontDatas = provider.fontDatas;

  drawBordurePage(page);

  texteInvitation(page, fontDatas[FontNames.rebecca]!, texte: "Plan de salle");
  adresse_date(provider.ceremonie!, page, fontDatas[FontNames.millGoudy]!);

  dessineEntete(
    page,
    page.getClientSize(),
    fontDatas[FontNames.aphrodite]!,
    titre: provider.ceremonie!.titreCeremonie,
  );
}
