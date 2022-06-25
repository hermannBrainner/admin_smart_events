import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '/providers/theme/strings.dart';
import 'constantes/strings.dart';
import 'fonctions/fonctions.dart';
import 'get_permissions.dart';

Future<File?> getFile_web({required String pathWeb, required pathLocal}) async {
  File file;

  String? url = await getFileUrl(chemin: pathWeb);

  if (!isNullOrEmpty(url)) {
    var response = await get(Uri.parse(url!));
    file = await localFile(pathLocal);
    file.writeAsBytesSync(response.bodyBytes);
    return file;
  }
  return null;
}

Future<String> localPath() async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> localFile(String chemin) async {
  final path = await localPath();
  return File('$path/$chemin');
}

Future<File> savePdf({required List<int> bytes, required String chemin}) async {
  final file = await localFile(chemin);
  await file.writeAsBytes(bytes);

  return file;
}

saveLocalFile(File inputFile, String chemin) async {
  final file = await localFile(chemin);

  if (chemin.endsWith(Strings.extensionPdf)) {
    PdfDocument document = PdfDocument(inputBytes: inputFile.readAsBytesSync());
    List<int> bytes = document.save();
    await file.writeAsBytes(bytes);
  }
}

Future<Null> urlFileShare(BuildContext context, File file) async {
  String sujet = "Partage fichier";
  const String objet = "Bonjour" +
      newLine +
      'Trouvez votre document, en pièce jointe' +
      newLine +
      newLine +
      "Cordialement" +
      newLine;

  final RenderBox box = context.findRenderObject() as RenderBox;

  PermissionStatus status = await getStoragePermission();
  if (status.isGranted) {
    Share.shareFiles([file.path],
        subject: sujet,
        text: objet,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
