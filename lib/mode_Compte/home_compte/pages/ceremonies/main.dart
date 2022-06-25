import 'package:flutter/material.dart';

import '/mode_Compte/_models/ceremonie.dart';
import '/mode_Compte/_models/user_app.dart';
import '/outils/extensions/time.dart';
import '/outils/widgets/no_data.dart';
import '/providers/theme/elements/main.dart';
import 'bouton_flottant.dart';
import 'common.dart';
import 'liste_ceremonies.dart';

class PageCeremonies extends StatefulWidget {
  final UserApp userApp;

  const PageCeremonies({Key? key, required this.userApp}) : super(key: key);

  @override
  _PageCeremoniesState createState() => _PageCeremoniesState();
}

class _PageCeremoniesState extends State<PageCeremonies> {
  ScrollController _scrollController = new ScrollController();
  bool isFAB = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 50) {
        setState(() {
          isFAB = true;
        });
      } else {
        setState(() {
          isFAB = false;
        });
      }
    });
  }

  Widget nbreCeremonies(List<Ceremonie> ceremonies, bool isBefore) {
    var filtered = isBefore
        ? ceremonies
            .where((ceremonie) => ceremonie.dateCeremonie.isBeforeToday())
        : ceremonies
            .where((ceremonie) => !ceremonie.dateCeremonie.isBeforeToday());

    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: CircleAvatar(
        radius: 10,
        backgroundColor:
            ThemeElements(context: context, mode: ColorMode.endroit).themeColor,
        child: Text(
          "${filtered.toList().length}",
          style: ThemeElements(context: context)
              .styleText(color: ThemeElements(context: context).whichBlue),
        ),
      ),
    );
  }

  Widget tabs(List<Ceremonie> ceremonies) {
    return Container(
      height: 50,
      //
      child: TabBar(tabs: [
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "À venir",
              ),
              nbreCeremonies(ceremonies, false)
            ],
          ),
        ),
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Text("Passées"), nbreCeremonies(ceremonies, true)],
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Ceremonie>>(
        future: Ceremonie.userCeremonies(
            widget.userApp.idsCeremonies.cast<String>()),
        builder: (context, qs) {
          if (!qs.hasData) {
            return Center(
              child: Text(""),
            );
          } else {
            List<Ceremonie> allCeremonies = qs.data!;
            allCeremonies.sort(Ceremonie.compDate);
            return DefaultTabController(
                length: 2,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        tabs(allCeremonies),
                        Visibility(
                            visible: allCeremonies.isEmpty,
                            child: Expanded(
                                child: SingleChildScrollView(
                                    child: noData_Ceremonies(context)))),
                        Visibility(
                          visible: allCeremonies.isNotEmpty,
                          child: Expanded(
                            child: TabBarView(
                                children: [false, true]
                                    .map((isBefore) => listing(allCeremonies,
                                        _scrollController, context,
                                        isBefore: isBefore))
                                    .toList()),
                          ),
                        ),
                        bottomBlock()
                      ],
                    ),
                    Visibility(
                      visible: allCeremonies.isNotEmpty,
                      child: Positioned(
                          right: 20,
                          bottom: 75,
                          child: isFAB
                              ? buildFAB(context)
                              : buildExtendedFAB(context)),
                    )
                  ],
                ));
          }
        });
  }
}
