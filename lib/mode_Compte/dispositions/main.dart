import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/auth/drawer/main.dart';
import '/outils/widgets/main.dart';
import '/providers/ceremonie.dart';
import '/providers/theme/elements/main.dart';
import '/providers/theme/strings.dart';
import 'components/haut_de_pages.dart';
import 'menuContextuels.dart';

class Dispositions extends StatefulWidget {
  static const String routeName = "/DispositionsMainView";

  @override
  _DispositionsState createState() => _DispositionsState();
}

class _DispositionsState extends State<Dispositions> {
  int nbreElementSelected = 0;

  editNbreSelected(int value) {
    setState(() {
      nbreElementSelected = value;
    });
  }

  Widget action(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          radius: 23,
          backgroundColor: ThemeElements(context: context).whichBlue,
          child: IconButton(
            icon: Icon(Icons.expand_more,
                size: 23,
                color: ThemeElements(context: context, mode: ColorMode.endroit)
                    .themeColor),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => MenucontextDispos(),
            ),
          ),
        ));
  }

  AppBar displayAppbar(CeremonieProvider provider) {
    if (nbreElementSelected == 0) {
      return appBar(Strings.pageDispositions, context,
          bottom: makeTabBar(context, provider), actionWidget: action(context));
    } else {
      return AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: ThemeElements(context: context, mode: ColorMode.envers)
                .themeColor,
          ),
          onPressed: () {
            editNbreSelected(0);
          },
        ),
        title: Text(nbreElementSelected == 1
            ? "1 élément sélectionné"
            : "$nbreElementSelected éléments sélectionnés"),
        bottom: makeTabBar(context, provider),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    nbreElementSelected = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CeremonieProvider>(builder: (context, provider, child) {
      return DefaultTabController(
          length: nbreTabs(provider.ceremonie!),
          child: Scaffold(
              drawer: UsefulDrawer(),
              appBar: displayAppbar(provider),
              body: makeTabBarview(provider, editNbreSelected)));
    });
  }
}
