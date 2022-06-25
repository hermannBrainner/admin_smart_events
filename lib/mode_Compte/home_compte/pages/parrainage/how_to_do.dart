import 'package:flutter/material.dart';

import '/mode_Compte/_models/user_app.dart';
import '/mode_Compte/dispositions/components/plan_table/hero_dialog_route.dart';
import '/outils/constantes/colors.dart';
import '/outils/size_configs.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/primary_bouton.dart';
import 'new.dart';

HowToDo(
  BuildContext context,
  UserApp userApp,
) {
  return SingleChildScrollView(
    child: Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Container(
          width: SizeConfig.safeBlockHorizontal * 50,
          child: PrimaryButton(
              isBold: true,
              text: "Parrainer",
              press: () {
                Navigator.of(context).push(HeroDialogRoute(
                    isDismissible: true,
                    builder: (context) {
                      return NewParrainage(
                        userApp: userApp,
                      );
                    }));
              }),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Text(
              "Comment ca marche ? ",
              style: TextStyle(fontSize: 30),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              nroWidgt(context, "1"),
              SizedBox(
                width: 5,
              ),
              Expanded(
                  child: Text.rich(
                TextSpan(
                    text: 'Vous invitez votre filleul ',
                    style: ThemeElements(context: context).styleText(
                        color: ThemeElements(context: context).whichBlue,
                        fontSize: 20),
                    children: <InlineSpan>[
                      TextSpan(
                          text: 'en cliquant sur « Parrainer ».',
                          style: ThemeElements(context: context)
                              .styleText(fontSize: 20))
                    ]),
                maxLines: 4,
              ))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              nroWidgt(context, "2"),
              SizedBox(
                width: 5,
              ),
              Expanded(
                  child: Text.rich(
                TextSpan(
                    text: 'Votre filleul cree son compte Smart Events ',
                    style: ThemeElements(context: context).styleText(
                        color: ThemeElements(context: context).whichBlue,
                        fontSize: 20),
                    children: <InlineSpan>[
                      TextSpan(
                          text:
                              'avec la même adresse e-mail que celle que vous aurez renseignée lors de son invitation.',
                          style: ThemeElements(context: context)
                              .styleText(fontSize: 20))
                    ]),
                maxLines: 6,
              ))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              nroWidgt(context, "3"),
              SizedBox(
                width: 5,
              ),
              Expanded(
                  child: Text.rich(
                TextSpan(
                    text: 'Votre filleul reçoit une réduction de 5 euros ',
                    style: ThemeElements(context: context).styleText(
                        color: ThemeElements(context: context).whichBlue,
                        fontSize: 20),
                    children: <InlineSpan>[
                      TextSpan(
                          text:
                              'au moment du paiement pour sa première cérémonie ',
                          style: ThemeElements(context: context)
                              .styleText(fontSize: 20))
                    ]),
                maxLines: 6,
              ))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              nroWidgt(context, "4"),
              SizedBox(
                width: 5,
              ),
              Expanded(
                  child: Text.rich(
                TextSpan(
                    text: 'Vous recevez une prime de 5 euros ',
                    style: ThemeElements(context: context).styleText(
                        color: ThemeElements(context: context).whichBlue,
                        fontSize: 20),
                    children: <InlineSpan>[
                      TextSpan(
                          text: 'que vous pouvez retirer à tout moment.',
                          style: ThemeElements(context: context)
                              .styleText(fontSize: 20))
                    ]),
                maxLines: 4,
              ))
            ],
          ),
        ),
      ],
    ),
  );
}

Widget nroWidgt(BuildContext context, String nro, {double radius = 20}) {
  return Container(
    width: radius * 2,
    height: radius * 2,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius * 2),
        border: Border.all(
            color: ThemeElements(context: context).whichBlue, width: 1)),
    child: CircleAvatar(
      radius: radius,
      backgroundColor: Colors.yellow,
      child: Text(
        nro,
        style: ThemeElements(context: context).styleText(
            color: dBlack, fontWeight: FontWeight.bold, fontSize: radius * 0.8),
      ),
    ),
  );
}
