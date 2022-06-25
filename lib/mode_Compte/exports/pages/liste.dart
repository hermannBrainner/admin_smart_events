// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '/mode_Compte/_models/billet.dart';
import '/mode_Compte/exports/components/tile.dart';
import '/mode_Compte/listes/components/menu_items.dart';
import '/outils/fonctions/dates.dart';
import '/outils/fonctions/fonctions.dart';
import '/outils/peintures.dart';
import '/outils/size_configs.dart';
import '/outils/widgets/main.dart';
import '/providers/ceremonie.dart';
import '../components/components_liste.dart';

double nbreMaxBillets = 30;

enum TYPE_IMPRESSION { billet, qrCode }

class BilletsListe extends StatefulWidget {
  CeremonieProvider provider;
  bool isSelection;

  TYPE_IMPRESSION type_impression;

  Function fctRefresh;

  BilletsListe(
      {required this.provider,
      required this.fctRefresh,
      required this.isSelection,
      required this.type_impression});

  @override
  _BilletsListeState createState() => _BilletsListeState();
}

class _BilletsListeState extends State<BilletsListe> {
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
      listFiltree.sort(Billet.compExport_Parent_Nom);
    });
  }

  onClearSearch() {
    setState(() {
      listFiltree = widget.provider.billetsInv;
      listFiltree.sort(Billet.compExport_Parent_Nom);
      _query = "";
      _searchview.clear();
    });
  }

  _BilletsListeState() {
    _searchview.addListener(() {
      setState(() {
        _query = _searchview.text;
        listFiltree = ItemMenuListesInvites.filter(
            billets: widget.provider.billetsInv,
            query: _query,
            menuCourant: null);
        listFiltree.sort(Billet.compExport_Parent_Nom);
      });
    });
  }

  /// End

  bool btnsOn = true;

  late List<Billet> billetsSelect = [];

  final double hauteurSheetMin = 300;

  final double hauteurSheetMax = 800;

  late double hauteurSheet;

  late String textBtnPositif;

  void refreshBillet(Billet billet, bool isAdd) {
    setState(() {
      if (isAdd) {
        if (billetsSelect.length < nbreMaxBillets) {
          billetsSelect.add(billet);
        }
      } else {
        billetsSelect.remove(billet);
      }
    });

    refresh();
  }

  void refresh() {
    widget.fctRefresh(billetsSelect);
  }

  void cleanAllCtrl() {
    setState(() {
      billetsSelect.clear();
      btnsOn = !isNullOrEmpty(billetsSelect.length);
    });
    refresh();
    // btnPosCtrl.stop();
  }

  submitSearch() {}

  void cleanSearch() {
    setState(() {
      _searchview.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    listFiltree = widget.provider.billetsInv;
    listFiltree.sort(Billet.compExport_Parent_Nom);
    billetsSelect = [];
  }

  @override
  Widget build(BuildContext context) {
    test();
    return CustomPaint(
      painter: toileHaut(context),
      child: Container(
        //   color: Colors.transparent,
        child: Column(
          children: [
            SizedBox(
              height: SizeConfig.safeBlockVertical * 1.8,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.safeBlockVertical * 1.8,
                horizontal: SizeConfig.safeBlockHorizontal * 6,
              ),
              child: customSearchInputText(
                  hintText: "Nom d'invité ...",
                  fctOnSubmit: submitSearch,
                  searchview: _searchview,
                  fctOnClear: cleanSearch),
            ),
            Visibility(
                visible: billetsSelect.isNotEmpty &&
                    (nbreMaxBillets - billetsSelect.length) > 5,
                child: texteSelection(context,
                    nbre: billetsSelect.length, removeAll: cleanAllCtrl)),
            Visibility(
                visible: billetsSelect.isNotEmpty &&
                    (nbreMaxBillets - billetsSelect.length) <= 5,
                child: goToPremium(
                    context, (nbreMaxBillets - billetsSelect.length).toInt())),
            Visibility(
              visible: isNullOrEmpty(billetsSelect.length),
              child: SizedBox(
                height: SizeConfig.safeBlockVertical * 3,
              ),
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 3,
            ),
            Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: listFiltree.length,
                    itemBuilder: (BuildContext context, int id) {
                      var billet = listFiltree[id];

                      List<dynamic>? allParents =
                          CeremonieProvider.getParentsForBillets(
                              widget.provider);
                      dynamic parent = isNullOrEmpty(allParents)
                          ? null
                          : allParents!
                              .firstWhereOrNull((p) => p.id == billet.idParent);

                      return InkWell(
                          child: qrBilletTile(billet, parent,
                              widget.provider.ceremonie!, context,
                              displaycheckBx: widget.isSelection,
                              fctRefrech: refreshBillet,
                              isSelected: billetsSelect.contains(billet)));
                    })),
          ],
        ),
      ),
    );
  }
}
