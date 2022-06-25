import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import '/auth/sign_in.dart';
import '/auth/splashscreen.dart';
import '/mode_Compte/_models/user_app.dart';
import '/mode_Compte/billets_acces/edition_template.dart';
import '/mode_Compte/dispositions/main.dart';
import '/mode_Compte/exports/components/print_all/display.dart';
import '/mode_Compte/exports/main.dart';
import '/mode_Compte/exports/pages/display_billet.dart';
import '/mode_Compte/home/main.dart';
import '/mode_Compte/home_compte/main.dart';
import '/mode_Compte/home_compte/pages/ceremonies/new.dart';
import '/mode_Compte/imports/main.dart';
import '/mode_Compte/installations/main.dart';
import '/mode_Compte/listes/main.dart';
import '/mode_Compte/messagerie/main.dart';
import '/mode_Compte/plan_salle/display.dart';
import '/mode_Compte/resultats_scan/main.dart';
import '/mode_Compte/stats/main.dart';
import '/mode_Compte/verification/home.dart';
import '/mode_Compte/verification/readQrCode.dart';
import '/outils/navigator_helper.dart';
import '/providers/authentification_provider.dart';
import '/providers/ceremonie.dart';
import '/providers/theme.dart';
import '/providers/user_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

  runApp(MonApp());
}

class MonApp extends StatelessWidget {
  final _observer = NavigatorObserverWithOrientation();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<UserPhone?>.value(
            initialData: null, //Utilisateur(),
            value: AuthentificationProvider().utilisateur),
        ChangeNotifierProvider(create: (_) => UserAppProvider()),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider(create: (_) => CeremonieProvider()),
      ],
      child: Consumer<ThemeProvider>(builder: (context, provider, _) {
        return MaterialApp(
          theme: provider.themeData,
          navigatorObservers: [_observer],
          localizationsDelegates: [
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate
          ],
          supportedLocales: [const Locale('en'), const Locale('fr')],
          debugShowCheckedModeBanner: false,
          routes: {
            '/': (_) => SplashScreen(),
            Connexion.routeName: (_) => Connexion(),
            SplashScreen.routeName: (_) => SplashScreen(),
            NewCeremonie.routeName: (_) => NewCeremonie()
          },
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case HomeCompte.routeName:
                {
                  return MaterialPageRoute(
                      builder: (_) {
                        return HomeCompte();
                      },
                      settings: rotationSettings(
                          settings, OrientationEcran.PORTRAIT));
                }

              case DisplayPdf.routeName:
                {
                  final args = settings.arguments as List<dynamic>;
                  return MaterialPageRoute(
                      settings:
                          rotationSettings(settings, OrientationEcran.PORTRAIT),
                      builder: (_) {
                        return DisplayPdf(fichier: args[0]);
                      });
                }
              case MessagesScreen.routeName:
                {
                  return MaterialPageRoute(builder: (_) {
                    return MessagesScreen();
                  });
                }

              case DisplayReport.routeName:
                {
                  final args = settings.arguments as List<dynamic>;
                  return MaterialPageRoute(
                      settings:
                          rotationSettings(settings, OrientationEcran.PORTRAIT),
                      builder: (_) {
                        return DisplayReport(fichier: args[0]);
                      });
                }

              case DisplayBillet.routeName:
                {
                  final args = settings.arguments as List<dynamic>;
                  return MaterialPageRoute(
                      settings:
                          rotationSettings(settings, OrientationEcran.PORTRAIT),
                      builder: (_) {
                        return DisplayBillet(
                          fichier: args[0],
                          billet: args[1],
                        );
                      });
                }

              case VerifMain.routeName:
                {
                  return MaterialPageRoute(
                      builder: (_) {
                        return VerifMain();
                      },
                      settings: rotationSettings(
                          settings, OrientationEcran.PORTRAIT));
                }
              case ParametresMainView.routeName:
                {
                  return MaterialPageRoute(
                      builder: (_) {
                        return ParametresMainView();
                      },
                      settings: rotationSettings(
                          settings, OrientationEcran.PORTRAIT));
                }
              case ImportsMainView.routeName:
                {
                  return MaterialPageRoute(
                      builder: (_) {
                        return ImportsMainView();
                      },
                      settings: rotationSettings(
                          settings, OrientationEcran.PORTRAIT));
                }

              case ExportsMainView.routeName:
                {
                  return MaterialPageRoute(
                      builder: (_) {
                        return ExportsMainView();
                      },
                      settings: rotationSettings(
                          settings, OrientationEcran.PORTRAIT));
                }

              case Dispositions.routeName:
                {
                  return MaterialPageRoute(
                      builder: (_) {
                        return Dispositions();
                      },
                      settings: rotationSettings(
                          settings, OrientationEcran.PORTRAIT));
                }

              case ReadQrCode.routeName:
                {
                  return MaterialPageRoute(
                      builder: (_) {
                        return ReadQrCode();
                      },
                      settings: rotationSettings(
                          settings, OrientationEcran.PORTRAIT));
                }

              case ListesMainView.routeName:
                {
                  return MaterialPageRoute(
                      builder: (_) {
                        return ListesMainView();
                      },
                      settings: rotationSettings(
                          settings, OrientationEcran.PORTRAIT));
                }

              case ResultatsMainView.routeName:
                {
                  final idBillet = settings.arguments as String;
                  //  String idBillet = settings.arguments;
                  return MaterialPageRoute(
                      builder: (_) {
                        return ResultatsMainView(qrCode: idBillet);
                      },
                      settings: rotationSettings(
                          settings, OrientationEcran.PORTRAIT));
                }

              case InstallationsMainView.routeName:
                {
                  return MaterialPageRoute(
                      builder: (_) {
                        return InstallationsMainView();
                      },
                      settings: rotationSettings(
                          settings, OrientationEcran.PORTRAIT));
                }

              case StatsMainView.routeName:
                {
                  return MaterialPageRoute(
                      builder: (_) {
                        return StatsMainView();
                      },
                      settings: rotationSettings(
                          settings, OrientationEcran.PORTRAIT));
                }
              case EditionTemplate.routeName:
                {
                  final currentTemp = settings.arguments as String;

                  return MaterialPageRoute(
                      builder: (_) {
                        return EditionTemplate(
                          templateCourant: currentTemp,
                        );
                      },
                      settings: rotationSettings(
                          settings, OrientationEcran.PORTRAIT));
                }
            }
          },
        );
      }),
    );
  }
}
