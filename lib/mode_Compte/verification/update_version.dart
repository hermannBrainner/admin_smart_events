import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_version/new_version.dart';
import 'package:url_launcher/url_launcher.dart';

import '/outils/constantes/strings.dart';

void showUpdateDialog({
  required BuildContext context,
  required VersionStatus versionStatus,
  String dismissButtonText = 'Maybe Later',
  VoidCallback? dismissAction,
}) async {
  bool allowDismissal = false;
  String dialogTitle = "Version " + versionStatus.storeVersion + " disponible";
  final dialogTitleWidget = Text(dialogTitle);
  final dialogTextWidget = Text(
    " Une nouvelle version est disponible !!!" +
        newLine +
        newLine +
        " Vous devez mettre l'application à jour pour continuer à l'utiliser" +
        newLine,
  );

  final boutonUpdate = Container(
    width: 100,
    height: 50,
    alignment: Alignment.centerLeft,
    child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.green,
            padding: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
            side: BorderSide(width: 1.1, color: Colors.lightGreen)),
        onPressed: () {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
        },
        child:
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Container(
              // padding: const EdgeInsets.symmetric( horizontal: 0.0),
              // color: Colors.yellow,
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(left: 0, top: 0),
              height: 50,
              width: 38,
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 10,
                      color: Colors.lightGreen,
                    ),
                    Center(
                        child: Icon(Icons.play_circle_fill_rounded,
                            color: Colors.black))
                  ])),
          Expanded(
              child: Center(
            child: Text(
              "Mettre à jour",
              style: TextStyle(
                fontSize: 10,
              ),
            ),
          ))
        ])),
  );

  // final updateButtonTextWidget = Text(updateButtonText);
  final updateAction = () {
    _launchAppStore(versionStatus.appStoreLink);
    if (allowDismissal) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  };

  List<Widget> actions = [
    Container(
      width: 150,
      height: 50,
      alignment: Alignment.centerLeft,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
              side: BorderSide(width: 1.1, color: Colors.lightGreen)),
          onPressed: () {
            updateAction();
          },
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                    // padding: const EdgeInsets.symmetric( horizontal: 0.0),
                    // color: Colors.yellow,
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 0, top: 0),
                    height: 50,
                    width: 40,
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 15,
                            color: Colors.lightGreen,
                          ),
                          Center(
                              child: Icon(Icons.play_circle_fill_rounded,
                                  color: Colors.black))
                        ])),
                Expanded(
                    child: Center(
                  child: Text(
                    "Mettre à jour",
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ))
              ])),
    )
    /* Platform.isAndroid
        ? TextButton(
      child: updateButtonTextWidget,
      onPressed: updateAction,
    ) */
  ];

  if (allowDismissal) {
    final dismissButtonTextWidget = Text(dismissButtonText);
    dismissAction =
        dismissAction ?? () => Navigator.of(context, rootNavigator: true).pop();
    actions.add(
      Platform.isAndroid
          ? TextButton(
              child: dismissButtonTextWidget,
              onPressed: dismissAction,
            )
          : CupertinoDialogAction(
              child: dismissButtonTextWidget,
              onPressed: dismissAction,
            ),
    );
  }

  showDialog(
    context: context,
    barrierDismissible: allowDismissal,
    builder: (BuildContext context) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      return WillPopScope(
          child: Platform.isAndroid
              ? AlertDialog(
                  title: dialogTitleWidget,
                  content: dialogTextWidget,
                  actions: actions,
                )
              : CupertinoAlertDialog(
                  title: dialogTitleWidget,
                  content: dialogTextWidget,
                  actions: actions,
                ),
          onWillPop: () => Future.value(allowDismissal));
    },
  );
}

void _launchAppStore(String appStoreLink) async {
  debugPrint(appStoreLink);
  if (await canLaunch(appStoreLink)) {
    await launch(appStoreLink);
  } else {
    throw 'Could not launch appStoreLink';
  }
}
