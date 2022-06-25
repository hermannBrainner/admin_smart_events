import 'package:flutter/material.dart';

import '/providers/ceremonie.dart';
import '/providers/theme/elements/main.dart';
import 'components/details_items.dart';
import 'components/menu_items.dart';
import 'pages/modification_autres.dart';
import 'pages/modification_billets.dart';
import 'pages/modification_dispositions.dart';
import 'pages/modification_utilisation.dart';

Widget PageHome(
    {required String itemPage,
    required BuildContext context,
    required CeremonieProvider provider}) {
  late Widget wContent;

  switch (itemPage) {
    case ItemMenuHome.ceremonie:
      wContent = SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: ItemDetailsCeremonie.items.map((value) {
            return ItemDetailsCeremonie<String>(
              context: context,
              provider: provider,
              item: value,
            );
          }).toList(),
        ),
      );
      break;
    case ItemMenuHome.salle:
      wContent = PageModifDispositions();
      break;
    case ItemMenuHome.use:
      wContent = PageModifUtilisation();
      break;
    case ItemMenuHome.billets:
      wContent = PageModifBillets();
      break;
    case ItemMenuHome.autres:
      wContent = PageModifAutres();
      break;
  }

  return Expanded(
    child: Container(
      color: ThemeElements(context: context).whichBlue,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 1),
        decoration: BoxDecoration(
            color: ThemeElements(context: context, mode: ColorMode.endroit)
                .themeColor, // dBlack,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30))),
        child: wContent,
      ),
    ),
  );
}
