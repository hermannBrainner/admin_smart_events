import 'package:flutter/material.dart';

import '/outils/size_configs.dart';
import '/providers/theme.dart';
import '/providers/theme/elements/main.dart';
import 'sign_in.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  ThemeProvider themeChangeProvider = new ThemeProvider();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Spacer(flex: 2),
            Image.asset("assets/images/welcome_image.png"),
            Spacer(flex: 3),
            Text(
              "Bienvenue sur notre app de \nGestions d'invités",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ThemeElements(context: context, mode: ColorMode.envers)
                      .themeColor),
            ),
            Spacer(),
            Text(
              "Ayons des avant, pendant et après \ncérémonie 100% zen!!!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: ThemeElements(context: context, mode: ColorMode.envers)
                      .themeColor
                      .withOpacity(0.64)),
            ),
            Spacer(flex: 2),
            Padding(
              padding:
                  EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 7),
              child: FittedBox(
                child: TextButton(
                    onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Connexion(),
                          ),
                        ),
                    child: Row(
                      children: [
                        Text(
                          "Skip",
                          style: ThemeElements(context: context).styleText(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: ThemeElements(
                                    context: context, mode: ColorMode.envers)
                                .themeColor,
                          ),
                        ),
                        SizedBox(width: 20 / 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                          color: ThemeElements(
                                  context: context, mode: ColorMode.envers)
                              .themeColor,
                        )
                      ],
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
