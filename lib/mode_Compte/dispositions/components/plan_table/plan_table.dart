import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/mode_Compte/_controllers/ceremonie.dart';
import '/mode_Compte/_models/table.dart';
import '/outils/extensions/string.dart';
import '/outils/fonctions/fonctions.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/primary_box_decoration.dart';
import '../search_bar.dart';
import 'custom_rect_tween.dart';

const String _heroAddTodo = 'add-todo-hero';

class PlanTable extends StatefulWidget {
  final TableInvite tableInvite;

  final CeremonieProvider provider;

  PlanTable({required this.tableInvite, required this.provider});

  @override
  State<PlanTable> createState() => _PlanTableState();
}

class _PlanTableState extends State<PlanTable> {
  bool displayCroix = true;

  switchDisplay() {
    setState(() {
      displayCroix = !displayCroix;
    });
  }

  Widget titre(context) {
    return CustomPaint(
        painter: toileFond(
            hauteur: 100,
            context: context,
            couleur: widget.tableInvite.couleur.couleurFromHex()),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: Center(
              child: Text(
            widget.tableInvite.nom.toUpperCase(),
            style: ThemeElements(context: context).styleText(
              color: blackOrWhite_formLuminance(
                  widget.tableInvite.couleur.couleurFromHex()),
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          )),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Hero(
          tag: _heroAddTodo,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin!, end: end!);
          },
          child: Material(
            color: ThemeElements(context: context).themeColorSecondary,
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            )),
            child: Container(
              decoration: BoxDecorationPrimary(context,
                  topRigth: 0, topLeft: 0, bottomRigth: 32, bottomLeft: 32),
              width: 600,
              height: 500,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  titre(context),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: widget.tableInvite
                                .getBillets(widget.provider)
                                .length,
                            itemBuilder: (context, index) {
                              var billet = widget.tableInvite
                                  .getBillets(widget.provider)[index];

                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      ThemeElements(context: context)
                                          .whichBlue
                                          .withOpacity(0.7),
                                  child: Text(
                                    forcerAvec0_devant(
                                        billet.nbrePersonnes.toString()),
                                    style: ThemeElements(context: context)
                                        .styleText(
                                            color:
                                                ThemeElements(context: context)
                                                    .themeColor
                                                    .withOpacity(0.7)),
                                  ),
                                ),
                                trailing: Visibility(
                                  visible: displayCroix,
                                  child: CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.red,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          size: 15,
                                        ),
                                        onPressed: () async {
                                          switchDisplay();
                                          await CeremonieCtrl.disAssignBillet(
                                              provider: widget.provider,
                                              billet: billet);

                                          await context
                                              .read<CeremonieProvider>()
                                              .refresh(widget.provider);

                                          Navigator.pop(context);
                                        },
                                      )),
                                ),
                                title: Text(
                                  billet.nom,
                                  style: ThemeElements(context: context)
                                      .styleText(fontSize: 15),
                                ),
                              );
                            }),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
