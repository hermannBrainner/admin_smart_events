import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:validators/validators.dart';

import '/mode_Compte/_controllers/ceremonie.dart';
import '/mode_Compte/_models/ceremonie.dart';
import '/outils/constantes/colors.dart';
import '/outils/extensions/string.dart';
import '/outils/extensions/time.dart';
import '/outils/fonctions/fonctions.dart';
import '/outils/size_configs.dart';
import '/outils/widgets/main.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/bouton_retour.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/primary_box_decoration.dart';
import '/providers/theme/strings.dart';

class PageModifDetailsCeremonie extends StatefulWidget {
  @override
  _PageModifDetailsCeremonieState createState() =>
      _PageModifDetailsCeremonieState();
}

class _PageModifDetailsCeremonieState extends State<PageModifDetailsCeremonie> {
  RoundedLoadingButtonController btnPosCtrl = RoundedLoadingButtonController();
  String? sTitre;

  String? sLieu;

  String sNbreBillet = "";

  TimeOfDay? heureDebut;

  DateTime? jourCeremonie;

  var marge = EdgeInsets.symmetric(
      vertical: SizeConfig.safeBlockVertical * 2,
      horizontal: SizeConfig.safeBlockHorizontal * 2);

  void editDateCeremonie(Ceremonie ceremonie) {
    if (!isNullOrEmpty(jourCeremonie)) {
      ceremonie.dateCeremonie = Timestamp.fromDate(new DateTime(
        jourCeremonie!.year,
        jourCeremonie!.month,
        jourCeremonie!.day,
        ceremonie.dateCeremonie.toDate().hour,
        ceremonie.dateCeremonie.toDate().minute,
      ));
    }

    if (!isNullOrEmpty(heureDebut)) {
      ceremonie.dateCeremonie = Timestamp.fromDate(new DateTime(
          ceremonie.dateCeremonie.toDate().year,
          ceremonie.dateCeremonie.toDate().month,
          ceremonie.dateCeremonie.toDate().day,
          heureDebut!.hour,
          heureDebut!.minute));
    }
  }

  void editHourDebut() {
    showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((heure) {
      setState(() {
        heureDebut = heure;
      });
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
    return Scaffold(
      appBar: AppBar(
        leading: BoutonRetour(press: () {
          Navigator.pop(context);
        }),
      ),
      body: Container(
        height: double.infinity,
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.safeBlockHorizontal * 10),
        decoration: BoxDecorationBlue(context,
            topRigth: 40, topLeft: 40, bottomRigth: 0, bottomLeft: 0),
        child: Consumer<CeremonieProvider>(builder: (context, provider, child) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 5,
                ),
                Text(
                  Strings.paramsDetails,
                  textAlign: TextAlign.center,
                  style: ThemeElements(context: context).styleText(
                      color: ThemeElements(
                              context: context, mode: ColorMode.endroit)
                          .themeColor,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.safeBlockVertical * 3),
                ),
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 5,
                ),
                infoBulle(Strings.infoBulleModifs, context,
                    couleurTexte:
                        ThemeElements(context: context, mode: ColorMode.endroit)
                            .themeColor),
                SizedBox(
                  height: SizeConfig.safeBlockVertical * 5,
                ),
                Card(
                  shape: angleArrondi(15),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 15),
                    child: TextField(
                      style: ThemeElements(context: context).styleText(
                          color: ThemeElements(
                                  context: context, mode: ColorMode.envers)
                              .themeColor),
                      onChanged: (val) {
                        setState(() {
                          sTitre = val;
                        });
                      },
                      maxLines: 1,
                      cursorColor: ThemeElements(context: context).whichBlue,
                      decoration: InputDecoration(
                          hintStyle: ThemeElements(context: context).styleText(
                              color: ThemeElements(
                                      context: context, mode: ColorMode.envers)
                                  .themeColor),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      ThemeElements(context: context).whichBlue,
                                  width: 2.0)),
                          labelStyle: ThemeElements(context: context).styleText(
                              color: ThemeElements(context: context).whichBlue),
                          labelText: "Titre cérémonie",
                          hintText: provider.ceremonie!.titreCeremonie,
                          border: OutlineInputBorder()),
                    ),
                  ),
                ),
                Card(
                  shape: angleArrondi(15),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 15),
                    child: TextField(
                      style: ThemeElements(context: context).styleText(
                          color: ThemeElements(
                                  context: context, mode: ColorMode.envers)
                              .themeColor),
                      cursorColor: ThemeElements(context: context).whichBlue,
                      onChanged: (val) {
                        setState(() {
                          sNbreBillet = val;
                        });
                      },
                      maxLines: 1,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintStyle: ThemeElements(context: context).styleText(
                              color: ThemeElements(
                                      context: context, mode: ColorMode.envers)
                                  .themeColor),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      ThemeElements(context: context).whichBlue,
                                  width: 2.0)),
                          labelStyle: ThemeElements(context: context).styleText(
                              color: ThemeElements(context: context).whichBlue),
                          hintText: provider.ceremonie!.nbreBillets
                              .toInt()
                              .toString(),
                          labelText: "Nombre de billets",
                          border: OutlineInputBorder()),
                    ),
                  ),
                ),
                Card(
                  shape: angleArrondi(15),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 15),
                    child: TextField(
                      style: ThemeElements(context: context).styleText(
                          color: ThemeElements(
                                  context: context, mode: ColorMode.envers)
                              .themeColor),
                      cursorColor: ThemeElements(context: context).whichBlue,
                      onChanged: (val) {
                        setState(() {
                          sLieu = val;
                        });
                      },
                      maxLines: 1,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      ThemeElements(context: context).whichBlue,
                                  width: 2.0)),
                          labelStyle: ThemeElements(context: context).styleText(
                              color: ThemeElements(context: context).whichBlue),
                          hintStyle: ThemeElements(context: context).styleText(
                              color: ThemeElements(
                                      context: context, mode: ColorMode.envers)
                                  .themeColor),
                          hintText: provider.ceremonie!.lieuCeremonie,
                          labelText: "Lieu",
                          border: OutlineInputBorder()),
                    ),
                  ),
                ),
                Card(
                  shape: angleArrondi(15),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 15),
                    child: Row(
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
                                      hintStyle: TextStyle(
                                          color: ThemeElements(
                                                  context: context,
                                                  mode: ColorMode.envers)
                                              .themeColor),
                                      labelStyle: TextStyle(
                                          color: ThemeElements(context: context)
                                              .whichBlue),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      //        hasFloatingPlaceholder : true,
                                      hintText: isNullOrEmpty(jourCeremonie)
                                          ? provider.ceremonie!.dateCeremonie
                                              .toStringExt(separator: "/")
                                          : (DateFormat('d/M/y')
                                              .format(jourCeremonie!)
                                              .toStringDate()),
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
                                      hintStyle: TextStyle(
                                          color: ThemeElements(
                                                  context: context,
                                                  mode: ColorMode.envers)
                                              .themeColor),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: isNullOrEmpty(heureDebut)
                                          ? provider.ceremonie!.dateCeremonie
                                              .hourString()
                                          : heureDebut!
                                              .hourString() /*(forcerAvec0_devant(heureDebut!.hour.toString()) + ":" +  forcerAvec0_devant( heureDebut!.minute.toString())) */,
                                      labelText: "Heure début",
                                      border: OutlineInputBorder()),
                                ),
                              ),
                            ),
                          )
                        ]),
                  ),
                ),
                Card(
                  shape: angleArrondi(15),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RoundedLoadingButton(
                            color: ThemeElements(context: context).whichBlue,
                            controller: btnPosCtrl,
                            borderRadius: SizeConfig.safeBlockHorizontal * 3,
                            successColor: Colors.lightGreenAccent,
                            width: SizeConfig.safeBlockHorizontal * 40,
                            elevation: SizeConfig.safeBlockHorizontal * 2,
                            height: SizeConfig.safeBlockVertical * 7,
                            onPressed: () async {
                              String? msgError;
                              String titreError = "Modification détails";

                              Ceremonie nCeremonie = provider.ceremonie!;

                              try {
                                if (!isNullOrEmpty(sNbreBillet) &&
                                    isNumeric(sNbreBillet)) {
                                  nCeremonie.qrCodesDispo =
                                      CeremonieCtrl.ajustQrcodes(
                                          int.parse(sNbreBillet),
                                          nCeremonie.idsBillets.cast<String>(),
                                          nCeremonie.qrCodesDispo
                                              .cast<String>());
                                  nCeremonie.nbreBillets =
                                      nCeremonie.qrCodesDispo.length.toDouble();
                                }
                                editDateCeremonie(nCeremonie);

                                nCeremonie.lieuCeremonie = isNullOrEmpty(sLieu)
                                    ? nCeremonie.lieuCeremonie
                                    : (sLieu!);

                                nCeremonie.titreCeremonie =
                                    isNullOrEmpty(sTitre)
                                        ? nCeremonie.titreCeremonie
                                        : (sTitre!);

                                await nCeremonie.save();
                                await context
                                    .read<CeremonieProvider>()
                                    .refreshCeremonie(nCeremonie);
                                await context
                                    .read<CeremonieProvider>()
                                    .reloadBilletTemplate();
                              } on Exception catch (e) {
                                msgError = e.toString();
                                if (e.runtimeType.toString().toUpperCase() ==
                                    Strings.formatException) {
                                  msgError = "Nombre de billets incorrect";
                                }
                              } catch (e, s) {
                                msgError = e.toString();
                              }

                              if (!isNullOrEmpty(sNbreBillet) &&
                                  !isNumeric(sNbreBillet)) {
                                msgError = "Nombre de billets incorrect";
                              }
                              if (!isNullOrEmpty(msgError)) {
                                showFlushbar(
                                    context, false, titreError, msgError!);
                                btnPosCtrl.reset();
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            child: Text(
                              Strings.valider,
                              style: TextStyle(color: dBlack),
                            ),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
