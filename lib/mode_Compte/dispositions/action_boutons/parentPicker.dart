import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/mode_Compte/_models/table.dart';
import '/outils/extensions/string.dart';
import '/outils/size_configs.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/elements/main.dart';

widgetPickerParent(
    BuildContext context, dynamic oneChild, Function editParentSelection) {
  return Expanded(
    child: SingleChildScrollView(
        child: Consumer<CeremonieProvider>(builder: (context, provider, child) {
      List<dynamic> allParents = (oneChild.runtimeType == TableInvite)
          ? provider.zonesSalle
          : provider.tablesInv;

      dynamic parentSelected;

      return StatefulBuilder(
          builder: (BuildContext contextModal, StateSetter setState) {
        return Wrap(
          children: List.generate(allParents.length, (index) {
            dynamic oneParent = allParents[index];

            return Padding(
              padding: const EdgeInsets.all(6.0),
              child: FilterChip(
                backgroundColor:
                    ThemeElements(context: context, mode: ColorMode.envers)
                        .whichBlue,
                //Colors.tealAccent[200],
                avatar: CircleAvatar(
                  backgroundColor:
                      ThemeElements(context: context, mode: ColorMode.endroit)
                          .whichBlue,
                  child: Text(
                    oneParent.nom.substring(0, 1),
                    style: ThemeElements(context: context).styleText(
                        color: ThemeElements(
                                context: context, mode: ColorMode.endroit)
                            .themeColor),
                  ),
                ),
                label: Text(
                  (oneParent.nom as String).upperDebut(),
                  style: ThemeElements(context: context).styleText(
                      color: ThemeElements(
                              context: context, mode: ColorMode.envers)
                          .themeColor,
                      fontSize: SizeConfig.safeBlockVertical * 2),
                ),
                selected: parentSelected == oneParent,
                selectedColor: (oneParent.couleur as String).couleurFromHex(),
                onSelected: (bool selected) {
                  setState(() {
                    if (selected) {
                      parentSelected = oneParent;
                      editParentSelection(oneParent);
                    }
                  });
                },
              ),
            );
          }),
        );
      });
    })),
  );
}
