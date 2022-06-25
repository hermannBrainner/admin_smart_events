import 'package:flutter/material.dart';

import '/providers/theme/elements/main.dart';

Widget boutonAdd(
    {required String titre,
    bool displaySelection = false,
    bool isAllSelected = false,
    required bool isFAB,
    required BuildContext context,
    required Function onTap}) {
  if (displaySelection) {
    return Positioned(
        right: 10,
        bottom: 10,
        child: FloatingActionButton(
          onPressed: () {
            onTap();
          },
          backgroundColor: ThemeElements(context: context).whichBlue,
          child: Icon(
              isAllSelected ? Icons.radio_button_checked : Icons.select_all,
              color: ThemeElements(context: context, mode: ColorMode.endroit)
                  .themeColor),
        ));
  }

  return Positioned(
      right: 10,
      bottom: 10,
      child: isFAB
          ? btnAdd(onTap: onTap, context: context)
          : btnAddEtendu(onTap: onTap, context: context, titre: titre));
}

Widget btnAdd({required BuildContext context, required Function onTap}) =>
    AnimatedContainer(
      duration: Duration(milliseconds: 400),
      curve: Curves.linear,
      width: 50,
      height: 50,
      child: FloatingActionButton(
        onPressed: () {
          onTap();
        },
        backgroundColor: ThemeElements(context: context).whichBlue,
        child: Icon(Icons.add,
            color: ThemeElements(context: context, mode: ColorMode.endroit)
                .themeColor),
      ),
    );

Widget btnAddEtendu(
        {required String titre,
        required BuildContext context,
        required Function onTap}) =>
    AnimatedContainer(
      duration: Duration(milliseconds: 400),
      curve: Curves.linear,
      width: 170,
      height: 50,
      child: FloatingActionButton.extended(
        backgroundColor: ThemeElements(context: context).whichBlue,
        onPressed: () {
          onTap();
        },
        icon: Icon(Icons.add,
            color: ThemeElements(context: context, mode: ColorMode.endroit)
                .themeColor),
        label: Center(
          child: Text(
            titre,
            style: ThemeElements(context: context).styleText(
                fontSize: 15,
                color: ThemeElements(context: context, mode: ColorMode.endroit)
                    .themeColor),
          ),
        ),
      ),
    );
