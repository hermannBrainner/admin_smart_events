import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/outils/fonctions/fonctions.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/strings.dart';
import '../../messagerie/open_button.dart';
import '../components/delete_tile.dart';

class PageModifAutres extends StatefulWidget {
  @override
  _PageModifAutresState createState() => _PageModifAutresState();
}

class _PageModifAutresState extends State<PageModifAutres> {
  bool displayValidationReset = false;

  bool isConfirmed = false;

  switchDisplayValidReset() {
    setState(() {
      displayValidationReset = !displayValidationReset;
    });
  }

  checkConfimation(String? value) {
    setState(() {
      if (isNullOrEmpty(value)) {
        isConfirmed = false;
      } else {
        isConfirmed = (value!.trim() == Strings.jeConfirme);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CeremonieProvider>(builder: (context, provider, child) {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            deleteTile(
              context: context,
              disPlayValidation: displayValidationReset,
              switchFct: switchDisplayValidReset,
              checkConfimation: checkConfimation,
              isConfirmationGood: isConfirmed,
              provider: provider,
            ),
            openMessagerie(context),
          ],
        ),
      );
    });
  }
}
