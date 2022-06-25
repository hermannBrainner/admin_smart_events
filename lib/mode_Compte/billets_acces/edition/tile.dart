import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import '/mode_Compte/_models/billet_acces.dart';
import '/outils/size_configs.dart';
import '/outils/widgets/main.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/elements/main.dart';

class TemplateBilletTile<String> extends StatelessWidget {
  final CeremonieProvider provider;
  final String nomTemplate;
  final String groupValue;
  final ValueChanged<String> onChanged;

  const TemplateBilletTile({
    required this.provider,
    required this.nomTemplate,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onDoubleTap: () {
        popBillet(
            context: context,
            provider: provider,
            template: this.nomTemplate.toString());
      },
      onLongPress: () => onChanged(nomTemplate),
      child: view(context),
    );
  }

  Widget view(BuildContext context) {
    final isSelected = nomTemplate == groupValue;

    final icon = Icon(
      isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
      color: isSelected
          ? Colors.lightGreenAccent
          : ThemeElements(context: context, mode: ColorMode.endroit).themeColor,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: SizeConfig.blockSizeVertical * 30,
          width: SizeConfig.blockSizeHorizontal * 40,
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal * 1, vertical: 8),
          margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal * 1, vertical: 8),
          decoration: BoxDecoration(
            color: null,
            borderRadius:
                BorderRadius.circular(SizeConfig.blockSizeHorizontal * 2),
            border: Border.all(
              color: isSelected
                  ? Colors.lightGreenAccent
                  : ThemeElements(context: context, mode: ColorMode.endroit)
                      .themeColor,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              billetView(provider: provider, template: nomTemplate.toString())
            ],
          ),
        ),
        IconButton(
          icon: icon,
          padding: EdgeInsets.symmetric(vertical: 2),
          onPressed: () => onChanged(nomTemplate),
        )
      ],
    );
  }
}

Widget billetView(
    {required CeremonieProvider provider, required String template}) {
  return FutureBuilder<File>(
      future: BilletAcces(fontDatas: provider.fontDatas, provider: provider)
          .getTemplate(template: template),
      builder: (context, f) {
        if (!f.hasData) {
          return getLoadingWidget(context);
        } else {
          File file = f.data!;
          return Expanded(
            child: PDFView(
              filePath: file.path,
              autoSpacing: true,
              enableSwipe: false,
              pageSnap: true,
              swipeHorizontal: true,
              nightMode: false,
            ),
          );
        }
      });
}

void popBillet(
    {required BuildContext context,
    required CeremonieProvider provider,
    required String template}) {
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
                    billetView(template: template, provider: provider),

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
