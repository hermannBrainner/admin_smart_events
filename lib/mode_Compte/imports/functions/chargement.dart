import 'package:flutter/material.dart';

import '/outils/fonctions/fonctions.dart';
import '/outils/size_configs.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/primary_box_decoration.dart';
import '/providers/theme/strings.dart';

class importChargement extends StatelessWidget {
  final BuildContext context;
  final double prct;
  final String? nomEnCours;
  final bool isLoadingFini;

  const importChargement(
      this.context, this.prct, this.nomEnCours, this.isLoadingFini);

  Widget get indicator {
    return (isLoadingFini)
        ? const Center(
            child: Icon(
              Icons.check_circle,
              size: 80,
              color: Colors.lightGreenAccent,
            ),
          )
        : const Center(
            child: SizedBox(
              height: 50.0,
              width: 50.0,
              child: CircularProgressIndicator(
                value: null,
                strokeWidth: 7.0,
              ),
            ),
          );
  }

  Widget get textLoading {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Center(
        child: Text(
          prct == 0
              ? Strings.initialisation
              : (isLoadingFini
                  ? ""
                  : (prct >= 100 ? Strings.finalisation : Strings.chargement)),
          style: ThemeElements(context: context).styleText(fontSize: 30),
        ),
      ),
    );
  }

  Widget get pourcentage {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Center(
        child: Text(
          "${doubleToString(prct)} %",
          style: ThemeElements(context: context).styleText(fontSize: 30),
        ),
      ),
    );
  }

  Widget get nomInvite {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Center(
        child: Text(
          prct >= 100 ? "" : (nomEnCours ?? ""),
          style: ThemeElements(context: context).styleText(fontSize: 20),
        ),
      ),
    );
  }

  Widget get carte {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        indicator,
        nomInvite,
        pourcentage,
        textLoading,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecorationPrimary(context,
                topRigth: 10, topLeft: 10, bottomRigth: 10, bottomLeft: 10),
            width: SizeConfig.blockSizeHorizontal * 85,
            height: SizeConfig.blockSizeVertical * 50,
            alignment: AlignmentDirectional.center,
            child: carte,
          ),
        ],
      ),
    );
  }
}
