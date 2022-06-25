import 'dart:io';
import 'dart:typed_data';

import 'package:syncfusion_flutter_pdf/pdf.dart';

import '/mode_Compte/_models/billet.dart';
import '/mode_Compte/_models/ceremonie.dart';
import '/mode_Compte/exports/components/billet_pdf/font_datas.dart';
import '/outils/file_manager.dart';
import '/providers/theme/strings.dart';
import '../nadia/sections/qrcode.dart';

Future<File> addQrCodeOnBillet(File inFile, Ceremonie ceremonie,
    {required Billet? billet,
    required bool isTemplate,
    required Map<FontNames, Uint8List> fontDatas}) async {
  billet = billet ?? Billet.mock();

  final PdfDocument document =
      PdfDocument(inputBytes: inFile.readAsBytesSync());
  int nroLastPage = document.pages.count - 1;

  final PdfPage page = document.pages[nroLastPage];

  ByteData dataQr = await billet.qrCodeMaker(ceremonie);
  cadreQrCode(dataQr, page,
      drawQr: !isTemplate,
      inNomInvites: billet.nom,
      fontData: fontDatas[FontNames.rebecca]!);
  final List<int> bytes = document.save();
  document.dispose();

  if (isTemplate) {
    return await inFile.writeAsBytes(bytes);
  } else {
    final String path = await localPath();
    final File file = File(
        '$path/' + ceremonie.id + "_" + billet.qrCode! + Strings.extensionPdf);
    return await file.writeAsBytes(bytes);
  }
}
