import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/main_modes/main.dart';
import '/mode_Compte/_models/user_app.dart';
import '/outils/size_configs.dart';
import '/providers/theme/elements/logo.dart';
import '/providers/user_app.dart';
import 'welcome_screen.dart';

class Passerelle extends StatelessWidget {
  const Passerelle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final utilisateur = Provider.of<UserPhone?>(context);
    if (utilisateur == null) {
      return WelcomeScreen();
    } else if (utilisateur.isAnonymous) {
      return WelcomeScreen();
    } else {
      return FutureBuilder(
          future:
              context.read<UserAppProvider>().initFromPasserelle(utilisateur),
          builder: (BuildContext context, AsyncSnapshot snap) {
            if (!snap.hasData) {
              return Scaffold(
                body: Logo(context: context)
                    .withTexte(fontSize: SizeConfig.blockSizeHorizontal * 10),
              );
            } else {
              return ListeModes();
            }
          });
    }
  }
}
