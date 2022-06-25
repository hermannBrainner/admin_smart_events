import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/outils/constantes/colors.dart';
import '/outils/size_configs.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/primary_box_decoration.dart';
import '/providers/theme/strings.dart';

class ItemDisposition<String> extends StatelessWidget {
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;

  const ItemDisposition({
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  static const un = 'I ';
  static const deux = 'II';
  static const trois = 'III';

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(value),
      child: Container(
        height: 80,
        decoration: BoxDecorationPrimary(context,
            topRigth: 10, topLeft: 10, bottomRigth: 10, bottomLeft: 10),
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.safeBlockHorizontal * 3,
            vertical: SizeConfig.safeBlockVertical * 2),
        child: Row(
          children: [
            _customRadioButton(context),
            SizedBox(width: 12),
            Text(
              value.toString(),
              style: GoogleFonts.inter(
                  color: (this.groupValue == this.value)
                      ? ThemeElements(context: context, mode: ColorMode.envers)
                          .themeColor
                      : ThemeElements(context: context, mode: ColorMode.envers)
                          .themeColor
                          .withOpacity(0.7),
                  fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _customRadioButton(context) {
    final leading;

    switch (value.toString()) {
      case Strings.dispoMax:
        leading = trois;
        break;
      case Strings.dispoMoyen:
        leading = deux;
        break;
      case Strings.dispoMin:
        leading = un;
        break;
      default:
        leading = un;
    }

    final isSelected = value == groupValue;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? dBlue : null,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isSelected ? dBlue : Colors.grey[300]!,
          width: 2,
        ),
      ),
      child: Text(
        leading,
        style: ThemeElements(context: context).styleText(
          color: isSelected ? dWhite : Colors.grey[600],
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}
