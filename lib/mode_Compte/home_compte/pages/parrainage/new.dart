import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/mode_Compte/_models/filleul.dart';
import '/mode_Compte/_models/user_app.dart';
import '/mode_Compte/dispositions/components/plan_table/custom_rect_tween.dart';
import '/mode_Compte/dispositions/components/search_bar.dart';
import '/outils/constantes/collections.dart';
import '/outils/extensions/string.dart';
import '/outils/fonctions/fonctions.dart';
import '/outils/widgets/main.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/primary_box_decoration.dart';
import '/providers/theme/primary_loading_bouton.dart';
import '/providers/theme/strings.dart';

const String _heroAddTodo = 'newFilleul';

class NewParrainage extends StatefulWidget {
  final UserApp userApp;
  const NewParrainage({
    Key? key,
    required this.userApp,
  }) : super(key: key);

  @override
  State<NewParrainage> createState() => _NewParrainageState();
}

class _NewParrainageState extends State<NewParrainage> {
  final _cleFormulaire = GlobalKey<FormState>();
  TextEditingController ctrlPrenom = TextEditingController();
  TextEditingController ctrlEmail = TextEditingController();

  bool isCheck = false;
  final RoundedLoadingButtonController btnCtrl =
      RoundedLoadingButtonController();

  Widget titre(context) {
    return CustomPaint(
        painter: toileFond(
            hauteur: 100,
            context: context,
            couleur: ThemeElements(context: context).whichBlue),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: Center(
              child: Text(
            "Nouveau filleul",
            style: ThemeElements(context: context).styleText(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          )),
        ));
  }

  InputDecoration inputDecoration(String label) {
    return InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: ThemeElements(context: context).whichBlue, width: 2.0)),
        labelStyle: TextStyle(color: ThemeElements(context: context).whichBlue),
        hintStyle: TextStyle(
            color: ThemeElements(context: context, mode: ColorMode.envers)
                .themeColor),
        labelText: label,
        border: OutlineInputBorder());
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Hero(
          tag: _heroAddTodo,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin!, end: end!);
          },
          child: Material(
            color: ThemeElements(context: context).themeColorSecondary,
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            )),
            child: Container(
              decoration: BoxDecorationPrimary(context,
                  topRigth: 0, topLeft: 0, bottomRigth: 32, bottomLeft: 32),
              width: 600,
              height: 500,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  titre(context),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        child: Form(
                          key: _cleFormulaire,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Card(
                                shape: angleArrondi(15),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 15),
                                  child: TextFormField(
                                      controller: ctrlEmail,
                                      style: ThemeElements(context: context)
                                          .styleTextFieldTheme,
                                      maxLines: 1,
                                      decoration:
                                          inputDecoration("Adresse e-mail"),
                                      validator: (val) {
                                        return ctrlEmail.text.isValidEmail()
                                            ? null
                                            : "Email invalide";
                                      }),
                                ),
                              ),
                              Card(
                                shape: angleArrondi(15),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 15),
                                  child: TextFormField(
                                      controller: ctrlPrenom,
                                      style: ThemeElements(context: context)
                                          .styleTextFieldTheme,
                                      maxLines: 1,
                                      decoration: inputDecoration("Prénom"),
                                      validator: (val) =>
                                          ctrlPrenom.text.isEmpty
                                              ? "Entrez le prenom"
                                              : null),
                                ),
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                      value: isCheck,
                                      onChanged: (value) {
                                        setState(() {
                                          isCheck = !isCheck;
                                        });
                                      }),
                                  Expanded(
                                      child: Text(
                                    "J’atteste avoir l'accord de mon filleul pour être contacté par email dans le cadre de cette opération",
                                    maxLines: 2,
                                    style: TextStyle(fontSize: 10),
                                  )),
                                ],
                              ),
                              PrimaryLoadingButton(
                                color: (isCheck) ? null : Colors.grey,
                                btnCtrl: btnCtrl,
                                press: () async {
                                  if (isCheck &&
                                      _cleFormulaire.currentState!.validate()) {
                                    if (!(await UserApp.exists(
                                            ctrlEmail.text)) ||
                                        (await Filleul.exists(
                                            ctrlEmail.text))) {
                                      Filleul filleul = Filleul(
                                        prenom: ctrlPrenom.text,
                                        email: ctrlEmail.text.toLowerAndTrim(),
                                        id: await getNewID(
                                            nomCollectionFilleuls),
                                        primeDebloquee: false,
                                        primeRecue: false,
                                        idParrain: widget.userApp.id,
                                      );

                                      await filleul.save();

                                      widget.userApp.idsFilleuls
                                          .add(filleul.id);

                                      await widget.userApp.save(context);

                                      Navigator.pop(context);
                                    } else {
                                      showFlushbar(context, false, "",
                                          "Compte deja existant ou filleul deja enrole");
                                    }

                                    // Navigator.pop(context);
                                  }
                                  btnCtrl.stop();
                                },
                                text: Strings.valider,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
