import 'package:flutter/material.dart';

import '/providers/theme/elements/main.dart';
import 'menu_items.dart';

Widget menuListes(
    BuildContext context, String menuCourant, Function switchItem) {
  return Container(
    height: 80,
    color: ThemeElements(context: context, mode: ColorMode.endroit).themeColor,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
            children: ItemMenuListesInvites.menuItems.map((menu) {
          return ItemMenuListesInvites<String>(
            value: menu,
            groupValue: menuCourant,
            onChanged: (value) {
              switchItem(value);
            },
          );
        }).toList()),
      ),
    ),
  );
}
