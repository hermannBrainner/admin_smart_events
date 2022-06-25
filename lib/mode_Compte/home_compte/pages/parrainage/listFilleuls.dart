import 'package:flutter/material.dart';

import '/mode_Compte/_models/filleul.dart';
import '/mode_Compte/_models/user_app.dart';
import '/outils/constantes/colors.dart';
import '/outils/shimmer_widgets/filleul.dart';
import '/outils/size_configs.dart';
import '/outils/widgets/main.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/primary_bouton.dart';
import 'fab/main.dart';
import 'tile_filleul/main.dart';

Widget listeFilleuls(BuildContext context, UserApp userApp,
    ScrollController scrollController, bool isFAB, Function switchPage) {
  bool bCanTake = false;

  return FutureBuilder<List<Filleul>>(
      future: userApp.filleuls(),
      builder: (context, qs) {
        if (!qs.hasData) {
          return Column(
            children: [
              cashDispo(context, 0),
              btnAskCash(context, bCanTake),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: false,
                    controller: scrollController,
                    scrollDirection: Axis.vertical,
                    itemCount: userApp.idsFilleuls.length,
                    itemBuilder: (BuildContext context, int id) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8.0),
                        child: filleulShimmer(context),
                      );
                    }),
              )
            ],
          );
        } else {
          return Stack(
            children: [
              Column(
                children: [
                  cashDispo(
                      context,
                      qs.data!
                              .where((filleul) =>
                                  filleul.primeDebloquee && !filleul.primeRecue)
                              .length *
                          5.0),
                  btnAskCash(context, bCanTake),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: false,
                        controller: scrollController,
                        scrollDirection: Axis.vertical,
                        itemCount: qs.data!.length,
                        itemBuilder: (BuildContext context, int id) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8.0),
                            child: carteFilleul(
                              filleul: qs.data![id],
                            ),
                          );
                        }),
                  )
                ],
              ),
              Positioned(
                  right: 20,
                  bottom: 5,
                  child: FlottantBtnNewFilleul(context, isFAB, switchPage))
            ],
          );
        }
      });
}

cashDispo(BuildContext context, double montant) {
  double radius = 60;
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 10),
    child: Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius * 2),
          border: Border.all(
              color: ThemeElements(context: context).whichBlue, width: 1)),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.yellow,
        child: Text(
          montant.toString() + "€",
          style: ThemeElements(context: context).styleText(
              color: dBlack,
              fontWeight: FontWeight.bold,
              fontSize: radius * 0.6),
        ),
      ),
    ),
  );
}

btnAskCash(BuildContext context, bool bCanTake) {
  return Container(
    width: SizeConfig.safeBlockHorizontal * 50,
    padding: EdgeInsets.symmetric(vertical: 15),
    child: PrimaryButton(
        isBold: true,
        color: (bCanTake) ? null : Colors.grey,
        text: "Demander le cash",
        press: () {
          if (!bCanTake) {
            showFlushbar(context, false, "",
                "Vous devez payer pour une cérémonie, pour recevoir vos primes!!!");
          }
        }),
  );
}
