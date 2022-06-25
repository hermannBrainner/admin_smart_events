import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;

import '/outils/fonctions/fonctions.dart';
import '/outils/widgets/main.dart';
import '/providers/theme/strings.dart';

isDataValid(List<List<dynamic>> data) {
  // TODO : Completer en verifiant les celulles et les colonnes

  if (data.length < 2) {
    return false;
  } else {
    return (data[0].length >= 2);
  }
}

Future<List<List<dynamic>>> readFile(filepath) async {
  List<List<dynamic>> data = [];
  try {
    File f = new File(filepath);

    if (p.extension(f.path).contains(Strings.extensionXls)) {
      var bytes = f.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      data = excel.sheets.values.first.rows
          .map((row) => row.map((cel) => cel!.value).toList())
          .toList();
    } else {
      final input = f.openRead();
      data = await input
          .transform(utf8.decoder)
          .transform(new CsvToListConverter())
          .toList();
    }

    data = isDataValid(data) ? data : [];
  } on RangeError catch (e) {
    data = [];
  }
  return data;
}

Future<List<List<dynamic>>> loadFile(
    String extension, BuildContext context) async {
  List<PlatformFile> paths;
  String errTitre = "Chargement liste invités";
  String? errMsge;

  FileType _pickingType = FileType.any;

  List<List<dynamic>> data = [];

  try {
    paths = (await FilePicker.platform.pickFiles(
      type: _pickingType,
      allowMultiple: false,
    ))!
        .files;

    if (paths.first.extension == extension) {
      switch (extension) {
        case Strings.extensionCsv:
          data = await readFile(paths[0].path);
          break;

        case Strings.extensionXls:
          data = await readFile(paths[0].path);
          break;
      }
    } else {
      errMsge = "Il ne s'agit pas d'un fichier de type demandé";
    }
  } on PlatformException catch (e) {
    errMsge = e.message.toString();
  } catch (ex) {
    errMsge = ex.toString();
  }

  if (!isNullOrEmpty(errMsge)) {
    showFlushbar(context, false, errTitre, errMsge!);
  }

  return data;
}
