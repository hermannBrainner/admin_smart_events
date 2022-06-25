import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/mode_Compte/_models/billet.dart';
import '/outils/widgets/no_data.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/primary_box_decoration.dart';
import '../ligne.dart';

Widget listeInvites(List<Billet> listDisplay) {
  return Consumer<CeremonieProvider>(builder: (context, provider, child) {
    return Expanded(
      child: Container(
        decoration: BoxDecorationPrimary(context,
            topRigth: 0, topLeft: 0, bottomRigth: 0, bottomLeft: 0),
        child: listDisplay.length == 0
            ? infoW(context)
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: List.generate(listDisplay.length, (id) {
                    var billet = listDisplay[id];
                    return ligneBillet(
                        billet: billet,
                        table: billet.getMyTable(provider),
                        zone: billet.getMyZone(provider));
                  }),
                ),
              ),
      ),
    );
  });
}
