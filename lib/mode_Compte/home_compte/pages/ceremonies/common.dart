import 'package:flutter/material.dart';

import '/outils/size_configs.dart';

Widget bottomBlock() {
  return Container(
    width: double.infinity,
    height: SizeConfig.safeBlockVertical * 9.8,
  );
}

Widget topBlock() {
  return Container(
    width: double.infinity,
    height: SizeConfig.safeBlockVertical * 17,
  );
}
