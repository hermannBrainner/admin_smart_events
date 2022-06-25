import 'package:flutter/material.dart';

import '/outils/size_configs.dart';
import '/providers/theme/elements/logo.dart';
import 'passerelle.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "/passerelle";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateTo();
  }

  _navigateTo() async {
    await Future.delayed(Duration(seconds: 3), () async {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Passerelle()));
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      body: Logo(context: context)
          .withTexte(fontSize: SizeConfig.blockSizeHorizontal * 10),
    );
  }
}
