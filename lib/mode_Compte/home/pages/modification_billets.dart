import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/mode_Compte/imports/main.dart';
import '/outils/fonctions/fonctions.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/strings.dart';
import '../components/billets_tiles.dart';

class PageModifBillets extends StatefulWidget {
  const PageModifBillets({Key? key}) : super(key: key);

  @override
  _PageModifBilletsState createState() => _PageModifBilletsState();
}

class _PageModifBilletsState extends State<PageModifBillets> {
  String? inUrl;

  RoundedLoadingButtonController btnPosCtrl = RoundedLoadingButtonController();

  bool displayEdit = false;

  bool displayValidationReset = false;

  bool isConfirmed = false;

  switchDisplayValidReset() {
    setState(() {
      displayValidationReset = !displayValidationReset;
    });
  }

  editUrl(String? val) {
    setState(() {
      inUrl = val;
    });
  }

  switchDisplayEdition() {
    setState(() {
      displayEdit = !displayEdit;
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
      return DefaultTabController(
          length: 4,
          child: Column(
            children: [
              Container(
                height: 50,
                color: Colors.transparent,
                child: TabBar(
                    labelColor:
                        ThemeElements(context: context, mode: ColorMode.endroit)
                            .themeColor,
                    unselectedLabelColor:
                        ThemeElements(context: context, mode: ColorMode.envers)
                            .themeColor,
                    indicatorColor: ThemeElements(context: context).whichBlue,
                    tabs: [
                      Tab(
                        child: Text(
                          "Qr Code",
                        ),
                      ),
                      Tab(
                        child: Text("Import"),
                      ),
                      Tab(
                        child: Text("Print"),
                      ),
                      Tab(
                        child: Text("Reset"),
                      )
                    ]),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          qrCodeTile(
                            valueEdited: inUrl,
                            setValue: editUrl,
                            displayEdition: displayEdit,
                            context: context,
                            provider: provider,
                            auClick: switchDisplayEdition,
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          importTile(
                            auClick: () {
                              Navigator.pushNamed(
                                  context, ImportsMainView.routeName);
                            },
                            context: context,
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          exportTile(
                            context: context,
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          resetTile(
                            context: context,
                            disPlayValidation: displayValidationReset,
                            switchFct: switchDisplayValidReset,
                            checkConfimation: checkConfimation,
                            isConfirmationGood: isConfirmed,
                            provider: provider,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ));
    });
  }
}
