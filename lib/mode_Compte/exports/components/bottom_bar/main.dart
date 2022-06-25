import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/outils/custom_bottom_bar.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/elements/main.dart';
import '../modal_bottom.dart';
import 'bouton.dart';

class BottomBarExports extends StatelessWidget {
  final double size;

  final Function selectTypePrint;

  final bool displayGo;

  final Function fctStartPrint;
  final Function fctSwitchDisplayImportPdf;

  const BottomBarExports({
    required this.fctSwitchDisplayImportPdf,
    required this.displayGo,
    required this.fctStartPrint,
    required this.selectTypePrint,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: 80,
      child: Stack(
        children: [
          CustomPaint(
            size: Size(size, 80),
            painter: BNBCustomPainter(context: context),
          ),
          Center(
            heightFactor: 0.6,
            child: Consumer<CeremonieProvider>(
                builder: (context, provider, child) {
              return FloatingActionButton(
                  backgroundColor: this.displayGo
                      ? Colors.green
                      : ThemeElements(context: context).whichBlue,
                  child: this.displayGo
                      ? Icon(
                          Icons.play_arrow,
                          color: ThemeElements(
                                  context: context, mode: ColorMode.envers)
                              .themeColor,
                        )
                      : Icon(
                          Icons.print,
                          color: ThemeElements(
                                  context: context, mode: ColorMode.envers)
                              .themeColor,
                        ),
                  elevation: 0.1,
                  onPressed: () async {
                    if (this.displayGo) {
                      await fctStartPrint(provider.ceremonie!);
                    } else {
                      modalBtnImpt(context, this.selectTypePrint);
                    }
                  });
            }),
          ),
          Container(
            width: size,
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BottomButton(
                  type: TYPE.addPages,
                  size: size * 0.1,
                  auClick: this.fctSwitchDisplayImportPdf,
                ),
                Container(width: size * 0.2),
                BottomButton(
                    type: TYPE.editBillet,
                    size: size * 0.1,
                    auClick: this.fctSwitchDisplayImportPdf),
              ],
            ),
          )
        ],
      ),
    );
  }
}
