import 'package:flutter/material.dart';

import '/mode_Compte/_models/user_app.dart';
import '/mode_Compte/home_compte/pages/ceremonies/common.dart';
import '/outils/size_configs.dart';
import 'how_to_do.dart';
import 'listFilleuls.dart';

class PageParrainage extends StatefulWidget {
  final UserApp userApp;

  const PageParrainage({Key? key, required this.userApp}) : super(key: key);

  @override
  _PageParrainageState createState() => _PageParrainageState();
}

class _PageParrainageState extends State<PageParrainage> {
  bool displayHowTodo = true;
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

    displayHowTodo = (widget.userApp.idsFilleuls.length == 0);
  }

  switchPage() {
    setState(() {
      displayHowTodo = !displayHowTodo;
    });
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
              child: displayHowTodo
                  ? HowToDo(
                      context,
                      widget.userApp,
                    )
                  : listeFilleuls(context, widget.userApp, _scrollController,
                      isFAB, switchPage)),
          bottomBlock()
        ],
      ),
      width: double.infinity,
      height: SizeConfig.safeBlockVertical *
          81, //SizeConfig.safeBlockVertical * 50,
      //  color: Colors.red,
    );
  }
}
