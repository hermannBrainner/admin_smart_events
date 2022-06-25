import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import '/mode_Compte/_models/billet.dart';
import '/mode_Compte/exports/main.dart';
import '/outils/file_manager.dart';
import '/providers/theme/bouton_retour.dart';
import '/providers/theme/elements/main.dart';

class DisplayBillet extends StatefulWidget {
  static const String routeName = '/Display_billet';

  final File fichier;
  final Billet billet;

  DisplayBillet({
    required this.fichier,
    required this.billet,
  });

  @override
  _DisplayBilletState createState() => _DisplayBilletState();
}

class _DisplayBilletState extends State<DisplayBillet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  widget.billet.updateExport();
                })
          ],
          title: Text("Billet d'accès"),
          leading: BoutonRetour(press: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => ExportsMainView()));
          })),
      body: PDFView(
        filePath: widget.fichier.path,
        autoSpacing: true,
        enableSwipe: true,
        pageSnap: true,
        swipeHorizontal: true,
        nightMode: false,
      ),
    );
  }
}
