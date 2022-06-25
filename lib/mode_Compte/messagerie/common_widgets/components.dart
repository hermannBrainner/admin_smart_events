import 'package:flutter/material.dart';

import '/mode_Compte/_models/chat.dart';
import '/outils/constantes/colors.dart';
import '/outils/constantes/numbers.dart';

/*Widget chapeauMessage(
    ChatMessage messageReply, ChatMessage messageAsk, BuildContext context, String idcurrentMember) {
  */ /*
     avec le Visibility, tout est quand même lu, du coup on se doit de mettre un contenu à  messageAsk
     Il ne doit pas être null

     */ /*
  messageAsk = (messageAsk == null) ? messageReply : messageAsk;

  bool iAmAsker = messageAsk.idSender == idcurrentMember;
  bool iAmReplyer = messageReply.idSender == idcurrentMember;

  bool mettreIcon = false;
  bool mettreTexte = false;

  return Consumer<UserAppProvider>(
      builder: (context, provider, child) {

        */ /*Adherent adhAsker = provider.adherents.firstWhere((element) => element.id==messageAsk.idSender);
        Adherent adhReplyer = provider.adherents.firstWhere((element) => element.id==messageReply.idSender);
        String prenomAsker = adhAsker.prenom();
        String prenomReplyer = adhReplyer.prenom();*/ /*

        String texteChapeau = "";

        if (messageReply.isREponse) {
          mettreIcon = true;
          mettreTexte = true;
          if (iAmReplyer) {
           */ /* prenomAsker = (messageAsk.idSender == messageReply.idSender ) ? "vous même" : prenomAsker ;

*/ /*
            texteChapeau = "Vous avez répondu à " + (provider.userApp?.prenom??"Hermann");
          } else if (iAmAsker) {

            texteChapeau = (provider.userApp?.prenom??"Hermann") + " vous a répondu";
          } else {
           // prenomAsker = (messageAsk.idSender == messageReply.idSender ) ? "soi-même" : prenomAsker ;
            texteChapeau = (provider.userApp?.prenom??"Hermann") + " a répondu à " + (provider.userApp?.prenom??"Hermann");
          }
        } else if (!iAmReplyer) {
          mettreTexte = true;
          texteChapeau = (provider.userApp?.prenom??"Hermann");
        }

        return Container(
            margin: EdgeInsets.only(
              top: SizeConfig.safeBlockVertical *
                  1, */ /* bottom: SizeConfig.safeBlockVertical * 3*/ /*
            ), //EdgeInsets.all(10),
            alignment: Alignment.bottomCenter,
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Visibility(
                  visible: mettreIcon,
                  child: Icon(
                    Icons.reply,
                    color: Color.fromRGBO(135, 137, 140, 1),
                  )),
              Visibility(
                  visible: mettreTexte,
                  child: Text(texteChapeau,
                      style: TextStyle(
                        fontSize: SizeConfig.safeBlockVertical * 1.6,
                        color: Color.fromRGBO(135, 137, 140, 1),
                      ))),
              Visibility(
                  visible: !(mettreTexte || mettreIcon),
                  child: SizedBox(
                    height: SizeConfig.safeBlockVertical * 1.6,
                  ))
            ]));





         });


}*/

BoxDecoration decoMsgeQuestion() {
  return BoxDecoration(
    color: Color.fromRGBO(240, 242, 245, 1),
    borderRadius: BorderRadius.only(
        topLeft: rayonMax_Chat,
        topRight: rayonMax_Chat,
        bottomLeft: rayonZero_Chat,
        bottomRight: rayonZero_Chat),
  );
}

BoxDecoration quelleDecoration(
  bool isSender,
  NEIGHBORHOOD voisinnageChat,
) {
  Color couleur = isSender ? couleurSendChat : couleurReceiveChat;

  /* if (isReponse) {
    return BoxDecoration(
      color: couleur,
      borderRadius: BorderRadius.only(
          bottomLeft: rayonMax_Chat,
          bottomRight:  rayonMax_Chat,
          topLeft: isSender ? rayonMax_Chat  : rayonZero_Chat,
          topRight: !isSender ? rayonMax_Chat  : rayonZero_Chat),
    );
  } else*/
  if (voisinnageChat == NEIGHBORHOOD.UNIQUE) {
    return BoxDecoration(
      color: couleur,
      borderRadius: BorderRadius.all(rayonMax_Chat),
    );
  } else {
    if (isSender) {
      var topDroit = rayonMin_Chat;
      var bottomDroit = rayonMin_Chat;

      if (voisinnageChat == NEIGHBORHOOD.DEBUT) {
        topDroit = rayonMax_Chat;
      } else if (voisinnageChat == NEIGHBORHOOD.FIN) {
        bottomDroit = rayonMax_Chat;
      }
      return BoxDecoration(
        color: couleur,
        borderRadius: BorderRadius.only(
            topLeft: rayonMax_Chat,
            bottomLeft: rayonMax_Chat,
            topRight: topDroit,
            bottomRight: bottomDroit),
      );
    } else {
      var topLeft = rayonMin_Chat;
      var bottomLeft = rayonMin_Chat;

      if (voisinnageChat == NEIGHBORHOOD.DEBUT) {
        topLeft = rayonMax_Chat;
      } else if (voisinnageChat == NEIGHBORHOOD.FIN) {
        bottomLeft = rayonMax_Chat;
      }

      return BoxDecoration(
        color: couleur,
        borderRadius: BorderRadius.only(
            topLeft: topLeft,
            bottomLeft: bottomLeft,
            topRight: rayonMax_Chat,
            bottomRight: rayonMax_Chat),
      );
    }
  }
}
