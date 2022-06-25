import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '/mode_Compte/_controllers/billet.dart';
import '/outils/fonctions/dates.dart';
import '/outils/fonctions/fonctions.dart';
import '/outils/widgets/main.dart';
import '../resultats_scan/main.dart';

class ReadQrCode extends StatefulWidget {
  static const String routeName = "/ReadQrCodeView";

  const ReadQrCode({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ReadQrCodeState();
}

class _ReadQrCodeState extends State<ReadQrCode> {
  String? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  relanceCamera() {
    setState(() {
      wait(nbreSeconde: 10);
      controller!.resumeCamera();
    });
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (!isNullOrEmpty(controller)) {
      if (Platform.isAndroid) {
        controller!.pauseCamera();
      } else if (Platform.isIOS) {
        controller!.resumeCamera();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: <Widget>[
          Expanded(flex: 5, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: Container(
              //  color : Colors.red,
              margin: const EdgeInsets.all(8),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(196, 170, 109, 1),
                    shadowColor: Colors.transparent,
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(24),
                  ),
                  onPressed: () async {
                    await controller?.toggleFlash();
                    setState(() {});
                  },
                  child: FutureBuilder(
                    future: controller?.getFlashStatus(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return boolValue(snapshot.data)
                            ? Icon(Icons.flash_on)
                            : Icon(Icons.flash_off);
                      } else {
                        return Icon(Icons.label_important_rounded);
                      }
                    },
                  )),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 500.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        controller.pauseCamera();
        result = scanData.code!;
        var resultControl = BilletCtrl().controllerBillet(result!.trim());
        wait();
        FlutterBeep.playSysSound(AndroidSoundIDs.TONE_CDMA_SIGNAL_OFF);
        if (resultControl[0]) {
          Navigator.pushNamedAndRemoveUntil(context,
              ResultatsMainView.routeName, (Route<dynamic> route) => false,
              arguments: resultControl[1]);
        } else {
          showFlushbar(
              context, false, "", "Billet non reconnu pour cet évènement");

          relanceCamera();

          //  Navigator.pop(context);
        }
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
