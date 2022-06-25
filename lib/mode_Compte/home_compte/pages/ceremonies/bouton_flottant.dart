import 'package:flutter/material.dart';

import '/providers/theme/elements/main.dart';
import 'new.dart';

Widget buildFAB(BuildContext context) => AnimatedContainer(
      duration: Duration(milliseconds: 400),
      curve: Curves.linear,
      width: 50,
      height: 50,
      child: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, NewCeremonie.routeName);
        },
        //     backgroundColor: Theme.of(context).colorScheme.primary,,
        child: Icon(Icons.add),
      ),
    );

Widget buildExtendedFAB(BuildContext context) => AnimatedContainer(
      duration: Duration(milliseconds: 400),
      curve: Curves.linear,
      width: 200,
      height: 50,
      child: FloatingActionButton.extended(
        //  backgroundColor: Theme.of(context).colorScheme.primary,,
        onPressed: () {
          Navigator.pushNamed(context, NewCeremonie.routeName);
        },
        icon: Icon(Icons.add),
        label: Center(
          child: Text(
            "Nouvelle Ceremonie",
            style: ThemeElements(context: context).styleText(
                fontSize: 15,
                color: ThemeElements(context: context, mode: ColorMode.endroit)
                    .themeColor),
          ),
        ),
      ),
    );
