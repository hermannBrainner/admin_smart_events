import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/auth/drawer/main.dart';
import '/outils/widgets/main.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/bouton_retour.dart';
import '/providers/theme/strings.dart';
import '../_controllers/billet.dart';
import '../_models/billet.dart';
import 'liste.dart';

class ListesMainView extends StatelessWidget {
  static const String routeName = "/listeInvites_view";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //    backgroundColor: dBlack,
      drawer: UsefulDrawer(),
      appBar: AppBar(
        leading: BoutonLeading(),
        title: Text(Strings.pageListeInvites),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: Billet.all(),
          builder: (context, qs) {
            if (qs.hasData) {
              return Consumer<CeremonieProvider>(
                  builder: (context, provider, child) {
                List<Billet> billets = BilletCtrl.qsToList(qs.data!)
                    .where((billet) => provider.ceremonie!.idsBillets
                        .cast<String>()
                        .contains(billet.id))
                    .toList();
                return BilletsListe(
                  billets: billets,
                );
              });
            }
            return getLoadingWidget(context, taille: 200);
          }),
    );
  }
}
