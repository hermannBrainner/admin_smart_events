import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/providers/theme/elements/main.dart';

class ItemMenuCeremonie<String> extends StatelessWidget {
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;

  static const compte = "Compte";
  static const ceremonie = "Cérémonies";
  static const parrainage = "Invitations";

  static const allItems = [ceremonie, compte, parrainage];

  const ItemMenuCeremonie({
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

    //     final couleurTexte = isSelected ? dBlack : dBlackLeger;
    final couleurTexte = isSelected
        ? ThemeElements(context: context, mode: ColorMode.endroit).themeColor
        : ThemeElements(context: context, mode: ColorMode.endroit)
            .themeColor
            .withOpacity(.3);

    final double tailleTexte = isSelected ? 32 : 29;

    return Container(
        color: Colors.transparent,
        // margin: const EdgeInsets.only(right: 30),
        child: Text(
          value.toString(),
          style: GoogleFonts.inter(color: couleurTexte, fontSize: tailleTexte),
        ));
  }
}
