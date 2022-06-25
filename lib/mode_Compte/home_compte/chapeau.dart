import 'package:flutter/material.dart';

import '/outils/size_configs.dart';
import '/providers/theme/primary_box_decoration.dart';
import 'menu_items.dart';

Widget chapeauCeremonies(BuildContext context,
    {required fctSwitch, required String itemCourant}) {
  return Container(
    height: 80,
    width: double.infinity,
    decoration: BoxDecorationBlue(context,
        topRigth: 40, topLeft: 40, bottomRigth: 0, bottomLeft: 0),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.only(
            left: SizeConfig.blockSizeHorizontal * 5,
            top: SizeConfig.blockSizeVertical * 1.5,
            bottom: SizeConfig.blockSizeVertical * 1.5),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            width: SizeConfig.blockSizeHorizontal * 55,
            child: ItemMenuCeremonie<String>(
              value: ItemMenuCeremonie.ceremonie,
              groupValue: itemCourant,
              onChanged: (value) {
                fctSwitch(value);
              },
            ),
          ),
          Container(
            width: SizeConfig.blockSizeHorizontal * 45,
            child: ItemMenuCeremonie<String>(
              value: ItemMenuCeremonie.parrainage,
              groupValue: itemCourant,
              onChanged: (value) {
                fctSwitch(value);
              },
            ),
          ),
          Container(
            width: SizeConfig.blockSizeHorizontal * 40,
            child: ItemMenuCeremonie<String>(
              value: ItemMenuCeremonie.compte,
              groupValue: itemCourant,
              onChanged: (value) {
                fctSwitch(value);
              },
            ),
          ),
        ]),
      ),
    ),
  );
}
