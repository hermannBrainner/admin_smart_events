import 'dart:io';
import 'dart:math' as math;
import 'dart:math';

import 'package:another_flushbar/flushbar.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:random_color/random_color.dart';

import '/auth/drawer/main.dart';
import '/auth/sign_out.dart';
import '/providers/theme/elements/logo.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/strings.dart';
import '../constantes/colors.dart';
import '../fonctions/fonctions.dart';
import '../size_configs.dart';

Widget nbreAlertW(BuildContext context, int nbreAlert) {
  return Container(
    padding: EdgeInsets.all(1),
    decoration: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(12),
    ),
    constraints: const BoxConstraints(
      minWidth: 18,
      minHeight: 18,
    ),
    child: Center(
      child: Text(
        (nbreAlert).toString(),
        style: ThemeElements(context: context).styleText(
          color: dWhite,
          fontSize: 8,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );
}

Widget customSearchInputText(
    {double hauteur = 40,
    required String hintText,
    required Function fctOnSubmit,
    required TextEditingController searchview,
    required Function fctOnClear}) {
  return Container(
    width: double.infinity,
    height: hauteur,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(hauteur / 2)),
        color: dWhite),
    child: Center(
      child: TextField(
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(color: dBlackLeger),
        textInputAction: TextInputAction.search,
        onSubmitted: (value) {
          fctOnSubmit();
        },
        controller: searchview,
        decoration: InputDecoration(
          isCollapsed: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(hauteur / 2)),
          hintText: hintText,
          hintStyle: TextStyle(color: dBlackLeger),
          prefixIcon: Icon(Icons.search, color: dBlack),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.clear,
              color: dBlack,
            ),
            onPressed: () {
              fctOnClear();
            },
          ),
        ),
      ),
    ),
  );
}

Future<void> writeToFile(ByteData data, String path) async {
  final buffer = data.buffer;
  await File(path)
      .writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
}

infoBulle(String texte, BuildContext context, {Color? couleurTexte}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: couleurJauneMoutardeClair, width: 2.0)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(
          Icons.info,
          color: ThemeElements(context: context).whichBlue,
        ),
        SizedBox(width: SizeConfig.safeBlockHorizontal * 3),
        Expanded(
            child: Text(
          texte,
          textAlign: TextAlign.justify,
          overflow: TextOverflow.clip,
          maxLines: 6,
          style: TextStyle(
              color: couleurTexte ??
                  ThemeElements(context: context, mode: ColorMode.envers)
                      .themeColor,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
              fontSize: SizeConfig.safeBlockHorizontal * 3),
        ))
      ],
    ),
  );
}

void showFlushbar(
    BuildContext context, bool isGood, String titre, String message,
    {FlushbarPosition position = FlushbarPosition.BOTTOM, int seconds = 5}) {
  List<Color> couleurs = isGood
      ? [Colors.green.shade800, Colors.greenAccent.shade700]
      : [Colors.red.shade800, Colors.redAccent.shade700];

  Flushbar(
    flushbarPosition: position,

    padding: EdgeInsets.all(10),
    // borderRadius: 8 ,
    backgroundGradient: LinearGradient(
      colors: couleurs,
      stops: [0.6, 1],
    ),
    boxShadows: [
      BoxShadow(
        color: Colors.black45,
        offset: Offset(3, 3),
        blurRadius: 3,
      ),
    ],

    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    duration: Duration(seconds: seconds),
    forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
    title: !isNullOrEmpty(titre) ? titre : null,
    message: message,
  ).show(
    context,
  );
}

RoundedRectangleBorder angleArrondi(double rayon) {
  return RoundedRectangleBorder(borderRadius: BorderRadius.circular(rayon));
}

Widget getLoadingWidget(BuildContext context,
    {Color? couleur, double taille = 50.0}) {
  return Center(child: Logo(context: context).logo);
}

Widget _getLoadingWidget({Color? couleur, double taille = 50.0}) {
  Random rnd = new Random();
  RandomColor _randomColor = RandomColor();

  if (isNullOrEmpty(couleur)) {
    couleur =
        _randomColor.randomColor(colorBrightness: ColorBrightness.primary);
  }

  Duration d = Duration(seconds: 3);

  List<Widget> liste = [
    SpinKitFadingFour(
      color: couleur,
      size: taille,
      duration: d,
    ),
    SpinKitFoldingCube(color: couleur, size: taille, duration: d),
    SpinKitRotatingCircle(color: couleur, size: taille, duration: d),
    SpinKitSpinningCircle(color: couleur, size: taille, duration: d),
    SpinKitCubeGrid(color: couleur, size: taille, duration: d),
    SpinKitChasingDots(color: couleur, size: taille, duration: d),
    //SpinKitPouringHourglass(color: couleur, size: taille, duration: d)
  ];

  return Center(child: liste[rnd.nextInt(liste.length)]);
}

Widget flecheExpension() {
  return ExpandableIcon(
    theme: const ExpandableThemeData(
      expandIcon: Icons.arrow_right,
      collapseIcon: Icons.arrow_drop_down,
      iconColor: dWhite,
      iconSize: 28.0,
      iconRotationAngle: math.pi / 2,
      iconPadding: EdgeInsets.only(right: 5),
      hasIcon: false,
    ),
  );
}

AppBar appBar(String titre, BuildContext context,
    {TabBar? bottom, bool displayDcnx = false, Widget? actionWidget}) {
  if (bottom == null) {
    return AppBar(
      leading: menuIcon(context),
      // backgroundColor: couleurTheme,
      title: Text(titre),
      actions: [
        if (actionWidget != null) actionWidget,
        Visibility(visible: displayDcnx, child: btnDeconnexion(context))
      ],
    );
  } else {
    return AppBar(
      leading: menuIcon(context),
      //   backgroundColor: couleurTheme,
      title: Text(titre),
      bottom: bottom,
      actions: [
        if (actionWidget != null) actionWidget,
        Visibility(visible: displayDcnx, child: btnDeconnexion(context))
      ],
    );
  }
}

IconButton btnDeconnexion(BuildContext context) {
  return IconButton(
    icon: Icon(
      Icons.exit_to_app_sharp,
      size: 30,
      color: Colors.black54,
    ),
    onPressed: () => showDialog(
        context: context, builder: (context) => boiteDeDialogue(context)),
  );
}

Widget sizedCustom({required display, required double coef}) {
  return Visibility(
      visible: display,
      child: SizedBox(height: SizeConfig.safeBlockVertical * coef));
}

Widget boiteDeDialogue(BuildContext context, {bool signOutComplete = false}) {
  return SimpleDialog(
    contentPadding: EdgeInsets.zero,
    children: <Widget>[
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 10.0),
            Wrap(
              children: <Widget>[
                FlatButton(
                  child: Text('DECONNEXION'),
                  color: ThemeElements(context: context).whichBlue,
                  onPressed: () async {
                    await signOut(context, signOutComplete);
                  },
                ),
                FlatButton(
                    child: const Text(Strings.cancel),
                    onPressed: () async {
                      Navigator.pop(context);
                    })
              ],
            )
          ],
        ),
      )
    ],
  );
}
