import 'package:flutter/material.dart';

import '/outils/fonctions/fonctions.dart';
import '/outils/size_configs.dart';
import '/providers/theme/elements/main.dart';
import '../../sign_out.dart';

Widget blockLogOut(
  BuildContext context, {
  required bool isInvite,
  required double coef,
  required double coefText,
}) {
  return Padding(
    padding: EdgeInsets.only(
      bottom: SizeConfig.safeBlockVertical * 3,
    ),
    child: Column(children: [
      Divider(color: Colors.black, height: SizeConfig.safeBlockVertical * coef),
      InkWell(
        onTap: () async {
          await signOut(context, isInvite);
        },
        child: ListTile(
            leading: Icon(
              Icons.logout,
              color: Colors.red,
              size: SizeConfig.safeBlockVertical * coef,
            ),
            title: Text(
              "Quitter l'evenement",
              style: ThemeElements(context: context).styleText(
                  color: Colors.red,
                  fontSize: SizeConfig.safeBlockVertical * coefText),
            )),
      ),
      FutureBuilder<Map<String, String>>(
          future: getAppInfos(),
          builder: (context, v) {
            if (!v.hasData) {
              return Center();
            } else {
              final data = v.data as Map<String, String>;
              return Center(child: Text("Version " + data["VERSION"]!));
            }
          }),
    ]),
  );
}
