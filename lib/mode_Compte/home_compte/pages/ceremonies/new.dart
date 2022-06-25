import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/auth/splashscreen.dart';
import '/mode_Compte/_controllers/ceremonie.dart';
import '/mode_Compte/_models/ceremonie.dart';
import '/mode_Compte/_models/identifiants.dart';
import '/mode_Compte/_models/user_app.dart';
import '/outils/components/custom_radio_button.dart';
import '/outils/extensions/string.dart';
import '/outils/fonctions/fonctions.dart';
import '/outils/size_configs.dart';
import '/outils/widgets/main.dart';
import '/providers/theme/bouton_retour.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/primary_loading_bouton.dart';
import '/providers/theme/strings.dart';
import '../../common.dart';

class NewCeremonie extends StatefulWidget {
  static const String routeName = "/new_Ceremonie";

  @override
  _NewCeremonieState createState() => _NewCeremonieState();
}

class _NewCeremonieState extends State<NewCeremonie> {
  final RoundedLoadingButtonController btnCtrl =
      RoundedLoadingButtonController();
  bool bVisible = true;

  IconData iconData = Icons.visibility;
  int valueDispo = 1;
  final _cleFormulaire = GlobalKey<FormState>();
  TextEditingController urlCtrl = TextEditingController();

  late Ceremonie newCeremonie;
  DateTime? jourCeremonie;
  TimeOfDay? heureDebut;
  late String titreCeremonie;
  late String usernameCeremonie;
  String? mdpCeremonie;
  late String idAdmin;
  late double nbreBillets;

  String? lieuCeremonie;

  bool? isTablesNeed;

  bool? isZonesNeed;

  String? urlPrefix;

  late bool isSwitched = false;

  @override
  void initState() {
    super.initState();
  }

  String hintTexts(ElementDetails element) {
    switch (element) {
      case ElementDetails.Jour:
        return jourCeremonie == null
            ? "Entrez la date"
            : DateFormat('d/M/y').format(jourCeremonie!).toStringDate();
      case ElementDetails.Heure:
        return heureDebut == null
            ? "Entrez l'heure"
            : (forcerAvec0_devant(heureDebut!.hour.toString()) +
                ":" +
                forcerAvec0_devant(heureDebut!.minute.toString()));
      default:
        return "";
    }
  }

  onChange(ElementDetails element, dynamic val) {
    switch (element) {
      case ElementDetails.Titre:
        titreCeremonie = val;
        break;
      case ElementDetails.Nbre:
        if (isStringNumeric(val)) nbreBillets = double.parse(val);
        break;
      case ElementDetails.Lieu:
        lieuCeremonie = val;
        break;
    }
  }

  void editHourDebut() {
    showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((heure) {
      if (!isNullOrEmpty(heure) && !isNullOrEmpty(jourCeremonie)) {
        setState(() {
          heureDebut = heure!;
        });
      } else {
        setState(() {
          heureDebut = null;
        });
      }
    });
  }

  void editDate() {
    showDatePicker(
            context: context,
            locale: const Locale("fr", "FR"),
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            //.subtract(Duration(days: 300)),
            lastDate: DateTime(2030))
        .then((newDate) {
      if (newDate != null) {
        setState(() {
          jourCeremonie = newDate;
        });
      } else {
        setState(() {
          jourCeremonie = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String idUser = (Provider.of<UserPhone>(context)).id;
    return Scaffold(
        appBar: AppBar(
            leading: BoutonRetour(press: () {
              Navigator.pop(context);
            }),
            title: Text("Nouvelle ceremonie")),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Form(
              key: _cleFormulaire,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  wTritre(Strings.paramsDetails, context),
                  Card(
                    shape: angleArrondi(15),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 15),
                      child: Column(
                        children: [
                          getInfoBulle(
                            Strings.paramsDetails,
                            context,
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                              style: ThemeElements(context: context)
                                  .styleTextFieldTheme,
                              maxLines: 1,
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: ThemeElements(context: context)
                                              .whichBlue,
                                          width: 2.0)),
                                  labelStyle: TextStyle(
                                      color: ThemeElements(context: context)
                                          .whichBlue),
                                  hintStyle: TextStyle(
                                      color: ThemeElements(
                                              context: context,
                                              mode: ColorMode.envers)
                                          .themeColor),
                                  labelText: "Titre cérémonie",
                                  hintText: "Quelle est le titre ? ",
                                  border: OutlineInputBorder()),
                              onChanged: (val) => titreCeremonie = val,
                              validator: (val) =>
                                  val!.isEmpty ? "Entrez le titre" : null),
                          SizedBox(height: 10.0),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: InkWell(
                                    onTap: editDate,
                                    child: IgnorePointer(
                                      child: TextFormField(
                                        style: ThemeElements(context: context)
                                            .styleTextFieldTheme,
                                        maxLines: 1,

                                        decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: ThemeElements(
                                                            context: context)
                                                        .whichBlue,
                                                    width: 2.0)),
                                            labelStyle: TextStyle(
                                                color: ThemeElements(
                                                        context: context)
                                                    .whichBlue),
                                            hintStyle: TextStyle(
                                                color: ThemeElements(
                                                        context: context,
                                                        mode: ColorMode.envers)
                                                    .themeColor),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                            hintText: jourCeremonie == null
                                                ? "Entrez la date"
                                                : DateFormat('d/M/y')
                                                    .format(jourCeremonie!)
                                                    .toStringDate(),
                                            labelText: "Date debut",
                                            // helperText: "helper",
                                            border: OutlineInputBorder()),
                                        //  onChanged:(val) => nbreBillets = double.parse(val) , validator: (val) => ! isNumeric(val)  ? "Entrez le nombre de billets" : null
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Expanded(
                                  child: InkWell(
                                    onTap: editHourDebut,
                                    child: IgnorePointer(
                                      child: TextFormField(
                                        style: ThemeElements(context: context)
                                            .styleTextFieldTheme,
                                        maxLines: 1,

                                        decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: ThemeElements(
                                                            context: context)
                                                        .whichBlue,
                                                    width: 2.0)),
                                            labelStyle: TextStyle(
                                                color:
                                                    ThemeElements(context: context)
                                                        .whichBlue),
                                            hintStyle: TextStyle(
                                                color: ThemeElements(
                                                        context: context,
                                                        mode: ColorMode.envers)
                                                    .themeColor),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.always,
                                            hintText: heureDebut == null
                                                ? "Entrez l'heure"
                                                : (forcerAvec0_devant(
                                                        heureDebut!.hour
                                                            .toString()) +
                                                    ":" +
                                                    forcerAvec0_devant(
                                                        heureDebut!.minute.toString())),
                                            labelText: "Heure début",
                                            // helperText: "helper",
                                            border: OutlineInputBorder()),
                                        //  onChanged:(val) => nbreBillets = double.parse(val) , validator: (val) => ! isNumeric(val)  ? "Entrez le nombre de billets" : null
                                      ),
                                    ),
                                  ),
                                )
                              ]),
                          SizedBox(height: 10.0),
                          TextFormField(
                              style: ThemeElements(context: context)
                                  .styleTextFieldTheme,
                              maxLines: 1,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: ThemeElements(context: context)
                                              .whichBlue,
                                          width: 2.0)),
                                  labelStyle: TextStyle(
                                      color: ThemeElements(context: context)
                                          .whichBlue),
                                  hintStyle: TextStyle(
                                      color: ThemeElements(
                                              context: context,
                                              mode: ColorMode.envers)
                                          .themeColor),
                                  labelText: "Nombre de billets",
                                  border: OutlineInputBorder()),
                              onChanged: (val) {
                                if (isStringNumeric(val))
                                  nbreBillets = double.parse(val);
                              },
                              validator: (val) => !isStringNumeric(val!)
                                  ? "Entrez le nombre de billets"
                                  : null),
                          SizedBox(height: 10.0),
                          TextFormField(
                              style: ThemeElements(context: context)
                                  .styleTextFieldTheme,
                              maxLines: 1,
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: ThemeElements(context: context)
                                              .whichBlue,
                                          width: 2.0)),
                                  labelStyle: TextStyle(
                                      color: ThemeElements(context: context)
                                          .whichBlue),
                                  hintStyle: TextStyle(
                                      color: ThemeElements(
                                              context: context,
                                              mode: ColorMode.envers)
                                          .themeColor),
                                  labelText: "Lieu",
                                  border: OutlineInputBorder()),
                              onChanged: (val) => lieuCeremonie = val,
                              validator: (val) => val!.isEmpty
                                  ? "Entrez le lieu de la cérémonie"
                                  : null),
                        ],
                      ),
                    ),
                  ),
                  wTritre(Strings.paramsConnexion, context),
                  Card(
                    shape: angleArrondi(15),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 15),
                      child: Column(
                        children: [
                          getInfoBulle(Strings.paramsConnexion, context),
                          SizedBox(height: 20.0),
                          TextFormField(
                              style: ThemeElements(context: context)
                                  .styleTextFieldTheme,
                              maxLines: 1,
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: ThemeElements(context: context)
                                              .whichBlue,
                                          width: 2.0)),
                                  labelStyle: TextStyle(
                                      color: ThemeElements(context: context)
                                          .whichBlue),
                                  hintStyle: TextStyle(
                                      color: ThemeElements(
                                              context: context,
                                              mode: ColorMode.envers)
                                          .themeColor),
                                  labelText: "Username",
                                  border: OutlineInputBorder()),
                              onChanged: (val) => usernameCeremonie = val,
                              validator: (val) =>
                                  val!.isEmpty ? "Entrez le UserName" : null),
                          SizedBox(height: 10.0),
                          TextFormField(
                              style: ThemeElements(context: context)
                                  .styleTextFieldTheme,
                              obscureText: bVisible,
                              enableSuggestions: false,
                              autocorrect: false,
                              maxLines: 1,
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: ThemeElements(context: context)
                                              .whichBlue,
                                          width: 2.0)),
                                  labelStyle: TextStyle(
                                      color: ThemeElements(context: context)
                                          .whichBlue),
                                  hintStyle: TextStyle(
                                      color: ThemeElements(
                                              context: context,
                                              mode: ColorMode.envers)
                                          .themeColor),
                                  labelText: "Mot de passe",
                                  border: OutlineInputBorder(),
                                  suffix: InkWell(
                                    onTap: switchMdpVue,
                                    child: Icon(iconData),
                                  )),
                              onChanged: (val) => mdpCeremonie = (val).trim(),
                              validator: (val) => val!.isEmpty
                                  ? "Entrez le mot de passe"
                                  : null),
                          SizedBox(height: 10.0),
                          TextFormField(
                              style: ThemeElements(context: context)
                                  .styleTextFieldTheme,
                              obscureText: bVisible,
                              enableSuggestions: false,
                              autocorrect: false,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ThemeElements(context: context)
                                            .whichBlue,
                                        width: 2.0)),
                                labelStyle: TextStyle(
                                    color: ThemeElements(context: context)
                                        .whichBlue),
                                hintStyle: TextStyle(
                                    color: ThemeElements(
                                            context: context,
                                            mode: ColorMode.envers)
                                        .themeColor),
                                labelText: "Confirmation",
                                border: OutlineInputBorder(),
                              ),
                              validator: (val) {
                                val = val ?? "";
                                return val.trim() != mdpCeremonie
                                    ? "Les mots de passe ne sont pas identiques"
                                    : null;
                              }),
                          SizedBox(height: 10.0),
                        ],
                      ),
                    ),
                  ),
                  wTritre(Strings.paramsDispositions, context),
                  Card(
                    shape: angleArrondi(15),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 15),
                      child: Column(
                        children: [
                          getInfoBulle(Strings.paramsDispositions, context),
                          SizedBox(height: 20.0),
                          Column(
                            children: [
                              MyRadioListTile<int>(
                                value: 1,
                                groupValue: valueDispo,
                                leading: 'I ',
                                title: Text(Strings.dispoMax,
                                    style: TextStyle(
                                        color: ThemeElements(
                                                context: context,
                                                mode: ColorMode.envers)
                                            .themeColor)),
                                onChanged: (value) {
                                  setState(() {
                                    valueDispo = value;
                                    isZonesNeed = true;
                                    isTablesNeed = true;
                                  });
                                },
                              ),
                              MyRadioListTile<int>(
                                value: 2,
                                groupValue: valueDispo,
                                leading: 'II',
                                title: Text(Strings.dispoMoyen,
                                    style: TextStyle(
                                        color: ThemeElements(
                                                context: context,
                                                mode: ColorMode.envers)
                                            .themeColor)),
                                onChanged: (value) {
                                  setState(() {
                                    valueDispo = value;
                                    isZonesNeed = false;
                                    isTablesNeed = true;
                                  });
                                },
                              ),
                              MyRadioListTile<int>(
                                value: 3,
                                groupValue: valueDispo,
                                leading: 'III',
                                title: Text(Strings.dispoMin,
                                    style: TextStyle(
                                        color: ThemeElements(
                                                context: context,
                                                mode: ColorMode.envers)
                                            .themeColor)),
                                onChanged: (value) {
                                  setState(() {
                                    valueDispo = value;
                                    isZonesNeed = false;
                                    isTablesNeed = false;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  wTritre(Strings.paramsQrCodes, context),
                  Card(
                    shape: angleArrondi(15),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 15),
                      child: Column(
                        children: [
                          getInfoBulle(Strings.paramsQrCodes, context),
                          SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  width: SizeConfig.safeBlockHorizontal * 60,
                                  child: Text(
                                      "Avez-vous un lien web à inserer dans le Qr Code ? ",
                                      maxLines: 3,
                                      softWrap: true,
                                      style: TextStyle(
                                          color: ThemeElements(
                                                  context: context,
                                                  mode: ColorMode.envers)
                                              .themeColor))),
                              Transform.scale(
                                scale: 2.0,
                                child: Switch(
                                  // splashRadius: 50,
                                  value: isSwitched,
                                  onChanged: (value) {
                                    setState(() {
                                      isSwitched = value;
                                      urlCtrl.clear();
                                      urlPrefix = null;
                                    });
                                  },
                                  activeTrackColor: Colors.lightGreenAccent,
                                  activeColor: Colors.green,
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: SizeConfig.safeBlockVertical * 3),
                          Visibility(
                            visible: isSwitched,
                            child: TextFormField(
                                style: ThemeElements(context: context)
                                    .styleTextFieldTheme,
                                controller: urlCtrl,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: ThemeElements(context: context)
                                              .whichBlue,
                                          width: 2.0)),
                                  labelStyle: TextStyle(
                                      color: ThemeElements(context: context)
                                          .whichBlue),
                                  hintStyle: TextStyle(
                                      color: ThemeElements(
                                              context: context,
                                              mode: ColorMode.envers)
                                          .themeColor),
                                  hintText: Strings.exempleUrl,
                                  labelText: "Lien",
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    urlPrefix = toTrimAndCase(val);
                                  });
                                },
                                // validator: (val) => ! isURL(val)  ? "Mauvais Url" : null ),
                                validator: (val) =>
                                    !isUrlValid(val!) ? "Mauvais Url" : null),
                          ),
                          SizedBox(height: SizeConfig.safeBlockVertical * 3),
                          Visibility(
                              visible: isSwitched,
                              child: Text(
                                "Exemple : " +
                                    '\n' +
                                    (isNullOrEmpty(urlPrefix)
                                        ? Strings.exempleUrl
                                        : urlPrefix! + "/code/5207917380"),
                                maxLines: 3,
                                softWrap: true,
                                style: TextStyle(
                                    color: ThemeElements(
                                            context: context,
                                            mode: ColorMode.envers)
                                        .themeColor),
                              )),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.safeBlockVertical * 5),
                  Card(
                    shape: angleArrondi(15),
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          vertical: SizeConfig.safeBlockVertical * 6,
                          horizontal: 20.0),
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.safeBlockVertical * 1,
                          horizontal: 30.0),
                      child: PrimaryLoadingButton(
                          text: Strings.valider,
                          btnCtrl: btnCtrl,
                          press: () async {
                            btnCtrl.start();

                            if (_cleFormulaire.currentState!.validate() &&
                                !isNullOrEmpty(jourCeremonie) &&
                                !isNullOrEmpty(heureDebut)) {
                              bool identifiantsExists =
                                  await IdentifiantEvent.exists(
                                      usernameCeremonie);

                              if (identifiantsExists) {
                                showFlushbar(context, false, "",
                                    "Un event avec ce Username existe déjà");
                              } else {
                                if (valueDispo == 1) {
                                  isZonesNeed = isTablesNeed = true;
                                }
                                String id = await CeremonieCtrl().makeId();

                                Ceremonie c = Ceremonie(
                                  id: id,
                                  dateCeremonie: Timestamp.fromDate(
                                      new DateTime(
                                          jourCeremonie!.year,
                                          jourCeremonie!.month,
                                          jourCeremonie!.day,
                                          heureDebut!.hour,
                                          heureDebut!.minute)),
                                  nbreBillets: nbreBillets,
                                  idAdmin: idUser,
                                  mdp: toTrimAndCase(mdpCeremonie),
                                  username: toTrimAndCase(usernameCeremonie),
                                  lieuCeremonie: lieuCeremonie!,
                                  titreCeremonie: titreCeremonie,
                                  idsBillets: [],
                                  idsTables: [],
                                  idsZones: [],
                                  qrCodesDispo: [],
                                  urlPhoto_Profil: null,
                                  withTables: isTablesNeed!,
                                  withZones: isZonesNeed!,
                                  urlPrefix: urlPrefix,
                                );

                                await c.creation(context);
                                await c.addDefaultsValues();

                                btnCtrl.success();
                                Navigator.pushReplacementNamed(
                                    context, SplashScreen.routeName);
                              }
                            } else {
                              //  btnCtrl.error();

                              if (isNullOrEmpty(jourCeremonie) ||
                                  isNullOrEmpty(heureDebut)) {
                                showFlushbar(
                                    context,
                                    false,
                                    "Nouvel Event",
                                    (isNullOrEmpty(jourCeremonie)
                                        ? "- Rentrez la date de la ceremonie "
                                        : " Rentrez une heure pour la cerémonie "));
                              }
                            }

                            btnCtrl.stop();
                          }),
                    ),
                  ),
                  SizedBox(height: SizeConfig.safeBlockVertical * 5),
                ],
              ),
            ),
          ),
        ));
  }

  void switchMdpVue() {
    setState(() {
      bVisible = !bVisible;
      iconData = !bVisible ? Icons.visibility_off : Icons.visibility;
    });
  }
}
