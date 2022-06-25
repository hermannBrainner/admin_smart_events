import 'dart:ui';

import 'package:flutter/material.dart';

import '/providers/theme/elements/logo.dart';
import '/providers/theme/elements/main.dart';

class MenucontextDispos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<List<dynamic>> valeurs = [
      [Logo.PLAN_SALLE, 'Plan de la salle', Icons.event_seat_outlined],
      [Logo.EXPORT, "Imprimer les billets", Icons.print],
      [Logo.IMPORT, "Importer des invites", Icons.file_upload],
      [Logo.MESSAGE, "Besoin d'aide ?", Icons.help]
    ];

    return SimpleDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      contentPadding: EdgeInsets.zero,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 18, left: 8, right: 8, bottom: 8),
          child: Container(
            width: 600,
            height: 240,
            child: ListView.builder(
                itemCount: valeurs.length,
                itemBuilder: (BuildContext context, int idx) {
                  var actionName = valeurs[idx][0];
                  var title = valeurs[idx][1];
                  return InkWell(
                    onTap: () async {
                      Navigator.pop(context);

                      await Logo(ACTION_NAME: actionName, context: context)
                          .show();
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: ThemeElements(context: context)
                            .whichBlue
                            .withOpacity(0.7),
                        child: Icon(
                          valeurs[idx][2],
                          color: ThemeElements(context: context)
                              .themeColor
                              .withOpacity(0.7),
                        ),
                      ),
                      title: Text(
                        title,
                        style: ThemeElements(context: context)
                            .styleText(fontSize: 15),
                      ),
                    ),
                  );
                }),
          ),
        )
      ],
    );
  }
}
