import 'package:flutter/material.dart';

import '/providers/ceremonie.dart';
import 'components/menu_items.dart';
import 'switch_chapeau.dart';
import 'switch_page.dart';

class HomeListe extends StatefulWidget {
  final CeremonieProvider provider;

  HomeListe({required this.provider});

  @override
  _HomeListeState createState() => _HomeListeState();
}

class _HomeListeState extends State<HomeListe> {
  String itemCourant = ItemMenuHome.salle;

  @override
  void initState() {
    super.initState();
  }

  switchItem(String item) {
    setState(() {
      itemCourant = item;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 80,
          //      color: dBlack,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: ItemMenuHome.allItems.map((item) {
                  return ItemMenuHome<String>(
                    value: item,
                    groupValue: itemCourant,
                    onChanged: (value) {
                      switchItem(value);
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        ChapeauHome(context, itemPage: itemCourant),
        PageHome(
            itemPage: itemCourant, context: context, provider: widget.provider)
      ],
    );
  }
}
