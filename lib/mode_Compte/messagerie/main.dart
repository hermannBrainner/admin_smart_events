import 'package:flutter/material.dart';

import '/outils/size_configs.dart';
import '/providers/theme/bouton_retour.dart';
import 'liste.dart';

class MessagesScreen extends StatelessWidget {
  static const String routeName = "/message_screen";

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Messagerie",
        ),
        leading: BoutonRetour(
          press: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Body(),
      ),
    );
  }
}
