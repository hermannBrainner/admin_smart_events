import 'package:flutter/material.dart';

import '/providers/theme/elements/main.dart';

Widget swipeNotice(BuildContext context) {
  return Column(
    children: [
      Container(
        alignment: Alignment.center,
        height: 80,
        child: Icon(
          Icons.swipe_right,
          size: 50, //size of the AnimatedIcon
          color: ThemeElements(context: context)
              .whichBlue, //color of the AnimatedIcon
        ),
      ),
      Center(
        child: Text(
          "GLISSEZ POUR VALIDER L'INSTALLATION",
          style: ThemeElements(context: context).styleText(
              fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
        ),
      )
    ],
  );
}
