import 'package:flutter/material.dart';

import '/outils/constantes/strings.dart';
import '/outils/size_configs.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/primary_bouton.dart';

class OverloadImport extends StatelessWidget {
  final int nbreBillets;
  final int nbreMaxPossible;
  final Function startLoading;
  final CeremonieProvider provider;

  const OverloadImport(
      {Key? key,
      required this.nbreBillets,
      required this.startLoading,
      required this.provider,
      required this.nbreMaxPossible})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Icon(
            Icons.warning_amber_outlined,
            size: SizeConfig.safeBlockHorizontal * 10,
            color: Colors.yellowAccent,
          ),
        ),
        SizedBox(height: SizeConfig.blockSizeVertical * 3),
        Center(
          child: Text(
            "$nbreBillets Billets Trouvés",
            style: ThemeElements(context: context).styleText(
              fontWeight: FontWeight.bold,
              fontSize: SizeConfig.blockSizeVertical * 3,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal * 8,
              vertical: SizeConfig.blockSizeVertical * 2),
          child: Center(
            child: Text(
              " Vous ne pouvez importer que $nbreMaxPossible billets." +
                  newLine +
                  newLine +
                  newLine +
                  "Veuillez changer les paramètres de votre cérémonie",
              textAlign: TextAlign.center,
              style: ThemeElements(context: context).styleText(
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.blockSizeVertical * 2,
              ),
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
              text: "Compris",
              press: () {
                startLoading(false, provider);
              }),
        ),
      ],
    );
  }
}
