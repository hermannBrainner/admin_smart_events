import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/outils/extensions/string.dart';
import '/outils/widgets/main.dart';
import '/providers/theme/elements/main.dart';

searchBar(BuildContext context,
    {required int inNbrePersonnes,
    required double hauteur,
    required String typePage,
    required Function fctOnSubmit,
    required TextEditingController searchview,
    required Function fctOnClear}) {
  String hintText = "Nom d'un" +
      (!typePage.toLowerAndTrim().contains("invité") ? "e " : " ") +
      typePage.toLowerAndTrim();

  return CustomPaint(
      painter: toileFond(hauteur: hauteur, context: context),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 50),
        height: hauteur,
        child: Column(
          children: [
            Text(" $inNbrePersonnes${typePage.upperDebut()}s",
                style: GoogleFonts.inter(
                    color:
                        ThemeElements(context: context, mode: ColorMode.endroit)
                            .themeColor,
                    fontSize: 25)),
            SizedBox(
              height: 10,
            ),
            customSearchInputText(
                hintText: hintText,
                fctOnSubmit: fctOnSubmit,
                searchview: searchview,
                fctOnClear: fctOnClear),
          ],
        ),
      ));
}

class toileFond extends CustomPainter {
  final double hauteur;
  final BuildContext context;

  Color? couleur;

  toileFond({required this.context, required this.hauteur, this.couleur});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = couleur ??
        ThemeElements(context: context).whichBlue; // Colors.green[800];
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, hauteur * 0.75);

    path.quadraticBezierTo(size.width / 2, hauteur, size.width, hauteur * 0.75);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
