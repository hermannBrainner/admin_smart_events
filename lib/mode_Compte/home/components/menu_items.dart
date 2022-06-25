import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/providers/theme/elements/main.dart';

class ItemMenuHome<String> extends StatelessWidget {
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;

  static const use = "Utilisation";
  static const ceremonie = "Cérémonie";
  static const salle = "Salle";
  static const billets = "Billets";
  static const autres = "Autres";

  static const allItems = [use, salle, ceremonie, billets, autres];

  const ItemMenuHome({
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(value),
      child: vue(context),
    );
  }

  Widget vue(BuildContext context) {
    final isSelected = value == groupValue;

    final couleurTexte = isSelected
        ? ThemeElements(context: context, mode: ColorMode.envers).themeColor
        : ThemeElements(context: context, mode: ColorMode.envers)
            .themeColor
            .withOpacity(.3);
    final double tailleTexte = isSelected ? 32 : 29;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            margin: const EdgeInsets.only(right: 30),
            child: Text(
              value.toString(),
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  color: couleurTexte,
                  fontSize: tailleTexte),
            )),
      ],
    );
  }
}
