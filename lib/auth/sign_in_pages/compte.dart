import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/outils/constantes/colors.dart';
import '/outils/constantes/strings.dart';
import '/outils/fonctions/dates.dart';
import '/outils/size_configs.dart';
import '/outils/widgets/main.dart';

resetMdp(BuildContext context, {required String inMail}) {
  RoundedLoadingButtonController btnPosCtrl = RoundedLoadingButtonController();

  showCupertinoModalBottomSheet(
    expand: false,
    context: context,
    backgroundColor: dWhite,
    builder: (context) {
      return StatefulBuilder(builder: (BuildContext contextModal,
          StateSetter setState /*You can rename this!*/) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 50, horizontal: 10),
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            height: SizeConfig.safeBlockVertical * 40,
            color: dWhite,
            child: Material(
              color: dWhite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Mot de passe oublié",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                        fontSize: SizeConfig.safeBlockVertical * 3),
                  ),
                  Text(
                    inMail,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        decoration: TextDecoration.none,
                        fontSize: SizeConfig.safeBlockVertical * 2),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RoundedLoadingButton(
                        child: Text("Réinitialiser"),
                        color: Colors.green,
                        controller: btnPosCtrl,
                        borderRadius: SizeConfig.safeBlockHorizontal * 3,
                        successColor: Colors.lightGreenAccent,
                        width: SizeConfig.safeBlockHorizontal * 40,
                        elevation: SizeConfig.safeBlockHorizontal * 2,
                        height: SizeConfig.safeBlockVertical * 7,
                        onPressed: () async {
                          final nbreSecondes = 7;

                          String? errMsge;
                          btnPosCtrl.start();

                          try {
                            await FirebaseAuth.instance
                                .sendPasswordResetEmail(email: inMail);
                          } on FirebaseAuthException catch (e) {
                            errMsge = e.message;
                          }

                          if (errMsge != null) {
                            showFlushbar(context, false, "", errMsge,
                                seconds: nbreSecondes,
                                position: FlushbarPosition.TOP);
                          } else {
                            showFlushbar(
                                context,
                                true,
                                "",
                                "Un email vous a été envoyé." +
                                    newLine +
                                    "Veuillez consulter votre boîte email et vos spams",
                                seconds: nbreSecondes,
                                position: FlushbarPosition.TOP);
                          }

                          await wait(nbreSeconde: nbreSecondes);

                          Navigator.pop(context);

                          btnPosCtrl.stop();
                        },
                      ),
                    ],
                  ),
                  //   Padding()
                ],
              ),
            ),
          ),
        );
      });
    },
  );
}
