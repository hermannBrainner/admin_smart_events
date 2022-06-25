/*
Container bandeauBtns(Ceremonie c){

  Widget wA = btnAjouter();
  Widget wE = btnEditer() ;
  Widget wAf = btnAffecter() ;
  Widget wS = btnSupprimer() ;

  List<Widget> all = [ wE, wAf,wS,wA];

  if(!c.withZones)
    all.remove(wAf);

  return  Container(
    padding: EdgeInsets.symmetric(vertical: 10,
        horizontal: 10),

    height: 80,
    color: couleurTheme,

    child: Row(

      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: all,
    ),

  );

}*/
