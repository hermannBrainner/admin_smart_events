import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:permission_handler/permission_handler.dart';

import '/outils/file_manager.dart';
import '/providers/theme/bouton_retour.dart';
import '/providers/theme/elements/main.dart';

class DisplayReport extends StatefulWidget {
  static const String routeName = '/Display_report';

  final File fichier;

  DisplayReport({
    required this.fichier,
  });

  @override
  _DisplayReportState createState() => _DisplayReportState();
}

class _DisplayReportState extends State<DisplayReport> {
  final controller = PdfViewerController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void requestPersmission() async {
    await Permission.storage.request();
  }

  @override
  void initState() {
    requestPersmission();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BoutonRetour(press: () {
          Navigator.pop(context);
        }),
        title: Text("Billet d'accès"),
        actions: [
          IconButton(
              icon: Icon(
                Icons.share_rounded,
                color: ThemeElements(context: context, mode: ColorMode.envers)
                    .themeColor,
              ),
              onPressed: () async {
                urlFileShare(context, widget.fichier);
              })
        ],
      ),
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
