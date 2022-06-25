import 'package:flutter/material.dart';

import '/providers/theme/primary_box_decoration.dart';
import 'main.dart';

filleulShimmer(BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
    decoration: BoxDecorationPrimary(context,
        topRigth: 20, topLeft: 20, bottomRigth: 20, bottomLeft: 20),
    width: double.infinity,
    height: 150,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomWidget.circular(
              height: 30,
              width: 30,
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomWidget.rectangular(
                  width: 100,
                  height: 30,
                ),
                CustomWidget.rectangular(
                  width: 150,
                  height: 30,
                ),
                CustomWidget.rectangular(
                  shapeBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  width: 220,
                  height: 30,
                ),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0),
          child: CustomWidget.rectangular(
            shapeBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            height: 30,
            width: 30,
          ),
        )
      ],
    ),
  );
}
