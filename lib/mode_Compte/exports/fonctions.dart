import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/outils/fonctions/fonctions.dart';
import '/outils/widgets/main.dart';
import '/providers/theme/strings.dart';

Future<File?> loadBillet(BuildContext context) async {
  String errTitre = "Chargement Billet";
  bool isError = false;

  try {
    File? fichier = await getFile_storage();

    if (Strings.extensionPdf.contains(fichier!.path.split(".").last)) {
      return fichier;
    } else {
      isError = true;
    }
  } on PlatformException catch (e) {
    isError = true;
  } catch (ex) {
    isError = true;
  }

  if (isError) {
    showFlushbar(context, false, errTitre,
        "Il ne s'agit pas d'un fichier de type attendu");
  } else {
    return null;
  }
}
