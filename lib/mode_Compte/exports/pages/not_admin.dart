import 'package:flutter/material.dart';

import '/outils/constantes/colors.dart';
import '/outils/size_configs.dart';

notAdmin() {
  return Center(
    child: Container(
      width: SizeConfig.safeBlockHorizontal * 90,
      height: SizeConfig.safeBlockVertical * 50,
      decoration: BoxDecoration(
          color: dWhite,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.redAccent, width: 5.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.warning_amber_outlined,
            size: SizeConfig.safeBlockHorizontal * 50,
            color: Colors.yellowAccent,
          ),
        ],
      ),
    ),
  );
}
