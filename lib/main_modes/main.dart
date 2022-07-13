import 'package:flutter/material.dart';

import '/mode_Messagerie/main.dart';
import '/outils/size_configs.dart';
import '/outils/widgets/main.dart';
import '/providers/theme/bouton_retour.dart';
import '/providers/theme/primary_bouton.dart';

class ListeModes extends StatefulWidget {
  static const String routeName = "/ListeModesView";

  @override
  ListeModesState createState() => ListeModesState();
}

class ListeModesState extends State<ListeModes> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
        appBar: AppBar(
          leading: BoutonRetour(
            press: () => showDialog(
                context: context,
                builder: (context) =>
                    boiteDeDialogue(context, signOutComplete: true)),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 100),
                child: PrimaryButton(
                  text: "Messagerie",
                  press: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminMessagerie()));
                  },
                  isBold: true,
                  fontSize: 20,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 100),
                child: PrimaryButton(
                  text: "Caisse",
                  press: () => {},
                  isBold: true,
                  fontSize: 20,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 100),
                child: PrimaryButton(
                  text: "Spy",
                  press: () => {},
                  isBold: true,
                  fontSize: 20,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 100),
                child: PrimaryButton(
                  text: "Notifs",
                  press: () => {},
                  isBold: true,
                  fontSize: 20,
                ),
              )
            ],
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
