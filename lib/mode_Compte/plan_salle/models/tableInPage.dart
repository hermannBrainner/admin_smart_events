import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '/mode_Compte/_models/table.dart';
import '/outils/extensions/string.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/constantes.dart';
import 'invite.dart';

class TableInPage {
  static const double longMin = 20;

  TableInvite? table;
  final CeremonieProvider provider;

  late int idxPage;

  TableInPage({required this.provider, this.table});

  List<Invite> get invites {
    return Invite.fromTable(provider, table!);
  }

  double get rayonPlace {
    return 30;
  }

  Color get couleurNroChaise {
    return couleurChaise.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }

  Color get couleurChaise {
    return couleur.computeLuminance() > 0.3
        ? kPrimaryColorLightTheme
        : kPrimaryColorDarkTheme;
  }

  Color get couleur {
    return table!.couleur.couleurFromHex();
  }

  double get minL {
    return rayonPlace * 1.2;
  }

  int get nbrePlaceLateralMax {
    return ((invites.length - 6) / 2).ceil();
  }

  double get largeurTable {
    return 120;
  }

  double get longueur {
    return [(nbrePlaceLateralMax - 1) * minL, 0].reduce(max).toDouble();
  }

  double get hauteurTotale {
    return longueur + (largeurTable * 2);
  }

  set page(int nroPage) {
    idxPage = nroPage;
  }

  List<TableInPage> editPages(String? idParent) {
    final PdfDocument tempDoc = PdfDocument();
    PdfPage page = tempDoc.pages.add();
    double hauteurPage = page.getClientSize().height;
    tempDoc.pages.remove(page);

    List<TableInPage> tablesInPages = provider.tablesInv
        .where((table) => table.idParent == idParent)
        .map((table) => TableInPage(provider: provider, table: table))
        .toList();

    double evolTotalHauteur = 0;
    int idxPage = 1;

    for (TableInPage tableInPage in tablesInPages) {
      if (tableInPage.hauteurTotale + evolTotalHauteur > hauteurPage) {
        evolTotalHauteur = 0;
        idxPage++;
      }

      tableInPage.page = idxPage;
      evolTotalHauteur = evolTotalHauteur + tableInPage.hauteurTotale;
    }

    return tablesInPages;
  }
}
