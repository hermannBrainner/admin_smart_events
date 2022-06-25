import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/outils/constantes/colors.dart';
import '/outils/extensions/string.dart';
import '/outils/size_configs.dart';
import '/outils/widgets/main.dart';
import '/providers/theme/elements/boutons.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/primary_box_decoration.dart';
import '/providers/theme/strings.dart';

infoTile(
    {required Function setValue,
    required String key,
    required String hintValue,
    required Function switchDisplay,
    required TextEditingController textCtrl,
    required bool displayEdition,
    required Function onValidation,
    required BuildContext context}) {
  if (textCtrl.text.isEmpty) {
    textCtrl.text = hintValue;
  }

  RoundedLoadingButtonController btnPosCtrl = RoundedLoadingButtonController();

  return Container(
      width: double.infinity,
      decoration: BoxDecorationPrimary(context,
          topRigth: 10, topLeft: 10, bottomRigth: 10, bottomLeft: 10),
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.safeBlockVertical * 1,
        horizontal: SizeConfig.safeBlockHorizontal * 3,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.safeBlockHorizontal * 3,
        vertical: SizeConfig.safeBlockVertical * 2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: SizeConfig.safeBlockHorizontal * 60,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        key,
                        style: GoogleFonts.inter(
                            color: ThemeElements(
                                    context: context, mode: ColorMode.envers)
                                .themeColor
                                .withOpacity(0.5),
                            fontSize: 20),
                      ),
                      SizedBox(height: SizeConfig.safeBlockVertical * 2),
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: 250.0,
                          minHeight: 20.0,
                        ),
                        child: Text(
                          textCtrl.text,
                          softWrap: true,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.inter(
                              color: ThemeElements(
                                      context: context, mode: ColorMode.envers)
                                  .themeColor,
                              fontSize: 15),
                        ),
                      ),
                    ],
                  )),
              BoutonsOfTheme(
                      onPressed: () => switchDisplay(key), context: context)
                  .edit,
            ],
          ),
          sizedCustom(display: displayEdition, coef: 4),
          Visibility(
            visible: displayEdition,
            child: TextField(
              controller: textCtrl,
              style: TextStyle(
                  color: ThemeElements(context: context, mode: ColorMode.envers)
                      .themeColor),
              onChanged: (val) {
                setValue(val, key);
              },
              maxLines: 1,
              cursorColor: ThemeElements(context: context).whichBlue,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: ThemeElements(context: context).whichBlue,
                          width: 2.0)),
                  labelStyle: TextStyle(
                      color: ThemeElements(context: context).whichBlue),
                  labelText: key.upperDebut(),
                  hintText: hintValue,
                  border: OutlineInputBorder()),
            ),
          ),
          sizedCustom(display: displayEdition, coef: 2),
          Visibility(
            visible: displayEdition,
            child: RoundedLoadingButton(
              color: ThemeElements(context: context).whichBlue,
              controller: btnPosCtrl,
              borderRadius: SizeConfig.safeBlockHorizontal * 3,
              successColor: Colors.lightGreenAccent,
              width: SizeConfig.safeBlockHorizontal * 40,
              elevation: SizeConfig.safeBlockHorizontal * 2,
              height: SizeConfig.safeBlockVertical * 7,
              onPressed: () async {
                await onValidation(key);
                switchDisplay(key);
              },
              child: Text(
                Strings.valider,
                style: TextStyle(color: dBlack),
              ),
            ),
          )
        ],
      ));
}
