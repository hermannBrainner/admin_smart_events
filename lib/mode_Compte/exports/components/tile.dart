import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '/mode_Compte/_models/billet.dart';
import '/mode_Compte/_models/ceremonie.dart';
import '/outils/extensions/string.dart';
import '/outils/extensions/time.dart';
import '/outils/fonctions/fonctions.dart';
import '/outils/size_configs.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/elements/logo.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/strings.dart';

photo(Billet billet) {
  return Consumer<CeremonieProvider>(builder: (context, provider, child) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(60.0),
          child: QrImage(
            data: billet.dataQrCode(provider.ceremonie!),
            version: QrVersions.auto,
          ),
        ),
      ],
    );
  });
}

void displayQrCode(BuildContext gCtx, Billet billet,
    {double hauteurPopup = 400, double largeurPopup = 400}) {
  showDialog(
    context: gCtx,
    builder: (pctx) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            content: SingleChildScrollView(
              child: Container(
                height: hauteurPopup,
                width: largeurPopup,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Center(
                                child: Text(
                          billet.nom,
                          textAlign: TextAlign.center,
                          style: ThemeElements(context: context)
                              .styleText(fontWeight: FontWeight.bold),
                        ))),
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.close_rounded,
                              color: Colors.redAccent,
                            ))
                      ],
                    ),
                    Divider(
                        color: Colors.black,
                        height: SizeConfig.safeBlockVertical * 2),
                    photo(billet)
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

pings(dynamic parent, BuildContext context) {
  double rayon = 5;

  if (isNullOrEmpty(parent)) {
    return Container(
      width: 2 * rayon,
      height: 2 * rayon,
      decoration: BoxDecoration(
        color: ThemeElements(context: context).whichBlue,
        borderRadius: BorderRadius.circular(rayon),
      ),
    );
  } else {
    return Container(
      width: 2 * rayon,
      height: 2 * rayon,
      decoration: BoxDecoration(
        color: (parent.couleur as String).couleurFromHex(),
        borderRadius: BorderRadius.circular(rayon),
      ),
    );
  }
}

Widget leading(dynamic parent, Billet billet, BuildContext context,
    bool displaycheckBx, Function fctRefrech, bool isChecked) {
  double cote = 50;

  double rayonPings = 5;

  if (displaycheckBx) {
    return Checkbox(
        value: isChecked,
        onChanged: (value) {
          fctRefrech(billet, !isChecked);
        });
  } else {
    return Stack(
      children: [
        Container(
          width: cote,
          height: cote,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ThemeElements(context: context).whichBlue,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: IconButton(
              icon: Icon(Icons.qr_code_scanner_sharp,
                  color:
                      ThemeElements(context: context, mode: ColorMode.endroit)
                          .themeColor),
              onPressed: () {
                displayQrCode(context, billet);
              },
            ),
          ),
        ),
        Positioned(
            right: 0, top: cote - 2 * rayonPings, child: pings(parent, context))
      ],
    );
  }
}

exportTime(Billet billet, BuildContext context) {
  Intl.defaultLocale = Strings.localFr;
  String t = "";
  if (!isNullOrEmpty(billet.lastExport)) {
    if (billet.lastExport!.isToday()) {
      t = billet.lastExport!.hourString(separator: ":");
    } else {
      t = DateFormat('dd MMMM')
          .format(billet.lastExport!.toDate())
          .toLowerCase();
    }
  }

  return Text(
    t,
    style: ThemeElements(context: context).styleText(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: Color.fromRGBO(148, 141, 170, 0.9)),
  );
}

qrBilletTile(
    Billet billet, dynamic parent, Ceremonie ceremonie, BuildContext context,
    {required bool displaycheckBx, required fctRefrech, required isSelected}) {
  return Container(
    child: ListTile(
      leading: leading(
          parent, billet, context, displaycheckBx, fctRefrech, isSelected),
      title: Text(
        billet.nom,
        style: ThemeElements(context: context).styleText(
          fontSize: 15,
          fontWeight:
              FontWeight.bold, /* color: Color.fromRGBO(18, 11, 52, .8)*/
        ),
      ),
      subtitle: exportTime(billet, context),
      trailing: Visibility(
        visible: !displaycheckBx,
        child: IconButton(
          icon: Icon(Icons.print,
              color: ThemeElements(context: context).whichBlue),
          onPressed: () async {
            CeremonieProvider provider = context.read<CeremonieProvider>();

            await Logo(
                    ceremonieProvider: provider,
                    billet: billet,
                    ACTION_NAME: Logo.PRINT_BILLET,
                    context: context)
                .show();

            // displayQrCode( context, billet);
          },
        ),
      ),
    ),
  );
}
