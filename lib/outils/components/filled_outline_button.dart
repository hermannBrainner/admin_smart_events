import 'package:flutter/material.dart';

import '../../../providers/theme/constantes.dart';
import '../constantes/colors.dart';

class FillOutlineButton extends StatelessWidget {
  const FillOutlineButton({
    this.isFilled = true,
    required this.press,
    required this.text,
  });

  final bool isFilled;
  final VoidCallback press;
  final String text;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(color: dWhite),
      ),
      elevation: isFilled ? 2 : 0,
      color: isFilled ? dWhite : Colors.transparent,
      onPressed: press,
      child: Text(
        text,
        style: TextStyle(
          color: isFilled ? kColorBlackPrimary : dWhite,
          fontSize: 12,
        ),
      ),
    );
  }
}
