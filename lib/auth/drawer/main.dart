import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/outils/extensions/string.dart';
import '/outils/extensions/time.dart';
import '/outils/size_configs.dart';
import '/outils/widgets/main.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/bouton_retour.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/strings.dart';
import 'blocs/block_horloge.dart';
import 'blocs/block_invite.dart';
import 'blocs/block_logout.dart';
import 'blocs/block_normal.dart';

class UsefulDrawer extends StatelessWidget {
  double coef = 4;
  double coefText = 2;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapshot) {
          if (!userSnapshot.hasData) {
            return getLoadingWidget(context);
          } else {
            final user = userSnapshot.data as User;

            return SafeArea(
              child: Drawer(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40),
                          bottomRight: Radius.circular(40))),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        blockHorloge(context),
                        blockNormal(context,
                            coefText: coefText,
                            coef: coef,
                            isInvite: user.isAnonymous),
                        blockInvite(context, coefText: coefText, coef: coef),
                        blockLogOut(context,
                            coefText: coefText,
                            coef: coef,
                            isInvite: user.isAnonymous),
                      ],
                    ),
                  )),
            );
          }
        });
  }
}

detailsCeremonie(BuildContext context) {
  return Consumer<CeremonieProvider>(builder: (context, provider, child) {
    return Container(
      height: SizeConfig.safeBlockVertical * 18,
      // color: Colors.red,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
              child: Text(
            provider.ceremonie!.titreCeremonie.upperDebut(),
            textAlign: TextAlign.left,
            style: ThemeElements(context: context).styleText(
                fontSize: SizeConfig.safeBlockVertical * 3,
                fontWeight: FontWeight.bold),
          )),
          Expanded(
              child: Text(
            "@" + provider.ceremonie!.lieuCeremonie.upperDebut(),
            textAlign: TextAlign.left,
            style: ThemeElements(context: context).styleText(
                fontSize: SizeConfig.safeBlockVertical * 2.5,
                fontWeight: FontWeight.normal),
          )),
          Expanded(
              child: Text(
            provider.ceremonie!.dateCeremonie
                    .toStringExt(separator: "/")
                    .trim() +
                " à " +
                provider.ceremonie!.dateCeremonie.hourString(),
            textAlign: TextAlign.left,
            style: ThemeElements(context: context).styleText(
                fontSize: SizeConfig.safeBlockVertical * 2.5,
                fontWeight: FontWeight.normal),
          )),
          SizedBox(
            height: SizeConfig.safeBlockVertical * 2,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      provider.billetsInv.length.toString().upperDebut(),
                      textAlign: TextAlign.left,
                      style: ThemeElements(context: context).styleText(
                          fontSize: SizeConfig.safeBlockVertical * 2.5,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      " Billets",
                      textAlign: TextAlign.left,
                      style: ThemeElements(context: context).styleText(
                          fontSize: SizeConfig.safeBlockVertical * 2.5,
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: SizeConfig.safeBlockHorizontal * 4,
              ),
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      (provider.billetsInv
                              .fold(
                                  0,
                                  (int prev, billet) =>
                                      prev + billet.nbrePersonnes.toInt())
                              .toString())
                          .upperDebut(),
                      textAlign: TextAlign.left,
                      style: ThemeElements(context: context).styleText(
                          fontSize: SizeConfig.safeBlockVertical * 2.5,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      " invités",
                      textAlign: TextAlign.left,
                      style: ThemeElements(context: context).styleText(
                          fontSize: SizeConfig.safeBlockVertical * 2.5,
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  });
}

Widget menuIcon(BuildContext context) {
  return Consumer<CeremonieProvider>(builder: (context, provider, child) {
    Map<String, int> data = provider.getAlertNbres();
    int nbreTotal = data[Strings.total]! +
        provider.billetsInv
            .where((billet) => billet.estArrive && !billet.estInstalle)
            .toList()
            .length;

    if (nbreTotal > 0) {
      return BoutonLeadingWithAlert(
        nbreAlert: nbreTotal,
      );
    } else {
      return BoutonLeading();
    }
  });
}
