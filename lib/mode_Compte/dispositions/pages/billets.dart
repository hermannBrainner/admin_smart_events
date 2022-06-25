// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/mode_Compte/_models/billet.dart';
import '/mode_Compte/_models/ceremonie.dart';
import '/mode_Compte/_models/table.dart';
import '/mode_Compte/dispositions/action_boutons/fonctions/affecter.dart';
import '/mode_Compte/dispositions/action_boutons/fonctions/ajouter.dart';
import '/mode_Compte/dispositions/action_boutons/fonctions/supprimer.dart';
import '/mode_Compte/dispositions/action_boutons/main.dart';
import '/mode_Compte/dispositions/components/tiles.dart';
import '/mode_Compte/listes/components/menu_items.dart';
import '/outils/extensions/listes.dart';
import '/outils/fonctions/fonctions.dart';
import '/outils/size_configs.dart';
import '/outils/widgets/main.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/strings.dart';
import '../action_boutons/fonctions/editer.dart';
import '../action_boutons/parentPicker.dart';
import '../action_boutons/validation.dart';
import '../boutons_flottant.dart';
import '../components/search_bar.dart';

class BilletsListDispo extends StatefulWidget {
  CeremonieProvider provider;
  Function editNbreSelected;

  BilletsListDispo({required this.provider, required this.editNbreSelected});

  @override
  _BilletsListDispoState createState() => _BilletsListDispoState();
}

class _BilletsListDispoState extends State<BilletsListDispo> {
  TableInvite? parentSelected;

  editSelectedParent(TableInvite parent) {
    setState(() {
      parentSelected = parent;
    });
  }

  /// Elements pour le filtrage
  var _searchview = new TextEditingController();

  String _query = "";
  List<Billet> listFiltree = [];

  onSubmitSearch() {
    setState(() {
      listFiltree = ItemMenuListesInvites.filter(
          billets: widget.provider.billetsInv,
          query: _query,
          menuCourant: null);
    });
  }

  onClearSearch() {
    setState(() {
      listFiltree = widget.provider.billetsInv;
      _query = "";
      _searchview.clear();
    });
  }

  _BilletsListDispoState() {
    _searchview.addListener(() {
      setState(() {
        _query = _searchview.text;
        listFiltree = ItemMenuListesInvites.filter(
            billets: widget.provider.billetsInv,
            query: _query,
            menuCourant: null);
      });
    });
  }

  /// FIN Elements pour le filtrage

  /// Elements pour Selection

  bool isAllSelected = false;

  void cocherBillet(Billet billet) {
    setState(() {
      billetsSelect.contains(billet)
          ? billetsSelect.remove(billet)
          : billetsSelect.add(billet);

      widget.editNbreSelected(billetsSelect.length);

      btnsOn = !isNullOrEmpty(billetsSelect.length);
    });
  }

  fctSelectAllOrNot() {
    setState(() {
      if (billetsSelect.length < listFiltree.length) {
        listFiltree
            .where((billet) => !billetsSelect.contains(billet))
            .forEach((billet) {
          billetsSelect.add(billet);
        });
      } else {
        listFiltree.forEach((billet) {
          billetsSelect.remove(billet);
        });
      }

      isAllSelected = billetsSelect.length >= listFiltree.length;
      btnsOn = !isNullOrEmpty(billetsSelect.length);
      widget.editNbreSelected(billetsSelect.length);
    });
  }

  // Fin element filtrage

  bool isFAB = false;
  ScrollController _scrollController = new ScrollController();

  bool btnsOn = true;

  List<Billet> billetsSelect = [];

  // New Billet elements
  TextEditingController nomCtrl = new TextEditingController();
  TextEditingController nbreCtrl = new TextEditingController();
  RoundedLoadingButtonController btnPosCtrl =
      new RoundedLoadingButtonController();
  late bool displayPicker;

  String textBtnPositif = Strings.confirm;

  //Affection

  void cleanAllCtrl() {
    setState(() {
      billetsSelect.clear();

      widget.editNbreSelected(billetsSelect.length);
      btnsOn = !isNullOrEmpty(billetsSelect.length);
      nomCtrl.clear();
      nbreCtrl.clear();
      parentSelected = null;
    });
  }

  refreshInListe(Billet billet) {
    setState(() {
      widget.provider.billetsInv.removeOrAdd(billet);
    });
  }

  void fctNewBillet() {
    BoutonAction(
            hintTextNom: (billetsSelect.firstOrNullListe())?.nom ?? "",
            valueText: BoutonAction.ajouter,
            context: context,
            showBtn: true,
            nomCtrl: nomCtrl,
            nbreCtrl: nbreCtrl,
            btnValider: btnValider(BoutonAction.ajouter),
            boutonAnnuler: BoutonActionValidation(
                    btnPosCtrl: btnPosCtrl,
                    context: context,
                    cleanAllCtrl: cleanAllCtrl,
                    dispo: TypeDispo.Billet)
                .annuler,
            nbreSelected: 0,
            typeDispo: TypeDispo.Billet)
        .sheet;
  }

  @override
  void initState() {
    super.initState();

    listFiltree = widget.provider.billetsInv;

    billetsSelect = [];

    btnsOn = false;
    displayPicker = false;

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
              inNbrePersonnes: listFiltree.fold(
                  0, (int prev, billet) => billet.nbrePersonnes + prev),
              fctOnSubmit: onSubmitSearch,
              searchview: _searchview,
              fctOnClear: onClearSearch,
              hauteur: MediaQuery.of(context).size.height * 0.16,
              typePage: 'invité',
            ),
            Expanded(
                child: Stack(
              children: [
                ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    itemCount: listFiltree.length,
                    itemBuilder: (BuildContext context, int id) {
                      var billet = listFiltree[id];
                      List<dynamic>? allParents =
                          CeremonieProvider.getParentsForBillets(provider);

                      dynamic parent = isNullOrEmpty(allParents)
                          ? null
                          : allParents!
                              .firstWhereOrNull((p) => p.id == billet.idParent);

                      return InkWell(
                          onTap: () {
                            cocherBillet(billet);
                          },
                          child: billetTile(context, billet,
                              billetsSelect.contains(billet), parent, provider,
                              onTap: cocherBillet));
                    }),
                boutonAdd(
                    titre: "Nouveau billet",
                    displaySelection: btnsOn,
                    isAllSelected: isAllSelected,
                    isFAB: isFAB,
                    context: context,
                    onTap: btnsOn ? fctSelectAllOrNot : fctNewBillet),
              ],
            )),
            bandeauBtns(provider.ceremonie!)
          ],
        ),
      );
    });
  }

  BoutonAction chooseBtnAction(String typeAction) {
    return BoutonAction(
      hintTextNom: (billetsSelect.firstOrNullListe())?.nom ?? "",
      valueText: typeAction,
      context: context,
      showBtn: (typeAction == BoutonAction.editer)
          ? (btnsOn && billetsSelect.length == 1)
          : btnsOn,
      nomCtrl: nomCtrl,
      nbreCtrl: nbreCtrl,
      hintTextNbre:
          (billetsSelect.firstOrNullListe())?.nbrePersonnes.toString() ?? "",
      boutonAnnuler: BoutonActionValidation(
              btnPosCtrl: btnPosCtrl,
              context: context,
              cleanAllCtrl: cleanAllCtrl,
              dispo: TypeDispo.Billet)
          .annuler,
      btnValider: btnValider(typeAction),
      nbreSelected: billetsSelect.length,
      listChoixParent: (typeAction == BoutonAction.affecter
          ? widgetPickerParent(
              context, billetsSelect.firstOrNullListe(), editSelectedParent)
          : null),
      typeDispo: TypeDispo.Billet,
    );
  }

  Container bandeauBtns(Ceremonie c) {
    Widget wE = chooseBtnAction(BoutonAction.editer);
    Widget wS = chooseBtnAction(BoutonAction.supprimer);
    Widget wAf = chooseBtnAction(BoutonAction.affecter);

    List<Widget> all = [wE, wAf, wS];

    if (!(c.withZones || c.withTables)) all.remove(wAf);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      height: 80,
      color: ThemeElements(context: context).whichBlue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: all,
      ),
    );
  }

  void switchAll_NewBillet() {
    textBtnPositif =
        (textBtnPositif == Strings.confirm) ? Strings.valider : Strings.confirm;
    displayPicker = !displayPicker;
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
          String titre = "";

          if (typeAction == BoutonAction.editer) {
            await editerBillet(
                provider: provider,
                msgError: msgError,
                nbreCtrl: nbreCtrl,
                nomCtrl: nomCtrl,
                billet: billetsSelect.first);
          } else if (typeAction == BoutonAction.supprimer) {
            await deleteBillet(
                provider: provider,
                billetsSelect: billetsSelect,
                removeInListe: refreshInListe);
          } else if (typeAction == BoutonAction.affecter) {
            await affecterBillet(
                provider: provider,
                billetsSelect: billetsSelect,
                parentSelected: parentSelected!);
          } else if (typeAction == BoutonAction.ajouter) {
            msgError = await ajouterBillet(
                provider: provider,
                btnPosCtrl: btnPosCtrl,
                context: context,
                nbreCtrl: nbreCtrl,
                nomCtrl: nomCtrl,
                billetsSelect: billetsSelect,
                addNewInListe: refreshInListe);
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
