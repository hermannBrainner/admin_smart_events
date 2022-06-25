import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/mode_Compte/_models/zone.dart';
import '/mode_Compte/dispositions/action_boutons/main.dart';
import '/mode_Compte/dispositions/action_boutons/validation.dart';
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
import '../action_boutons/fonctions/ajouter.dart';
import '../action_boutons/fonctions/editer.dart';
import '../action_boutons/fonctions/supprimer.dart';
import '../boutons_flottant.dart';
import '../components/search_bar.dart';

class ZonesListDispo extends StatefulWidget {
  CeremonieProvider provider;
  Function editNbreSelected;

  ZonesListDispo({required this.provider, required this.editNbreSelected});

  @override
  _ZonesListDispoState createState() => _ZonesListDispoState();
}

class _ZonesListDispoState extends State<ZonesListDispo> {
  Color colorSelected = randColor();

  editSelectedColor(Color color) {
    setState(() {
      colorSelected = color;
    });
  }

  /// Elements pour le filtrage
  var _searchview = new TextEditingController();

  String _query = "";
  List<Zone> listFiltree = [];

  onSubmitSearch() {
    setState(() {
      listFiltree = ItemMenuListesInvites.filterZones(
        all: widget.provider.zonesSalle,
        query: _query,
      );
    });
  }

  onClearSearch() {
    setState(() {
      listFiltree = widget.provider.zonesSalle;
      _query = "";
      _searchview.clear();
    });
  }

  _ZonesListDispoState() {
    _searchview.addListener(() {
      setState(() {
        _query = _searchview.text;
        listFiltree = ItemMenuListesInvites.filterZones(
          all: widget.provider.zonesSalle,
          query: _query,
        );
      });
    });
  }

  /// Elements pour Selection

  bool isAllSelected = false;
  late List<Zone> zonesSelect;

  void cocherZone(Zone zone) {
    setState(() {
      zonesSelect.removeOrAdd(zone);
      widget.editNbreSelected(zonesSelect.length);

      btnsOn = !isNullOrEmpty(zonesSelect.length);
      colorSelected = ((zonesSelect.firstOrNullListe() as Zone?)
              ?.couleur
              .couleurFromHex()) ??
          Colors.blue;
    });
  }

  addOrRemoveInListe(Zone zone) {
    setState(() {
      widget.provider.zonesSalle.removeOrAdd(zone);
    });
  }

  fctSelectAllOrNot() {
    setState(() {
      if (zonesSelect.length < listFiltree.length) {
        listFiltree
            .where((table) => !zonesSelect.contains(table))
            .forEach((table) {
          zonesSelect.add(table);
        });
      } else {
        listFiltree.forEach((table) {
          zonesSelect.remove(table);
        });
      }

      isAllSelected = zonesSelect.length >= listFiltree.length;
      btnsOn = !isNullOrEmpty(zonesSelect.length);
      widget.editNbreSelected(zonesSelect.length);
    });
  }

  bool isFAB = false;
  ScrollController _scrollController = new ScrollController();

  bool btnsOn = true;

  // New Zone elements

  TextEditingController nomCtrl = new TextEditingController();
  RoundedLoadingButtonController btnPosCtrl =
      new RoundedLoadingButtonController();

  final double hauteurSheetMin = 300;

  final double hauteurSheetMax = 700;

  late double hauteurSheet;

//  late String textBtnPositif;

  void fctNewZone() {
    BoutonAction(
      hintTextNom: (zonesSelect.firstOrNullListe())?.nom ?? "",
      valueText: BoutonAction.ajouter,
      context: context,
      showBtn: true,
      nomCtrl: nomCtrl,
      boutonAnnuler: BoutonActionValidation(
              context: context,
              cleanAllCtrl: cleanAllCtrl,
              dispo: TypeDispo.Zone,
              btnPosCtrl: btnPosCtrl)
          .annuler,
      btnValider: btnValider(
        BoutonAction.ajouter,
      ),
      nbreSelected: zonesSelect.length,
      colorPicker: widgetPickerColor(context, colorSelected, editSelectedColor),
      typeDispo: TypeDispo.Zone,
    ).sheet;
  }

  void cleanAllCtrl() {
    setState(() {
      zonesSelect.clear();
      widget.editNbreSelected(zonesSelect.length);
      btnsOn = !isNullOrEmpty(zonesSelect.length);
      nomCtrl.clear();
      colorSelected = randColor();
    });
    // btnPosCtrl.stop();
  }

  @override
  void initState() {
    super.initState();

    listFiltree = widget.provider.zonesSalle;

    zonesSelect = [];
    btnsOn = false;
    hauteurSheet = hauteurSheetMin;
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
              typePage: 'zone',
            ),
            Expanded(
                child: Stack(
              children: [
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: listFiltree.length,
                    itemBuilder: (BuildContext context, int id) {
                      var zone = listFiltree[id];
                      return InkWell(
                          onTap: () {
                            cocherZone(zone);
                          },
                          child: zoneTile(context, zone,
                              zonesSelect.contains(zone), provider,
                              onTap: cocherZone));
                    }),
                boutonAdd(
                    titre: "Nouvelle zone",
                    displaySelection: btnsOn,
                    isAllSelected: isAllSelected,
                    isFAB: isFAB,
                    context: context,
                    onTap: btnsOn ? fctSelectAllOrNot : fctNewZone),
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
      hintTextNom: (zonesSelect.firstOrNullListe())?.nom ?? "",
      valueText: typeAction,
      context: context,
      showBtn: (typeAction == BoutonAction.editer)
          ? (btnsOn && zonesSelect.length == 1)
          : btnsOn,
      nomCtrl: nomCtrl,
      boutonAnnuler: BoutonActionValidation(
              btnPosCtrl: btnPosCtrl,
              context: context,
              cleanAllCtrl: cleanAllCtrl,
              dispo: TypeDispo.Zone)
          .annuler,
      btnValider: btnValider(
        typeAction,
      ),
      nbreSelected: zonesSelect.length,
      colorPicker:
          [BoutonAction.editer, BoutonAction.ajouter].contains(typeAction)
              ? widgetPickerColor(context, colorSelected, editSelectedColor)
              : null,
      typeDispo: TypeDispo.Zone,
    );
  }

  Container bandeauBtns() {
    Widget wE = chooseBtnAction(BoutonAction.editer);
    Widget wS = chooseBtnAction(BoutonAction.supprimer);

    List<Widget> all = [wE, wS];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 60),
      height: 80,
      color: ThemeElements(context: context).whichBlue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: all,
      ),
    );
  }

  String HintTextModif(List<Zone> l) {
    if (l.isNotEmpty) {
      return l[0].nom;
    } else
      return "";
  }

  Widget btnValider(String typeAction) {
    return Consumer<CeremonieProvider>(builder: (context, provider, child) {
      return RoundedLoadingButton(
          child: Text(Strings.confirm),
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
              await editerZone(
                  provider: provider,
                  colorSelected: colorSelected,
                  nomCtrl: nomCtrl,
                  zone: zonesSelect.first);
            } else if (typeAction == BoutonAction.supprimer) {
              await deleteZone(
                  provider: provider,
                  zones: zonesSelect,
                  removeInListe: addOrRemoveInListe);
            } else if (typeAction == BoutonAction.ajouter) {
              await ajouterZone(
                  provider: provider,
                  nomCtrl: nomCtrl,
                  colorSelected: colorSelected,
                  addNewInListe: addOrRemoveInListe);
            }
            await context.read<CeremonieProvider>().refresh(provider);
            cleanAllCtrl();
            btnPosCtrl.stop();
            Navigator.pop(context);
            if (!isNullOrEmpty(msgError)) {
              showFlushbar(context, false, titre, msgError!);
            }
          });
    });
  }
}
