import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

import '/outils/fonctions/fonctions.dart';
import '/outils/size_configs.dart';
import '/providers/theme/elements/main.dart';

widgetPickerColor(
    BuildContext context, Color? colorSelected, Function editColor) {
  return Expanded(
    child: StatefulBuilder(
        builder: (BuildContext contextModal, StateSetter setState) {
      write(colorSelected == null, "color is null");
      List<Color> couleurs = [
        Colors.blue,
      ];
      colorSelected = colorSelected ?? Colors.red;

      return SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: colorSelected,
                  radius: SizeConfig.safeBlockVertical * 3,
                ),
                Card(
                  elevation: 2,
                  child: ColorPicker(
                    color: colorSelected!,
                    onColorChanged: (Color color) {
                      setState(() {
                        colorSelected = color;
                        editColor(colorSelected);
                      });
                    },
                    width: 44,
                    height: 44,
                    borderRadius: 22,
                    heading: Text(
                      'Choisir une couleur',
                      style: ThemeElements(
                        context: context,
                      ).styleText(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subheading: Text(
                      "Choisir l'ombrage",
                      style: ThemeElements(
                        context: context,
                      ).styleText(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }),
  );
}
