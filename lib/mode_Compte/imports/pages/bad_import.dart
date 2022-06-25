import 'package:flutter/material.dart';

import '/outils/constantes/colors.dart';
import '/outils/size_configs.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/strings.dart';
import '../main.dart';

class BadImport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double tailleWifi = 100;
    double tailleCroix = 30;

    Widget logo() {
      return Stack(
        children: [
          Icon(
            Icons.cloud_upload,
            size: tailleWifi,
            color: Colors.grey,
          ),
          Positioned(
            bottom: 0,
            left: (tailleWifi - tailleCroix) / 2,
            child: Container(
              //  color: dWhite,
              height: tailleCroix,
              width: tailleCroix,
              decoration: BoxDecoration(
                color: dWhite,
                // border: Border.all(color: dWhite, width: 2),
                borderRadius: BorderRadius.all(
                    Radius.circular(tailleCroix / 2)), //  angleArrondi(15),
              ),
              child: Icon(
                Icons.close,
                size: tailleCroix,
                color: Colors.redAccent,
              ),
            ),
          )
        ],
      );
    }

    Widget bouton() {
      return ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, ImportsMainView.routeName);
          },
          child: Text("Reprendre"));
    }

    return Container(
      color: dWhite,
      padding: EdgeInsets.all(
        SizeConfig.blockSizeVertical * 3,
      ),
      child: Column(
        children: [
          logo(),
          Text(
            Strings.importBadTitre,
            style: ThemeElements(context: context).styleText(
                fontSize: SizeConfig.blockSizeVertical * 2.5,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 2.5,
          ),
          Text(
            Strings.importBadRecoTitre,
            textAlign: TextAlign.center,
            style: ThemeElements(context: context).styleText(
                fontSize: SizeConfig.blockSizeVertical * 2,
                fontWeight: FontWeight.normal,
                color: Colors.black54),
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 2.5,
          ),
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.black54,
              ),
              SizedBox(
                width: SizeConfig.blockSizeVertical * 1.5,
              ),
              Text(Strings.importBadRecoItem1)
            ],
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 2.5,
          ),
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.black54,
              ),
              SizedBox(
                width: SizeConfig.blockSizeVertical * 1.5,
              ),
              Text(Strings.importBadRecoItem2)
            ],
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 2.5,
          ),
          bouton()
        ],
      ),
    );
  }
}
