import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/outils/widgets/main.dart';
import '/providers/theme/elements/main.dart';

Widget chapeauListes(BuildContext context, TextEditingController searchview,
    {required int totalBillet,
    required int nbreInvites,
    required fctOnSubmit,
    required Function fctOnClear}) {
  return Container(
    color: ThemeElements(context: context, mode: ColorMode.endroit).themeColor,
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
      height: 150,
      decoration: BoxDecoration(
          color: ThemeElements(context: context)
              .whichBlue, //ThemeElements(context: context).whichBlue ,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(40), topLeft: Radius.circular(40))),
      child: Column(
        children: [
          Text("$nbreInvites Invités",
              style: GoogleFonts.inter(
                  color:
                      ThemeElements(context: context, mode: ColorMode.endroit)
                          .themeColor,
                  fontSize: 25)),
          Text("( $totalBillet billets )",
              style: GoogleFonts.inter(
                  color:
                      ThemeElements(context: context, mode: ColorMode.endroit)
                          .themeColor
                          .withOpacity(0.5),
                  fontSize: 20)),
          SizedBox(
            height: 20,
          ),
          customSearchInputText(
              hintText: "Nom de l'invité ....",
              fctOnSubmit: fctOnSubmit,
              searchview: searchview,
              fctOnClear: fctOnClear)
        ],
      ),
    ),
  );
}
