import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '/outils/constantes/colors.dart';
import '/outils/size_configs.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/strings.dart';
import 'tiles.dart';

modalBtnImpt(Function startLoading, BuildContext context, bool cleanAll) {
  return showCupertinoModalBottomSheet(
      context: context,
      backgroundColor: dWhite,
      builder: (BuildContext bc) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Material(
                    child: Container(
                  color: dWhiteLeger,
                  padding:
                      EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 6),
                  child: Consumer<CeremonieProvider>(
                    builder: (context, provider, child) {
                      return Wrap(
                        children: <Widget>[
                          tileImpt(startLoading, context, cleanAll,
                              extension: Strings.extensionXls),
                          tileImpt(startLoading, context, cleanAll,
                              extension: Strings.extensionCsv),
                        ],
                      );
                    },
                  ),
                )));
          },
        );
      });
}

modalBtnDwld(BuildContext context) {
  return showCupertinoModalBottomSheet(
      context: context,
      backgroundColor: dWhite,
      builder: (BuildContext bc) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Material(
                    child: Container(
                  color: dWhiteLeger,
                  padding:
                      EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 6),
                  child: Consumer<CeremonieProvider>(
                    builder: (context, provider, child) {
                      return Wrap(
                        children: <Widget>[
                          tileDwld(context, Strings.extensionXls),
                          tileDwld(context, Strings.extensionCsv),
                        ],
                      );
                    },
                  ),
                )));
          },
        );
      });
}
