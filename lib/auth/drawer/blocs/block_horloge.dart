import 'package:flutter/material.dart';

import '/outils/size_configs.dart';
import '/providers/theme/elements/horloge_ampoule.dart';

Widget blockHorloge(BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(
        left: 20, right: 20, bottom: SizeConfig.safeBlockVertical * 1),
    child: Row(
      children: [
        HorlogeAndAmpoule(context: context).ampoule(),
        SizedBox(
          width: 20,
        ),
        HorlogeAndAmpoule(context: context).horloge
      ],
    ),
  );
}
