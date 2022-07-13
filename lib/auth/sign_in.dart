import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/main_modes/main.dart';
import '/outils/extensions/string.dart';
import '/outils/fonctions/fonctions.dart';
import '/outils/size_configs.dart';
import '/outils/widgets/main.dart';
import '/providers/theme/bouton_retour.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/primary_loading_bouton.dart';
import '/providers/theme/strings.dart';
import '/providers/user_app.dart';
import 'sign_in_pages/compte.dart';

class Connexion extends StatefulWidget {
  static String routeName = "/Login";

  @override
  _ConnexionState createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
  final RoundedLoadingButtonController btnCtrl =
      RoundedLoadingButtonController();

  final TextEditingController mdpCtrl = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mdpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _userEmail;
  String? _userMdp;

  final emailFieldCle = GlobalKey<FormFieldState>();
  final psswrdFieldCle = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _mdpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget _signInAccount() {
      return SingleChildScrollView(
          child: Padding(
              padding:
                  EdgeInsets.only(top: 100.0, left: 17, right: 23, bottom: 200),
              child: Card(
                color: ThemeElements(context: context).themeColorSecondary,
                shape: angleArrondi(15),
                child: Container(
                  // color: Colors.red,

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.safeBlockVertical * 2,
                            horizontal: 30.0),
                        child: Form(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment:
                                CrossAxisAlignment.center, //stretch,
                            children: <Widget>[
                              SizedBox(
                                  height: SizeConfig.safeBlockVertical * 5),
                              Center(
                                  child: Text("Se connecter à un compte",
                                      style: ThemeElements(context: context)
                                          .styleText(
                                              fontSize:
                                                  SizeConfig.safeBlockVertical *
                                                      2,
                                              fontWeight: FontWeight.bold))),
                              SizedBox(
                                  height: SizeConfig.safeBlockVertical * 5),
                              TextFormField(
                                  style: ThemeElements(context: context)
                                      .styleTextFieldTheme,
                                  key: emailFieldCle,
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                      //    fillColor: Colors.black,
                                      hintText: Strings.exampleMail,
                                      hintStyle: ThemeElements(context: context)
                                          .styleText(
                                              fontStyle: FontStyle.italic),
                                      labelStyle:
                                          ThemeElements(context: context)
                                              .styleText(
                                                  fontSize: SizeConfig
                                                          .safeBlockVertical *
                                                      2,
                                                  fontWeight: FontWeight.bold),
                                      labelText: "Email",
                                      border: OutlineInputBorder()),
                                  onChanged: (val) =>
                                      _userEmail = toTrimAndCase(val),
                                  validator: (val) =>
                                      toTrimAndCase(val).isValidEmail()
                                          ? null
                                          : "Entrez une adresse email valide"),
                              SizedBox(
                                  height: SizeConfig.blockSizeVertical * 2),
                              TextFormField(
                                  style: ThemeElements(context: context)
                                      .styleTextFieldTheme,
                                  key: psswrdFieldCle,
                                  controller: mdpCtrl,
                                  decoration: InputDecoration(

                                      //   hintText: Stri,
                                      hintStyle: ThemeElements(context: context)
                                          .styleText(
                                              fontStyle: FontStyle.italic),
                                      labelStyle:
                                          ThemeElements(context: context)
                                              .styleText(
                                                  fontSize: SizeConfig
                                                          .safeBlockVertical *
                                                      2,
                                                  fontWeight: FontWeight.bold),
                                      labelText: "Mot de passe",
                                      border: OutlineInputBorder()),
                                  onChanged: (val) => _userMdp = val.trim(),
                                  validator: (val) => !isNullOrEmpty(val)
                                      ? null
                                      : "Mot de passe vide"),
                              //  PrimaryButton(press: () {  },),
                              PrimaryLoadingButton(
                                rayonBord: 20,
                                padding: EdgeInsets.only(
                                    top: SizeConfig.safeBlockVertical * 5,
                                    bottom: SizeConfig.safeBlockVertical * 2),
                                text: 'Valider',
                                press: () async {
                                  String errTitre = "Connexion";
                                  String? errMsge;

                                  if (emailFieldCle.currentState!.validate() &&
                                      psswrdFieldCle.currentState!.validate()) {
                                    btnCtrl.start();

                                    try {
                                      UserCredential cred = await _auth
                                          .signInWithEmailAndPassword(
                                              email: _userEmail!,
                                              password: _userMdp!);
                                      if (cred.user != null) {
                                        bool isAdmin = await context
                                            .read<UserAppProvider>()
                                            .load(context);

                                        if (isAdmin) {
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              ListeModes.routeName,
                                              (Route<dynamic> route) => false);
                                        } else {
                                          await _auth.signOut();
                                          btnCtrl.error();
                                          errMsge = "Vous n'etes pas admin";
                                        }
                                      } else {
                                        btnCtrl.error();
                                        errMsge =
                                            "Aucun compte avec cette adresse";
                                      }
                                    } on FirebaseAuthException catch (e) {
                                      btnCtrl.error();
                                      if (e.code == Strings.pwdException) {
                                        errMsge = "Mot de passe invalide";
                                      } else {
                                        errMsge = e.code;
                                      }
                                    }
                                  }

                                  btnCtrl.stop();
                                  if (!isNullOrEmpty(errMsge)) {
                                    showFlushbar(
                                        context, false, errTitre, errMsge!);
                                  }
                                },
                                btnCtrl: btnCtrl,
                              ),

                              SizedBox(
                                  height: SizeConfig.blockSizeVertical * 1),
                              InkWell(
                                  onTap: () async {
                                    psswrdFieldCle.currentState!.reset();
                                    if (emailFieldCle.currentState!
                                        .validate()) {
                                      resetMdp(context, inMail: _userEmail!);
                                    }
                                  },
                                  child: Text(
                                    "Mot de passe oublié ?",
                                    style: ThemeElements(context: context)
                                        .styleText(
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.underline),
                                  )),
                              SizedBox(
                                  height: SizeConfig.blockSizeVertical * 4),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )));
    }

    SizeConfig().init(context);
    return Scaffold(
        appBar: AppBar(
          leading: BoutonRetour(
            press: () {
              Navigator.pop(context);
            },
          ),
          //  elevation: 2.0,
          title: const Text(Strings.signIn),
        ),
        body: _signInAccount());
  }
}
