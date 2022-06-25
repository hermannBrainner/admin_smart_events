import 'package:flutter/material.dart';

import '/outils/size_configs.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/primary_box_decoration.dart';
import 'main.dart';

openMessagerie(BuildContext context) {
  double rayon = 80;
  return Padding(
      padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 5),
      child: Container(
        height: SizeConfig.safeBlockHorizontal * 75,
        width: double.infinity,
        decoration: BoxDecorationPrimary(context,
            topLeft: 10, topRigth: 10, bottomLeft: 10, bottomRigth: 10),
        padding: EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 0),
        margin: EdgeInsets.only(
          left: SizeConfig.safeBlockHorizontal * 5,
          right: SizeConfig.safeBlockHorizontal * 5,
          top: SizeConfig.safeBlockVertical * 2,
        ),
        child: Column(
          children: [
            Center(
                child: Icon(
              Icons.help_outline,
              color: ThemeElements(context: context).whichBlue,
              size: rayon,
            )),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.safeBlockVertical * 2,
              ),
              child: Text(
                "Besoin d'aide ?",
                style: ThemeElements(context: context).styleText(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color:
                        ThemeElements(context: context, mode: ColorMode.envers)
                            .themeColor),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.safeBlockVertical * 1,
              ),
              child: Text(
                "Trouvons la reponse qui vous convient",
                style: ThemeElements(context: context).styleText(
                    fontSize: 15,
                    color:
                        ThemeElements(context: context, mode: ColorMode.envers)
                            .themeColor),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: SizeConfig.safeBlockVertical * 3,
              ),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    side: Border.all(
                            color: ThemeElements(context: context).whichBlue,
                            width: 2)
                        .bottom),
                padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.safeBlockVertical * 2,
                ),
                minWidth: double.infinity,
                onPressed: () {
                  Navigator.pushNamed(context, MessagesScreen.routeName);
                },
                child: Text(
                  "Lancer la conversation",
                  style: ThemeElements(context: context).styleText(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: ThemeElements(context: context).whichBlue,
                  ),
                ),
              ),
            ),

            /* Container(
              height: rayon,
              width: rayon,
              margin: EdgeInsets.only(top:SizeConfig.safeBlockVertical * 3, ),
              decoration: BoxDecoration(
                border: Border.all(color: ThemeElements(context: context).whichBlue, width: 5),
                borderRadius:
                BorderRadius.all(Radius.circular(rayon)), //  angleArrondi(15),
                // color: colorFromHex(element.couleur)
              ),
              child:Text("") )*/
          ],
        ),
      ));
}
