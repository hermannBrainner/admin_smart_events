import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '/mode_Compte/_models/table.dart';
import '/mode_Compte/_models/zone.dart';
import '/outils/constantes/collections.dart';
import '/outils/fonctions/fonctions.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/strings.dart';
import '../_controllers/billet.dart';
import '../billets_acces/imported/main.dart';
import '../resultats_scan/widgets.dart';
import 'billet_acces.dart';
import 'ceremonie.dart';

class Billet {
  String id;

  String? idParent;
  String? qrCode;
  String nom;
  int nbrePersonnes;

  bool estArrive;

  bool estInstalle;
  bool estSorti;

  Timestamp? heureArrivee;
  Timestamp? heureInstallation;
  Timestamp? lastExport;

  static CollectionReference collection =
      FirebaseFirestore.instance.collection(nomCollectionBillets);

  static const b_id = "id";
  static const b_idParent = "idParent";
  static const b_nbrePersonnes = "nbrePersonnes";
  static const b_nom = "nom";
  static const b_qrCode = "qrCode";
  static const b_estArrive = "estArrive";
  static const b_estInstalle = "estInstalle";
  static const b_estSorti = "estSorti";
  static const b_heureArrivee = "heureArrivee";
  static const b_heureInstallation = "heureInstallation";

  static const b_lastExport = "lastExport";

  Billet(
      {required this.id,
      this.idParent,
      required this.nom,
      this.nbrePersonnes = 0,
      this.estArrive = false,
      this.qrCode,
      this.estInstalle = false,
      this.estSorti = false,
      this.heureArrivee,
      this.heureInstallation,
      this.lastExport});

  updateExport() async {
    lastExport = Timestamp.now();
    return save();
  }

  static Billet mock() {
    return Billet(id: Strings.na, nom: "  ", qrCode: BilletCtrl.makeQrCode());
  }

  Future<ByteData> qrCodeMaker(Ceremonie ceremonie) async {
    final qrValidationResult = QrValidator.validate(
      data: dataQrCode(ceremonie),
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.L,
    );

    qrValidationResult.status == QrValidationStatus.valid;
    final qrCode = qrValidationResult.qrCode;

    final painter = QrPainter.withQr(
      qr: qrCode!,
      color: Colors.black,
      gapless: true,
      embeddedImageStyle: null,
      embeddedImage: null,
    );

    final picData =
        await painter.toImageData(2048, format: ImageByteFormat.png);
    return picData!;
  }

  TableInvite? getMyTable(CeremonieProvider provider) {
    if (provider.ceremonie!.withTables && !isNullOrEmpty(idParent)) {
      return provider.tablesInv
          .firstWhereOrNull((table) => table.id == idParent);
    } else {
      return null;
    }
  }

  Zone? getMyZone(CeremonieProvider provider) {
    if (provider.ceremonie!.withZones) {
      TableInvite? tableInvite = getMyTable(provider);

      if (!isNullOrEmpty(tableInvite)) {
        return provider.zonesSalle
            .firstWhereOrNull((zone) => zone.id == tableInvite!.idParent);
      }
    }

    return null;
  }

  dataQrCode(Ceremonie ceremonie) {
    return ceremonie.urlPrefix ??
        Strings.exempleUrl + "/code/" + "${ceremonie.id}_$qrCode";
  }

  Map<String, dynamic> toMap() {
    var data = Map<String, dynamic>();
    data[Billet.b_id] = id;
    data[Billet.b_idParent] = idParent;
    data[Billet.b_nbrePersonnes] = nbrePersonnes;
    data[Billet.b_nom] = nom;
    data[Billet.b_qrCode] = qrCode;
    data[Billet.b_estArrive] = estArrive;
    data[Billet.b_estInstalle] = estInstalle;
    data[Billet.b_estSorti] = estSorti;
    data[Billet.b_heureArrivee] = heureArrivee;
    data[Billet.b_heureInstallation] = heureInstallation;
    data[Billet.b_lastExport] = lastExport;

    return data;
  }

  static DateTime get dateTemoin => DateTime(2099, 1, 1, 1, 0);

  static Comparator<Billet> compParent = (b1, b2) {
    return (b1.idParent ?? "").compareTo(b2.idParent ?? "");
  };
  static Comparator<Billet> compNom = (b1, b2) {
    return (b1.nom).compareTo(b2.nom);
  };

  static Comparator<Billet> compArrivee = (b1, b2) {
    return (b1.heureArrivee?.toDate() ?? dateTemoin)
        .compareTo(b2.heureArrivee?.toDate() ?? dateTemoin);
  };
  static Comparator<Billet> compExport = (b1, b2) {
    return (b1.lastExport?.toDate() ?? dateTemoin)
        .compareTo(b2.lastExport?.toDate() ?? dateTemoin);
  };

  static Comparator<Billet> compParent_Nom = (b1, b2) {
    return compParent(b1, b2) == 0 ? compNom(b1, b2) : compParent(b1, b2);
  };

  static Comparator<Billet> compExport_Parent_Nom = (b2, b1) {
    return compExport(b1, b2) == 0
        ? compParent_Nom(b1, b2)
        : compExport(b1, b2);
  };

  static Comparator<Billet> compArrivee_Parent_Nom = (b1, b2) {
    return compArrivee(b1, b2) == 0
        ? compParent_Nom(b1, b2)
        : compArrivee(b1, b2);
  };

  delete() async {
    return await collection.doc(id).delete();
  }

  save() async {
    return await collection.doc(id).set(toMap());
  }

  String dateArrivee() {
    initializeDateFormatting("fr");
    Intl.defaultLocale = "fr_FR";

    Duration difference = DateTime.now().difference(heureArrivee!.toDate());

    if (heureArrivee!.toDate().year == DateTime.now().year) {
      if (difference.inDays < 1) {
        if (difference.inHours > DateTime.now().hour) {
          return ("Hier   " +
              DateFormat('HH:mm')
                  .format(heureArrivee!.toDate())); //.toUpperCase() ;
        } else {
          return DateFormat('Auj. HH:mm')
              .format(heureArrivee!.toDate()); //.toUpperCase() ;
        }
      } else {
        return DateFormat('dd MMM  HH:mm')
            .format(heureArrivee!.toDate()); //.toUpperCase();
      }
    } else {
      return DateFormat('dd MMM yyyy  HH:mm')
          .format(heureArrivee!.toDate()); // .toUpperCase() ;
    }
  }

  installation() async {
    estInstalle = true;
    heureInstallation = Timestamp.now();
    await save();
  }

  reinit() async {
    this.estArrive = false;
    this.estInstalle = false;
    this.heureArrivee = null;
    this.heureInstallation = null;

    await save();
  }

  switchEntreeSortie() async {
    estSorti = !estSorti;

    await save();
  }

  valider() async {
    estArrive = true;
    heureArrivee = Timestamp.now();
    await save();
  }

  static typeResultat resultScan(Billet? billet) {
    if (isNullOrEmpty(billet)) {
      return typeResultat.INVALIDE;
    } else {
      if (billet!.estArrive) {
        return typeResultat.DEJA_VALIDE;
      } else {
        return typeResultat.A_VALIDE;
      }
    }
  }

  Billet.fromJson(Map<String, dynamic> item)
      : this.id = item[b_id],
        this.idParent = item[b_idParent],
        this.nbrePersonnes = item[b_nbrePersonnes],
        this.qrCode = item[b_qrCode],
        this.nom = item[b_nom],
        this.estArrive = item[b_estArrive],
        this.estInstalle = item[b_estInstalle],
        this.estSorti = item[b_estSorti],
        this.heureArrivee = item[b_heureArrivee],
        this.heureInstallation = item[b_heureInstallation],
        this.lastExport = item[b_lastExport];

  static Billet fromSnapshot(DocumentSnapshot item) {
    return Billet(
        id: item[b_id],
        idParent: item[b_idParent],
        nbrePersonnes: item[b_nbrePersonnes],
        qrCode: item[b_qrCode],
        nom: item[b_nom],
        estArrive: item[b_estArrive],
        estInstalle: item[b_estInstalle],
        estSorti: item[b_estSorti],
        heureArrivee: item[b_heureArrivee],
        heureInstallation: item[b_heureInstallation],
        lastExport: item.data().toString().contains(b_lastExport)
            ? item[b_lastExport]
            : null);
  }

  static Future<Billet> getById(String id) async {
    late Billet billet;
    await collection.where(b_id, isEqualTo: id).get().then((line) {
      if (line.docs.isNotEmpty) {
        billet =
            Billet.fromJson(line.docs.first.data() as Map<String, dynamic>);
      }
    }).catchError((e) {
      return null;
    });

    return billet;
  }

  Future<File> getBilletAccesPdf(CeremonieProvider provider) async {
    await provider.refreshFontsData();
    late File printFile;
    File? fichierBillet = provider.fichierBillet;

    if (provider.ceremonie!.modePage == Ceremonie.modeLast &&
        (!isNullOrEmpty(fichierBillet)) &&
        provider.ceremonie!.yaFirstPage) {
      printFile = await addQrCodeOnBillet(fichierBillet!, provider.ceremonie!,
          billet: this, isTemplate: false, fontDatas: provider.fontDatas);
    } else {
      printFile =
          await BilletAcces(provider: provider, fontDatas: provider.fontDatas)
              .getFile(
                  isTemplate: false,
                  billet: this,
                  template: BilletAcces.TEMPLATE_NADIA);
    }

    return printFile;
  }

  static Stream<QuerySnapshot> all() {
    return collection.snapshots();
  }
}
