import 'package:flutter/material.dart';

import '/mode_Compte/_models/filleul.dart';
import '/mode_Compte/home_compte/pages/parrainage/tile_filleul/components.dart';
import '/providers/theme/elements/main.dart';

class carteFilleul extends StatelessWidget {
  final Filleul filleul;

  carteFilleul({Key? key, required this.filleul}) : super(key: key);

  static const double rayonPings = 15;

  String get infoTexte {
    if (filleul.idUser == null) {
      return "Attente creation du compte";
    } else if (!filleul.primeDebloquee) {
      return "Attente premier paiement";
    } else if (!filleul.primeRecue) {
      return "Prime disponible";
    } else {
      return "Prime reçue";
    }
  }

  Color get colorPings {
    if (filleul.idUser == null) {
      return Colors.deepOrangeAccent;
    } else if (!filleul.primeDebloquee) {
      return Colors.yellowAccent;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      color: ThemeElements(context: context, mode: ColorMode.endroit).whichBlue,
      child: Container(
        width: double.infinity,
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                pings(context, filleul, rayonPings, colorPings),
                SizedBox(
                  width: 2,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    nameWidget(context, filleul),
                    emailWidget(context, filleul),
                    infoWidget(context, rayonPings, colorPings, infoTexte)
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.0),
              child: leadingFilleul(context, filleul),
            )
          ],
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
