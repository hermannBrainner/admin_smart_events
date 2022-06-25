import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_color/random_color.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/mode_Compte/_models/table.dart';
import '/mode_Compte/_models/zone.dart';
import '/mode_Compte/dispositions/action_boutons/fonctions/affecter.dart';
import '/mode_Compte/dispositions/action_boutons/fonctions/ajouter.dart';
import '/mode_Compte/dispositions/action_boutons/fonctions/editer.dart';
import '/mode_Compte/dispositions/action_boutons/fonctions/supprimer.dart';
import '/mode_Compte/dispositions/action_boutons/main.dart';
import '/mode_Compte/dispositions/components/tiles.dart';
import '/mode_Compte/listes/components/menu_items.dart';
import '/outils/constantes/colors.dart';
import '/outils/extensions/listes.dart';
import '/outils/extensions/string.dart';
import '/outils/fonctions/fonctions.dart';
import '/outils/size_configs.dart';
import '/outils/widgets/main.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/strings.dart';
import '../action_boutons/colorPicker.dart';
import '../action_boutons/parentPicker.dart';
import '../action_boutons/validation.dart';
import '../boutons_flottant.dart';
import '../components/search_bar.dart';

class TablesListDispo extends StatefulWidget {
  CeremonieProvider provider;
  Function editNbreSelected;

  TablesListDispo({required this.provider, required this.editNbreSelected});

  @override
  _TablesListDispoState createState() => _TablesListDispoState();
}

class _TablesListDispoState extends State<TablesListDispo> {
  Color colorSelected = randColor();

  Zone? parentSelected;

  editSelectedParent(Zone parent) {
    setState(() {
      parentSelected = parent;
    });
  }

  editSelectedColor(Color color) {
    setState(() {
      colorSelected = color;
    });
  }

  /// Elements pour le filtrage
  var _searchview = new TextEditingController();

  String _query = "";
  List<TableInvite> listFiltree = [];

  onSubmitSearch() {
    setState(() {
      listFiltree = ItemMenuListesInvites.filterTables(
        all: widget.provider.tablesInv,
        query: _query,
      );
    });
  }

  onClearSearch() {
    setState(() {
      listFiltree = widget.provider.tablesInv;
      _query = "";
      _searchview.clear();
    });
  }

  _TablesListDispoState() {
    _searchview.addListener(() {
      setState(() {
        _query = _searchview.text;
        listFiltree = ItemMenuListesInvites.filterTables(
          all: widget.provider.tablesInv,
          query: _query,
        );
      });
    });
  }

  /// Elements pour Selection

  bool isAllSelected = false;

  void cocherTable(TableInvite table) {
    setState(() {
      tablesSelect.removeOrAdd(table);

      widget.editNbreSelected(tablesSelect.length);
      btnsOn = !isNullOrEmpty(tablesSelect.length);

      colorSelected = ((tablesSelect.firstOrNullListe() as TableInvite?)
              ?.couleur
              .couleurFromHex()) ??
          Colors.blue;
    });
  }

  fctSelectAllOrNot() {
    setState(() {
      if (tablesSelect.length < listFiltree.length) {
        listFiltree
            .where((table) => !tablesSelect.contains(table))
            .forEach((table) {
          tablesSelect.add(table);
        });
      } else {
        listFiltree.forEach((table) {
          tablesSelect.remove(table);
        });
      }

      isAllSelected = tablesSelect.length >= listFiltree.length;
      btnsOn = !isNullOrEmpty(tablesSelect.length);
      widget.editNbreSelected(tablesSelect.length);
    });
  }

  // Fin element filtrage

  bool isFAB = false;
  ScrollController _scrollController = new ScrollController();

  bool btnsOn = true;

  late List<TableInvite> tablesSelect;

  // New Table elements
  //
  Color randomColor =
      RandomColor().randomColor(colorBrightness: ColorBrightness.primary);

  TextEditingController nomCtrl = new TextEditingController();
  RoundedLoadingButtonController btnPosCtrl =
      new RoundedLoadingButtonController();

  String textBtnPositif = Strings.confirm;

  addNewInListe(TableInvite tableInvite) {
    setState(() {
      widget.provider.tablesInv.removeOrAdd(tableInvite);
    });
  }

  void fctNewTable() {
    BoutonAction(
      hintTextNom: (tablesSelect.firstOrNullListe())?.nom ?? "",
      valueText: BoutonAction.ajouter,
      context: context,
      showBtn: true,
      nomCtrl: nomCtrl,
      boutonAnnuler: BoutonActionValidation(
              btnPosCtrl: btnPosCtrl,
              context: context,
              cleanAllCtrl: cleanAllCtrl,
              dispo: TypeDispo.Table)
          .annuler,
      btnValider: btnValider(BoutonAction.ajouter),
      nbreSelected: tablesSelect.length,
      colorPicker: widgetPickerColor(context, colorSelected, editSelectedColor),
      typeDispo: TypeDispo.Table,
    ).sheet;
  }

  //Affeection

  void cleanAllCtrl() {
    setState(() {
      tablesSelect = [];
      widget.editNbreSelected(tablesSelect.length); //.clear() ;
      btnsOn = !isNullOrEmpty(tablesSelect.length);
      nomCtrl.clear();
      parentSelected = null;
      colorSelected = randColor();
    });
    // btnPosCtrl.stop();
  }

  @override
  void initState() {
    super.initState();
    listFiltree = widget.provider.tablesInv;
    isAllSelected = false;
    tablesSelect = [];
    btnsOn = false;

    textBtnPositif = Strings.confirm;

    _scrollController.addListener(() {
      if (_scrollController.offset > 50) {
        setState(() {
          isFAB = true;
        });
      } else {
        setState(() {
          isFAB = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CeremonieProvider>(builder: (context, provider, child) {
      return Container(
        color: Colors.transparent,
        child: Column(
          children: [
            searchBar(
              context,
              inNbrePersonnes: listFiltree.length,
              fctOnSubmit: onSubmitSearch,
              searchview: _searchview,
              fctOnClear: onClearSearch,
              hauteur: MediaQuery.of(context).size.height * 0.16,
              typePage: 'table',
            ),
            Expanded(
                child: Stack(
              children: [
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: listFiltree.length,
                    itemBuilder: (BuildContext context, int id) {
                      var table = listFiltree[id];

                      Zone? parentZone =
                          CeremonieProvider.getTableParent(provider, table);

                      return InkWell(
                          onTap: () {
                            setState(() {
                              cocherTable(table);
                            });
                          },
                          child: tableTile(
                            context,
                            table,
                            tablesSelect.contains(table),
                            parentZone,
                            provider,
                            onTap: cocherTable,
                          ));
                    }),
                boutonAdd(
                    titre: "Nouvelle table",
                    displaySelection: btnsOn,
                    isAllSelected: isAllSelected,
                    isFAB: isFAB,
                    context: context,
                    onTap: btnsOn ? fctSelectAllOrNot : fctNewTable),
              ],
            )),
            bandeauBtns()
          ],
        ),
      );
    });
  }

  BoutonAction chooseBtnAction(String typeAction) {
    return BoutonAction(
      hintTextNom: (tablesSelect.firstOrNullListe())?.nom ?? "",
      valueText: typeAction,
      context: context,
      showBtn: (typeAction == BoutonAction.editer)
          ? (btnsOn && tablesSelect.length == 1)
          : btnsOn,
      nomCtrl: nomCtrl,
      boutonAnnuler: BoutonActionValidation(
              btnPosCtrl: btnPosCtrl,
              context: context,
              cleanAllCtrl: cleanAllCtrl,
              dispo: TypeDispo.Table)
          .annuler,
      btnValider: btnValider(typeAction),
      nbreSelected: tablesSelect.length,
      listChoixParent: (typeAction == BoutonAction.affecter
          ? widgetPickerParent(
              context, tablesSelect.firstOrNullListe(), editSelectedParent)
          : null),
      colorPicker:
          [BoutonAction.editer, BoutonAction.ajouter].contains(typeAction)
              ? widgetPickerColor(context, colorSelected, editSelectedColor)
              : null,
      typeDispo: TypeDispo.Table,
    );
  }

  bandeauBtns() {
    Widget wE = chooseBtnAction(BoutonAction.editer);
    Widget wS = chooseBtnAction(BoutonAction.supprimer);
    Widget wAf = chooseBtnAction(BoutonAction.affecter);

    List<Widget> all = [
      wE,
      wAf,
      wS,
    ];

    return Consumer<CeremonieProvider>(builder: (context, provider, child) {
      if (!widget.provider.ceremonie!.withZones) all.remove(wAf);

      return Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        height: 80,
        color: ThemeElements(context: context).whichBlue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: all,
        ),
      );
    });
  }

  void switchAll_NewTable() {
    textBtnPositif =
        (textBtnPositif == Strings.confirm) ? Strings.valider : Strings.confirm;
  }

  Widget btnValider(String typeAction) {
    return Consumer<CeremonieProvider>(builder: (context, provider, child) {
      return RoundedLoadingButton(
        child: Text(textBtnPositif),
        color: Colors.green,
        controller: btnPosCtrl,
        borderRadius: SizeConfig.safeBlockHorizontal * 3,
        successColor: Colors.lightGreenAccent,
        width: SizeConfig.safeBlockHorizontal * 40,
        elevation: SizeConfig.safeBlockHorizontal * 2,
        height: SizeConfig.safeBlockVertical * 7,
        onPressed: () async {
          btnPosCtrl.start();
          String? msgError;
          String titre = "ERREUR CREATION";

          if (typeAction == BoutonAction.editer) {
            await editerTable(
                provider: provider,
                colorSelected: colorSelected,
                nomCtrl: nomCtrl,
                table: tablesSelect.first);
          } else if (typeAction == BoutonAction.supprimer) {
            await deleteTable(
                provider: provider,
                tablesSelect: tablesSelect,
                removeInListe: addNewInListe);
          } else if (typeAction == BoutonAction.affecter) {
            await affecterTable(
                provider: provider,
                tablesSelect: tablesSelect,
                parentSelected: parentSelected!);
          } else if (typeAction == BoutonAction.ajouter) {
            await ajouterTable(
                context: context,
                provider: provider,
                nomCtrl: nomCtrl,
                colorSelected: colorSelected,
                addNewInListe: addNewInListe);
          }

          await context.read<CeremonieProvider>().refresh(provider);

          cleanAllCtrl();
          btnPosCtrl.stop();
          Navigator.pop(context);
          if (!isNullOrEmpty(msgError)) {
            showFlushbar(context, false, titre, msgError!);
          }
        },
      );
    });
  }
}
