import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '/outils/get_permissions.dart';
import '/outils/widgets/main.dart';
import 'readQrCode.dart';

Widget btn_verif(Color couleur, double hauteur, BuildContext context) {
  Color couleurFond = Color.fromRGBO(241, 242, 244, 1);
  Color couleurQrCode = Color.fromRGBO(197, 179, 131, 1);
  return InkWell(
    onTap: () async {
      PermissionStatus status = await getCameraPermission();

      if (status.isGranted) {
        Navigator.pushNamed(context, ReadQrCode.routeName);
      } else {
        showFlushbar(context, false, "", status.toString());
      }
    },
    child: Card(
        elevation: hauteur / 50,
        shape: RoundedRectangleBorder(
            side: BorderSide(width: hauteur / 200, color: couleurQrCode),
            borderRadius: BorderRadius.circular(hauteur / 20)),
        color: couleurFond,
        margin: new EdgeInsets.symmetric(
            horizontal: hauteur * 0.05, vertical: hauteur * 0.06),
        child: Container(
          height: hauteur / 1.5,
          width: hauteur,
          margin: new EdgeInsets.symmetric(horizontal: hauteur / 5),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              Icons.qr_code_scanner,
              size: hauteur / 3,
              color: couleurQrCode,
            ),
            SizedBox(height: hauteur / 15),
            Text(
              "Scanner le QR Code",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color.fromRGBO(9, 33, 89, 0.7),
                  fontSize: hauteur / 12,
                  fontWeight: FontWeight.bold),
            )
          ]),
        )),
  );
}
