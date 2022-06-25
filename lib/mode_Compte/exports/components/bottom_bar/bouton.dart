import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/outils/constantes/colors.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/elements/logo.dart';

enum TYPE { addPages, editBillet }

class BottomButton extends StatelessWidget {
  final double size;

  final TYPE type;
  final Function auClick;

  BottomButton(
      {required this.size, required TYPE this.type, required this.auClick});

  @override
  Widget build(BuildContext context) {
    switch (this.type) {
      case TYPE.addPages:
        return IconButton(
          tooltip: "Exporter tous les Qr codes",
          icon: Icon(
            Icons.upload_rounded,
            size: size,
            semanticLabel: "Billets d'accès",
            color: Colors.green,
          ),
          onPressed: () async {
            await context.read<CeremonieProvider>().refreshBilletPdf();

            this.auClick(true);
          },
          splashColor: dWhite,
        );
      case TYPE.editBillet:
        return IconButton(
          tooltip: "Exporter tous les Qr codes",
          icon: Icon(
            Icons.edit,
            size: size,
            semanticLabel: "Billets d'accès",
            color: Colors.deepOrange,
          ),
          onPressed: () async {
            CeremonieProvider provider = context.read<CeremonieProvider>();

            await Logo(
                    ACTION_NAME: Logo.EDITION_TEMPLATE,
                    context: context,
                    ceremonieProvider: provider)
                .show();
          },
          splashColor: dWhite,
        );
    }
  }
}
