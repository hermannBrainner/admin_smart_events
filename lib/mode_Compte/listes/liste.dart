import 'package:flutter/material.dart';

import '/mode_Compte/_models/billet.dart';
import '/mode_Compte/listes/components/menu_items.dart';
import 'components/chapeau.dart';
import 'components/listes_invites.dart';
import 'components/menu_widget.dart';

class BilletsListe extends StatefulWidget {
  final List<Billet> billets;

  BilletsListe({
    required this.billets,
  });

  @override
  _BilletsListeState createState() => _BilletsListeState();
}

class _BilletsListeState extends State<BilletsListe> {
  var _searchview = new TextEditingController();

  bool isRecherche = false;
  String _query = "";

  List<Billet> listFiltree = [];

  String menuCourant = ItemMenuListesInvites.menuItems[0];

  onSubmitSearch() {
    setState(() {
      listFiltree = ItemMenuListesInvites.filter(
          billets: widget.billets, query: _query, menuCourant: menuCourant);
    });
  }

  onClearSearch() {
    setState(() {
      listFiltree = List<Billet>.from([]).toList();
      _query = "";
      _searchview.clear();
    });
  }

  void switchItem(String value) {
    setState(() {
      menuCourant = value;
      listFiltree = listDisplay();
    });
  }

  @override
  void initState() {
    super.initState();
  }

  _BilletsListeState() {
    _searchview.addListener(() {
      if (_searchview.text.isEmpty) {
        setState(() {
          isRecherche = false;
          _query = "";
        });
      } else if (_searchview.text == "") {
        isRecherche = false;
      } else {
        setState(() {
          isRecherche = true;
          _query = _searchview.text;
          listFiltree = ItemMenuListesInvites.filter(
              billets: widget.billets, query: _query, menuCourant: menuCourant);
        });
      }
    });
  }

  List<Billet> listDisplay() {
    if (!isRecherche) {
      listFiltree = ItemMenuListesInvites.filter(
          billets: widget.billets, query: _query, menuCourant: menuCourant);
    }
    return listFiltree;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        menuListes(context, menuCourant, switchItem),
        chapeauListes(context, _searchview,
            fctOnSubmit: onSubmitSearch,
            fctOnClear: onClearSearch,
            totalBillet: listDisplay().length,
            nbreInvites: listDisplay().fold(
                0,
                (int previousValue, billet) =>
                    previousValue + billet.nbrePersonnes)),
        listeInvites(listDisplay()),
      ],
    );
  }
}
