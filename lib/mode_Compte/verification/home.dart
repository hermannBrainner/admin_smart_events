import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:new_version/new_version.dart';
import 'package:provider/provider.dart';

import '/auth/drawer/main.dart';
import '/outils/constantes/colors.dart';
import '/outils/fonctions/fonctions.dart';
import '/outils/size_configs.dart';
import '/outils/widgets/main.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/strings.dart';
import 'boutonVerif.dart';
import 'update_version.dart';

class VerifMain extends StatefulWidget {
  static const String routeName = "/VerifMainView";

  @override
  _VerifMainState createState() => _VerifMainState();
}

class _VerifMainState extends State<VerifMain> {
  late AppUpdateInfo _updateInfo;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  double hauteur = 1000;

  String? inCode;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkVersion();
    }
  }

  @override
  void initState() {
    super.initState();

    context.read<CeremonieProvider>().ceremonie;
    //   _checkVersion() ;

    // checkForUpdate();
  }

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }

  void _checkVersion() async {
    var appInfos = await getAppInfos();

    final newVersion =
        NewVersion(androidId: appInfos["PACKAGE"], iOSId: appInfos["PACKAGE"]);
    // newVersion.showAlertIfNecessary(context: context);

    final status = await newVersion.getVersionStatus();

    if (status!.canUpdate) {
      showUpdateDialog(
        context: context,
        versionStatus: status,
      );
    }
  }

  // TODO : A REMETTRE RETIRE APRES LE UPGRADE
  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
        if (_updateInfo.updateAvailability ==
            UpdateAvailability.updateAvailable) {
          InAppUpdate.performImmediateUpdate()
              .catchError((e) => showSnack(e.toString()));
        }
      });
    }).catchError((e) {
      showSnack(e.toString());
    });
  }

  Widget uneCard(Color couleur, double hauteur, String contenu) {
    return Card(
        elevation: hauteur * (8 / 100),
        shape: new RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(hauteur / 10)),
        color: couleur,
        margin: new EdgeInsets.symmetric(
            horizontal: hauteur / 10, vertical: hauteur * (6 / 100)),
        child: Container(
          height: hauteur,
          width: hauteur,
          margin: new EdgeInsets.symmetric(horizontal: hauteur / 5),
          child: Center(
              child: Text(
            contenu,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black87,
                fontSize: hauteur / 7,
                fontWeight: FontWeight.bold),
          )),
        ));
  }

  ButtonStyle style() {
    Color couleurBordure = Colors.redAccent;
    Color couleurBack = Colors.grey;

    return ElevatedButton.styleFrom(
        primary: couleurBack,
        padding: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
        side: BorderSide(width: 1.1, color: couleurBordure));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      drawer: UsefulDrawer(),
      appBar: appBar(Strings.pageVerification, context),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Color.fromRGBO(221, 223, 225, 0.1),
            child: Center(
              child: btn_verif(
                  dWhite, SizeConfig.safeBlockHorizontal * 80, context),
            ),
          ),
        ),
      ),
    );
  }
}
