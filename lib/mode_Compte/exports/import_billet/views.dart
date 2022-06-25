import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '/mode_Compte/_models/ceremonie.dart';
import '/outils/size_configs.dart';
import '/providers/ceremonie.dart';

Widget billetView({required bool onlyLastPage, required String mode}) {
  return Consumer<CeremonieProvider>(builder: (context, provider, child) {
    late PdfDocument document;

    late File fichier;

    if (mode == Ceremonie.modeLast) {
      fichier = provider.fichierBillet!;
    } else {
      fichier = provider.fichierBilletTemplate!;
    }

    document = PdfDocument(inputBytes: fichier.readAsBytesSync());

    return Expanded(
      child: PDFView(
        filePath: fichier.path,
        autoSpacing: true,
        enableSwipe: !onlyLastPage,
        defaultPage: onlyLastPage ? document.pages.count - 1 : 0,
        pageSnap: true,
        swipeHorizontal: true,
        nightMode: false,
      ),
    );
  });
}

void popBillet(
    {required BuildContext context,
    required bool onlyLastPage,
    required String modePage}) {
  showDialog(
    context: context,
    builder: (pctx) {
      return StatefulBuilder(
        builder: (ppctx, setState) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            content: SingleChildScrollView(
              child: Container(
                // color: Colors.red,
                height: SizeConfig.blockSizeVertical * 60,
                width: SizeConfig.blockSizeHorizontal * 100,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    billetView(onlyLastPage: onlyLastPage, mode: modePage),

                    //  Center( child: ,)
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
