import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/mode_Compte/_models/identifiants.dart';
import '/outils/constantes/colors.dart';
import '/outils/constantes/strings.dart';
import '/outils/fonctions/fonctions.dart';
import '/outils/size_configs.dart';
import '/outils/widgets/main.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/strings.dart';
import '../../messagerie/open_button.dart';
import '../components/use_tile.dart';

class PageModifUtilisation extends StatefulWidget {
  const PageModifUtilisation({Key? key}) : super(key: key);

  @override
  _PageModifUtilisationState createState() => _PageModifUtilisationState();
}

class _PageModifUtilisationState extends State<PageModifUtilisation> {
  final focusBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue, width: 2.0));

  String? inIdentifiant;

  String? inMdp;

  RoundedLoadingButtonController btnPosCtrl = RoundedLoadingButtonController();

  bool displayEditMdp = false;

  switchDisplayEditIdentifiant() {
    setState(() {
      displayEditMdp = !displayEditMdp;
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
            useTile(
              context,
              displayEdit: false,
              titre: "Qui ?",
              details:
                  "Un personnel d'accueil, Une hotêsse, le protocole, la sécurité, vous ...",
              provider: provider,
              auClick: () {},
              isRed: false,
            ),
            Visibility(
              visible: !displayEditMdp,
              child: useTile(
                context,
                displayEdit: true,
                titre: "Identifiant & Mot de passe ",
                details: " > ${provider.ceremonie!.username} " +
                    newLine +
                    " > ${provider.ceremonie!.mdp} ",
                provider: provider,
                auClick: switchDisplayEditIdentifiant,
                isRed: false,
              ),
            ),

            Visibility(
              visible: displayEditMdp,
              child: Container(
                  height: 250,
                  margin: EdgeInsets.symmetric(
                      horizontal: SizeConfig.safeBlockHorizontal * 2),
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.safeBlockHorizontal * 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          style: ThemeElements(context: context).styleText(
                              color: ThemeElements(
                                      context: context, mode: ColorMode.envers)
                                  .themeColor),
                          onChanged: (val) {
                            setState(() {
                              inIdentifiant = val;
                            });
                          },
                          maxLines: 1,
                          cursorColor:
                              ThemeElements(context: context).whichBlue,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ThemeElements(context: context)
                                          .whichBlue,
                                      width: 2.0)),
                              labelStyle: ThemeElements(context: context)
                                  .styleText(
                                      color: ThemeElements(context: context)
                                          .whichBlue),
                              labelText: "Identifiant",
                              hintText: provider.ceremonie!.username,
                              border: OutlineInputBorder()),
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 2,
                        ),
                        TextField(
                          style: ThemeElements(context: context).styleText(
                              color: ThemeElements(
                                      context: context, mode: ColorMode.envers)
                                  .themeColor),
                          cursorColor:
                              ThemeElements(context: context).whichBlue,
                          onChanged: (val) {
                            setState(() {
                              inMdp = val;
                            });
                          },
                          maxLines: 1,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ThemeElements(context: context)
                                          .whichBlue,
                                      width: 2.0)),
                              labelStyle: ThemeElements(context: context)
                                  .styleText(
                                      color: ThemeElements(context: context)
                                          .whichBlue),
                              hintText: provider.ceremonie!.mdp,
                              labelText: "Mot de passe",
                              border: OutlineInputBorder()),
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 3,
                        ),
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

                            IdentifiantEvent? identifiantsEvent =
                                await IdentifiantEvent.getOne(context,
                                    inUserName: provider.ceremonie!.username);

                            if (identifiantsEvent != null) {
                              try {
                                provider.ceremonie!.username =
                                    isNullOrEmpty(inIdentifiant)
                                        ? provider.ceremonie!.username
                                        : (inIdentifiant!);
                                provider.ceremonie!.mdp = isNullOrEmpty(inMdp)
                                    ? provider.ceremonie!.mdp
                                    : (inMdp!);

                                await provider.ceremonie!.save();

                                identifiantsEvent.username =
                                    provider.ceremonie!.username;
                                identifiantsEvent.password =
                                    provider.ceremonie!.mdp;

                                await identifiantsEvent.save();

                                await context
                                    .read<CeremonieProvider>()
                                    .refreshCeremonie(provider.ceremonie!);
                                switchDisplayEditIdentifiant();
                              } on Exception catch (e) {
                                msgError = e.toString();
                              } catch (e, s) {
                                msgError = e.toString();
                              }

                              await context
                                  .read<CeremonieProvider>()
                                  .loadCeremonie(provider.ceremonie!.id);
                            } else {
                              msgError = "Erreur";
                            }

                            if (!isNullOrEmpty(msgError)) {
                              showFlushbar(context, false, "", msgError!);
                            }
                          },
                          child: Text(
                            Strings.valider,
                            style: ThemeElements(context: context)
                                .styleText(color: dBlack),
                          ),
                        )
                      ])),
            ),

            shareAppTile(context),
            //TODO : Mettre la fonction de partage de l'application

            openMessagerie(context),

            SizedBox(
              height: SizeConfig.blockSizeVertical * 2,
            ),

            SizedBox(
              height: SizeConfig.blockSizeVertical * 2,
            ),
          ],
        ),
      );
    });
  }
}
