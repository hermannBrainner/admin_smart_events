import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import '/mode_Compte/dispositions/main.dart';
import '/outils/file_manager.dart';
import '/outils/size_configs.dart';
import '/providers/theme/bouton_retour.dart';
import '/providers/theme/elements/boutons.dart';
import '/providers/theme/elements/main.dart';

class DisplayPdf extends StatefulWidget {
  static const String routeName = '/Display_Pdf';

  final File fichier;

  DisplayPdf({
    required this.fichier,
  });

  @override
  _DisplayPdfState createState() => _DisplayPdfState();
}

class _DisplayPdfState extends State<DisplayPdf> {
  String? pagination;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double diametreInxPage = 50;

    return Scaffold(
      appBar: AppBar(
          actions: [
            IconButton(
                icon: Icon(Icons.share_rounded,
                    color:
                        ThemeElements(context: context, mode: ColorMode.envers)
                            .themeColor),
                onPressed: () async {
                  await urlFileShare(context, widget.fichier);
                })
          ],
          title: Text("Plan de table"),
          leading: BoutonRetour(press: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => Dispositions()));
          })),
      body: Stack(
        children: [
          PDFView(
            filePath: widget.fichier.path,
            onPageChanged: (nro, total) {
              setState(() {
                pagination = "${(nro ?? 0) + 1}/$total";
              });
            },
            autoSpacing: true,
            enableSwipe: true,
            pageSnap: true,
            swipeHorizontal: true,
            nightMode: false,
          ),
          Positioned(
              bottom: 60,
              left:
                  (SizeConfig.blockSizeHorizontal * 100 - diametreInxPage) / 2,
              child:
                  BoutonsOfTheme(context: context, textPagination: pagination)
                      .pagination)
        ],
      ),
    );
  }
}
