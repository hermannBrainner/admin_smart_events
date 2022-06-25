import 'package:flutter/material.dart';

import '/outils/constantes/colors.dart';

Widget validationBckg() {
  return Container(
    color: Colors.green,
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.event_seat,
            color: dWhite,
          ),
          Text(
            " Installé",
            style: TextStyle(
              color: dWhite,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
      alignment: Alignment.centerLeft,
    ),
  );
}
