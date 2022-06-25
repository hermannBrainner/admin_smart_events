import 'package:flutter/material.dart';

import '/outils/size_configs.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/strings.dart';

importBillet(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 15.0),
    child: Card(
        color: const Color.fromRGBO(240, 255, 255, .9),
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(SizeConfig.blockSizeHorizontal * 80, 40),
                    primary: Colors.redAccent),
                onPressed: () {},
                child: Text(Strings.importDownloadTemplate),
              )
            ],
          ),
        )),
  );
}
