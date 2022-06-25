import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/outils/extensions/string.dart';
import '/outils/size_configs.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/primary_bouton.dart';
import '/providers/theme/strings.dart';
import 'modal_boutons.dart';

btnImport(BuildContext context, Function switchDisplay, Function startLoading) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 15.0),
    child: Card(
        //  color: const Color.fromRGBO(240, 255, 255, .9),
        shape: const RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        ),
        elevation: 3,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          height: SizeConfig.safeBlockVertical * 10,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: SizeConfig.blockSizeVertical * 1,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.blockSizeHorizontal * 3),
                child: PrimaryButton(
                    text: Strings.importTitre,
                    isBold: true,
                    press: () {
                      modalBtnImpt(startLoading, context, true);
                    }),
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 1,
              ),
            ],
          ),
        )),
  );
}

btnDownload(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 15.0),
    child: Card(
        //  color: const Color.fromRGBO(240, 255, 255, .9),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        elevation: 3,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          height: SizeConfig.safeBlockVertical * 20,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.download_outlined,
                    color: Colors.redAccent,
                    size: SizeConfig.blockSizeVertical * 5,
                  ),
                  //  adherent.avatar(),
                  SizedBox(width: SizeConfig.blockSizeHorizontal * 5),
                  Expanded(
                    child: Text(
                      Strings.importDowloadDetails,
                      style: ThemeElements(context: context).styleText(
                          fontSize: SizeConfig.safeBlockVertical * 2,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                      maxLines: 4,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 2,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.blockSizeHorizontal * 10),
                child: PrimaryButton(
                    rayonBord: SizeConfig.blockSizeVertical * 2,
                    text: Strings.importDownloadTemplate,
                    press: () {
                      modalBtnDwld(context);
                    }),
              )
            ],
          ),
        )),
  );
}

btnSwitchReplace(BuildContext context, bool isOn, Function switchReplace) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 15.0),
    child: Card(
        //   color: Color.fromRGBO(240, 255, 255, .9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        elevation: 3,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal * 3.2,
              vertical: SizeConfig.blockSizeHorizontal * 1.5),
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal * 0.8,
              vertical: SizeConfig.blockSizeVertical * 1.9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    Strings.importNew.upperDebut(),
                    style: ThemeElements(context: context).styleText(
                      fontWeight: FontWeight.w600,
                      fontSize: SizeConfig.blockSizeHorizontal * 6,
                    ),
                  ),
                  Text(
                    Strings.importNewDetails,
                    style: ThemeElements(context: context).styleText(
                      fontSize: SizeConfig.blockSizeHorizontal * 4,
                      fontWeight: FontWeight.w300,
                    ),
                  )
                ],
              ),
              CupertinoSwitch(
                  trackColor: Colors.redAccent,
                  value: isOn,
                  onChanged: (_) {
                    switchReplace();
                  })
            ],
          ),
        )),
  );
}
