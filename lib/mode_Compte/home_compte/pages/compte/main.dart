import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:flutter/material.dart';

import '/mode_Compte/_models/user_app.dart';
import '/outils/size_configs.dart';
import '/providers/theme/elements/horloge_ampoule.dart';
import '/providers/theme/elements/main.dart';
import '../../../messagerie/open_button.dart';
import '../ceremonies/common.dart';
import 'tiles/nom_prenom.dart';

class PageCompte extends StatefulWidget {
  final UserApp userApp;

  const PageCompte({Key? key, required this.userApp}) : super(key: key);

  @override
  _PageCompteState createState() => _PageCompteState();
}

class _PageCompteState extends State<PageCompte>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  late Animation<double> animation;
  bool cirAn = false;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
      // reverseCurve: Curves.easeInOut
    );
    animationController.forward();
  }

  switchAmpoule() {
    setState(() {
      cirAn = true;
    });

    // provider.upDateTheme(!(provider.themeData.brightness == Brightness.light));

    if (animationController.status == AnimationStatus.forward ||
        animationController.status == AnimationStatus.completed) {
      animationController.reset();
      animationController.forward();
    } else {
      animationController.forward();
    }
  }

  @override
  dispose() {
    animationController.dispose(); // you need this
    super.dispose();
  }

  Widget body(provider) {
    final double hauteurAmpoule = MediaQuery.of(context).size.height / 5.5;
    return Container(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: hauteurAmpoule * 1,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Positioned(
                            left: 10, //230.0,
                            top: 0, //40.0,
                            child: HorlogeAndAmpoule(context: context)
                                .ampoule(switchAmpoule: switchAmpoule)),
                        Positioned(
                          left: 54 * 1.1, //230.0,
                          top: 0,
                          child: Container(
                            // color: Colors.red,
                            width: 300,
                            child: nomPrenomTile(context, widget.userApp),
                          ),
                        )
                      ],
                    ),
                  ),
                  infosTile(context: context, userApp: widget.userApp),
                  openMessagerie(context),
                  deconnexionTile(context: context),
                ],
              ),
            ),
          ),
          bottomBlock()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = ThemeElements(context: context).provider;

    SizeConfig().init(context);
    var size = MediaQuery.of(context).size;
    return cirAn
        ? CircularRevealAnimation(
            centerOffset: Offset(size.height / 15, size.width / 3.5),
            animation: animation,
            child: body(provider),
          )
        : body(provider);
  }
}
