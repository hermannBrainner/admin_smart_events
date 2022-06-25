import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/mode_Compte/_models/billet_acces.dart';
import '/mode_Compte/exports/main.dart';
import '/outils/size_configs.dart';
import '/outils/widgets/main.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/bouton_retour.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/primary_loading_bouton.dart';
import '/providers/theme/strings.dart';
import 'edition/nadia/fields.dart';
import 'edition/tile.dart';

class EditionTemplate extends StatefulWidget {
  static const String routeName = '/Edition_Template';

  final String templateCourant;

  const EditionTemplate({Key? key, required this.templateCourant})
      : super(key: key);

  @override
  State<EditionTemplate> createState() => _EditionTemplateState();
}

class _EditionTemplateState extends State<EditionTemplate> {
  String selectedTemplate = BilletAcces.TEMPLATE_NADIA;

  @override
  Widget build(BuildContext context) {
    return Consumer<CeremonieProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: AppBar(
            title: Text("Modification billet"),
            leading: BoutonRetour(press: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => ExportsMainView()));
            })),
        body: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  height: SizeConfig.blockSizeVertical * 15,
                  padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.blockSizeVertical * 2,
                      horizontal: SizeConfig.blockSizeHorizontal * 5),
                  child: Text(
                    "Choisissez votre template",
                    style:
                        ThemeElements(context: context, mode: ColorMode.envers)
                            .styleText(
                                fontSize: SizeConfig.blockSizeHorizontal * 8),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  height: SizeConfig.blockSizeVertical * 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: ThemeElements(context: context).whichBlue,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40),
                          topLeft: Radius.circular(40))),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: BilletAcces.allTemplates.map((temp) {
                            return TemplateBilletTile<String>(
                              provider: provider,
                              nomTemplate: temp,
                              groupValue: selectedTemplate,
                              onChanged: (value) {
                                setState(() {
                                  selectedTemplate = value;
                                });
                              },
                            );
                          }).toList()),
                    ),
                  ),
                ),
                Container(
                  child: FutureBuilder<Map<String, dynamic>>(
                      future: BilletAcces(
                              provider: provider, fontDatas: provider.fontDatas)
                          .getValuesOfTemplate(selectedTemplate),
                      builder: (context, future) {
                        if (!future.hasData) {
                          return Center(child: getLoadingWidget(context));
                        } else {
                          return Container(
                            color: ThemeElements(context: context).whichBlue,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 30, horizontal: 1),
                              decoration: BoxDecoration(
                                  color: ThemeElements(
                                          context: context,
                                          mode: ColorMode.endroit)
                                      .themeColor,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(30),
                                      topLeft: Radius.circular(30))),
                              child: EditionValeursTemplates(
                                template: selectedTemplate,
                                templateValues: future.data!,
                                provider: provider,
                              ),
                            ),
                          );
                        }
                      }),
                ),
                Visibility(
                  visible: widget.templateCourant != selectedTemplate,
                  child: Container(
                    color: ThemeElements(context: context).whichBlue,
                    child: Container(
                      decoration: BoxDecoration(
                        color: ThemeElements(
                                context: context, mode: ColorMode.endroit)
                            .themeColor,
                      ),
                      child: Container(
                        height: 100,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 1),
                        decoration: BoxDecoration(
                            color: ThemeElements(context: context)
                                .whichBlue, // dBlack,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                topLeft: Radius.circular(30))),
                        child: PrimaryLoadingButton(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.safeBlockHorizontal * 25,
                                vertical: SizeConfig.safeBlockVertical * 1),
                            color: Colors.orangeAccent,
                            text: Strings.valider,
                            press: () async {
                              BilletAcces(
                                      provider: provider,
                                      fontDatas: provider.fontDatas)
                                  .currentTemplate = selectedTemplate;

                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ExportsMainView()));
                            },
                            btnCtrl: RoundedLoadingButtonController()),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
