import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '/mode_Compte/exports/pages/liste.dart';
import '/outils/constantes/colors.dart';
import '/outils/size_configs.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/strings.dart';

Color couleurIcon = Color.fromRGBO(18, 11, 52, .8);

modalBtnImpt(BuildContext context, Function selectTypePrint) {
  return showCupertinoModalBottomSheet(
      context: context,
      backgroundColor: dWhite,
      builder: (BuildContext bc) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Material(
                    child: Container(
                  color: dWhiteLeger,
                  padding:
                      EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 6),
                  child: Consumer<CeremonieProvider>(
                    builder: (context, provider, child) {
                      return Wrap(
                        children: <Widget>[
                          tileQrCodesExp(context, selectTypePrint),
                          tileBilletsExp(context, selectTypePrint),
                        ],
                      );
                    },
                  ),
                )));
          },
        );
      });
}

icone(IconData iconData) {
  return Container(
    width: SizeConfig.safeBlockHorizontal * 10,
    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
    decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: couleurJauneMoutardeClair, width: 2.0)),
    child: Icon(
      iconData,
      color: couleurIcon,
    ),
  );
}

tileQrCodesExp(BuildContext context, Function selectTypePrint) {
  return ListTile(
    leading: icone(Icons.qr_code),
    title: ElevatedButton(
        style: ElevatedButton.styleFrom(
            fixedSize: Size(SizeConfig.blockSizeHorizontal * 80,
                SizeConfig.safeBlockVertical * 7),
            primary: dWhite),
        onPressed: () async {
          Navigator.of(context).pop();
          selectTypePrint(TYPE_IMPRESSION.qrCode);
        },
        child: Text(
          Strings.exportAllQrCode,
          style: ThemeElements(context: context).styleText(color: Colors.black),
        )),
  );
}

tileBilletsExp(BuildContext context, Function selectTypePrint) {
  return ListTile(
    leading: icone(Icons.chrome_reader_mode_outlined),
    title: ElevatedButton(
        style: ElevatedButton.styleFrom(
            fixedSize: Size(SizeConfig.blockSizeHorizontal * 80,
                SizeConfig.safeBlockVertical * 7),
            primary: dWhite),
        onPressed: () async {
          Navigator.of(context).pop();
          selectTypePrint(TYPE_IMPRESSION.billet);
        },
        child: Text(
          Strings.exportAllBillets,
          style: ThemeElements(context: context).styleText(color: Colors.black),
        )),
  );
}
