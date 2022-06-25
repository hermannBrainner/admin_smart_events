import 'package:flutter/material.dart';

import '/outils/widgets/main.dart';
import 'elements/main.dart';

class BoutonRetour extends StatelessWidget {
  const BoutonRetour({
    required this.press,
  });

  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          radius: 23,
          backgroundColor:
              ThemeElements(context: context, mode: ColorMode.envers)
                  .themeColor,
          child: Icon(
            Icons.arrow_back,
            color: ThemeElements(context: context, mode: ColorMode.endroit)
                .themeColor,
            size: 23,
          ),
        ),
      ),
    );
  }
}

class BoutonLeadingWithAlert extends StatelessWidget {
  final int nbreAlert;

  const BoutonLeadingWithAlert({Key? key, required this.nbreAlert})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 23,
            backgroundColor:
                ThemeElements(context: context, mode: ColorMode.envers)
                    .themeColor,
            child: IconButton(
              icon: Icon(Icons.menu,
                  size: 23,
                  color:
                      ThemeElements(context: context, mode: ColorMode.endroit)
                          .themeColor),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ),
        Positioned(
          right: 5,
          top: 5,
          child: nbreAlertW(context, nbreAlert),
        )
      ],
    );
  }
}

class BoutonLeading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        radius: 23,
        backgroundColor:
            ThemeElements(context: context, mode: ColorMode.envers).themeColor,
        child: IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          icon: Icon(Icons.menu,
              color: ThemeElements(context: context, mode: ColorMode.endroit)
                  .themeColor),
          iconSize: 23,
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        ),
      ),
    );
  }
}
