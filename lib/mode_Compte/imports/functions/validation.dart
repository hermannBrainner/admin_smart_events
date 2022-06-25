import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/mode_Compte/imports/pages/good_import.dart';
import '/mode_Compte/imports/pages/overload_import.dart';
import '/outils/size_configs.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/primary_box_decoration.dart';
import '../pages/bad_import.dart';

class importValidation extends StatelessWidget {
  final bool wantReplace;
  final int nbreImport;
  final Function startLoading;
  final BuildContext context;

  importValidation(
      this.wantReplace, this.nbreImport, this.startLoading, this.context);

  CeremonieProvider get provider {
    return context.read<CeremonieProvider>();
  }

  bool get isPossile {
    return capacity >= nbreImport;
  }

  int get capacity {
    if (wantReplace) {
      return provider.ceremonie!.nbreBillets.toInt();
    }
    return provider.ceremonie!.nbreBillets.toInt() - provider.billetsInv.length;
  }

  Widget get carte {
    if (nbreImport < 1)
      return BadImport();
    else if (isPossile)
      return GoodImport(
          nbreBillets: nbreImport,
          startLoading: startLoading,
          provider: provider);
    else
      return OverloadImport(
          nbreBillets: nbreImport,
          startLoading: startLoading,
          provider: provider,
          nbreMaxPossible: capacity);
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
              child: carte),
        ],
      ),
    );
  }
}
