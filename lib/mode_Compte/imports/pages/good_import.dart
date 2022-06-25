import 'package:flutter/material.dart';

import '/outils/size_configs.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/primary_bouton.dart';
import '/providers/theme/strings.dart';

class GoodImport extends StatelessWidget {
  final int nbreBillets;
  final Function startLoading;
  final CeremonieProvider provider;

  const GoodImport(
      {Key? key,
      required this.nbreBillets,
      required this.startLoading,
      required this.provider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Text(
            nbreBillets > 0
                ? "$nbreBillets Billets à importer"
                : " Aucun Billet à importer",
            style: ThemeElements(context: context).styleText(
              fontWeight: FontWeight.bold,
              fontSize: SizeConfig.blockSizeVertical * 3,
            ),
          ),
        ),
        SizedBox(height: SizeConfig.blockSizeVertical * 3),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: SizeConfig.blockSizeVertical * 3,
              horizontal: SizeConfig.blockSizeHorizontal * 10),
          child: PrimaryButton(
              isBold: true,
              rayonBord: 10,
              text: "Lancer l'import",
              press: () {
                startLoading(true, provider);
              }),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Colors.redAccent),
          onPressed: () {
            startLoading(false, provider);
          },
          child: Text(Strings.cancel),
        ),
      ],
    );
  }
}
