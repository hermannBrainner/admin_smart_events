import 'package:flutter/material.dart';

import '/outils/size_configs.dart';
import '/providers/theme/elements/main.dart';

goToPremium(BuildContext context, int nbreRestant) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 1.0),
    child: Card(
        color: const Color.fromRGBO(240, 255, 255, .9),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        elevation: 3,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          height: SizeConfig.safeBlockVertical * 15,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.warning_amber_outlined,
                    color: Colors.orangeAccent,
                    size: SizeConfig.blockSizeVertical * 5,
                  ),
                  //  adherent.avatar(),
                  SizedBox(width: SizeConfig.blockSizeHorizontal * 5),
                  Expanded(
                    child: Text(
                      "$nbreRestant Billets restants à selectionner",
                      style: ThemeElements(context: context).styleText(
                          fontSize: SizeConfig.safeBlockVertical * 2,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                      maxLines: 4,
                    ),
                  )
                ],
              ),

              //  SizedBox( height: SizeConfig.blockSizeVertical * 2,),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(SizeConfig.blockSizeHorizontal * 80, 40),
                    primary: Colors.orangeAccent),
                onPressed: () {},
                child: Text("Passer au PREMIUM"),
              )
            ],
          ),
        )),
  );
}

Widget texteSelection(BuildContext context,
    {required int nbre, required Function removeAll}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      InkWell(
          onTap: () {
            removeAll();
          },
          child: Icon(
            Icons.clear,
            size: SizeConfig.safeBlockVertical * 5,
          )),
      Text(
        "$nbre Billets sélectonnée(s)",
        style: ThemeElements(context: context).styleText(
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.safeBlockVertical * 2),
      )
    ],
  );
}

/*
Widget barRecherche(TextEditingController _searchview,
    {required Function cleanSearch, required Function submitSearch}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 20),
    width: 400,
    height: SizeConfig.safeBlockVertical * 6,
    color: dWhite,
    child: Center(
      child: TextField(
        textInputAction: TextInputAction.search,
        onSubmitted: (value) {
          submitSearch();
        },
        controller: _searchview,
        decoration: InputDecoration(
          hintText: "Nom d'un invité ....",
          prefixIcon: Icon(Icons.search),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              cleanSearch();
            },
          ),
        ),
      ),
    ),
  );
}
*/
