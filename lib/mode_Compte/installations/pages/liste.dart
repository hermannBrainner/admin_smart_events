import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/mode_Compte/_models/billet.dart';
import '/providers/ceremonie.dart';
import '../components/backgrounds.dart';
import '../components/info.dart';
import '../components/ligne.dart';

class InstallationsList extends StatelessWidget {
  final CeremonieProvider provider;

  const InstallationsList({
    Key? key,
    required this.provider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        swipeNotice(context),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: provider.billetsInv
                .where((billet) => billet.estArrive && !billet.estInstalle)
                .toList()
                .length,
            itemBuilder: (BuildContext context, int id) {
              Billet billet = provider.billetsInv
                  .where((billet) => billet.estArrive && !billet.estInstalle)
                  .toList()[id];
              return Dismissible(
                  background: validationBckg(),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (_) async {
                    await billet.installation();
                    await context
                        .read<CeremonieProvider>()
                        .refreshOnlyBillets();
                  },
                  key: ValueKey(billet.id),
                  child: billetTile(billet, billet.getMyTable(provider),
                      billet.getMyZone(provider), context));
            },
          ),
        ),
      ],
    );

    /**/
  }
}
