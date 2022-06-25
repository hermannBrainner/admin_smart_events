import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '/outils/extensions/time.dart';
import '/outils/size_configs.dart';
import '../../../providers/ceremonie.dart';
import 'main.dart';

class HorlogeAndAmpoule extends ThemeElements {
  HorlogeAndAmpoule({required BuildContext context}) : super(context: context);

  Widget get horloge {
    CeremonieProvider ceremonieProvider = context.read<CeremonieProvider>();

    return Visibility(
      visible: !ceremonieProvider.ceremonie!.dateCeremonie.isBeforeToday(),
      child: Container(
        width: SizeConfig.safeBlockHorizontal * 40,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(top: 10, right: 5, bottom: 10),
              constraints: BoxConstraints(
                maxHeight: 250.0,
                minHeight: 40.0,
              ),
              child: Text(
                ceremonieProvider.ceremonie!.titreCeremonie,
                softWrap: true,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    color:
                        ThemeElements(context: context, mode: ColorMode.envers)
                            .themeColor,
                    fontSize: 25),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      ceremonieProvider.ceremonie!.dateCeremonie
                          .joursHeuresRestant()[0],
                      style:
                          styleText(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    Text("jours",
                        style: styleText(
                            fontWeight: FontWeight.bold, fontSize: 18))
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    Text(
                        ceremonieProvider.ceremonie!.dateCeremonie
                            .joursHeuresRestant()[1],
                        style: styleText(
                            fontWeight: FontWeight.bold, fontSize: 25)),
                    Text("heures",
                        style: styleText(
                            fontWeight: FontWeight.bold, fontSize: 18))
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget ampoule({Function? switchAmpoule}) {
    return GestureDetector(
      onTap: () {
        provider
            .upDateTheme(!(provider.themeData.brightness == Brightness.light));

        if (switchAmpoule != null) switchAmpoule();
      },
      child: new Container(
        height: 100,
        width: 54,
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30)),
          shape: BoxShape.rectangle,
          color: ThemeElements(context: context).whichBlue,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 14, right: 14, bottom: 28),
          child: provider.themeData.brightness == Brightness.light
              ? Image.asset(
                  "assets/bulb_on.png",
                  fit: BoxFit.fitHeight,
                )
              : Image.asset(
                  "assets/bulb_off.png",
                  fit: BoxFit.fitHeight,
                ),
        ),
      ),
    );
  }
}
