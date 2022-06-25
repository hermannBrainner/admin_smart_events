import 'package:flutter/material.dart';

import '/outils/fonctions/fonctions.dart';
import '/outils/size_configs.dart';
import '../_models/chat.dart';
import 'chat_views_by_type/image_message.dart';
import 'chat_views_by_type/text_message.dart';

class MessageView extends StatelessWidget {
  final MessageComplet mgeComplet;
  final String idcurrentMember;
  MessageView(
      {Key? key, required this.mgeComplet, required this.idcurrentMember})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSender = mgeComplet.chatMessage.idSender == idcurrentMember;
    write(isSender, "isSender");

    SizeConfig().init(context);
    Widget messageContaint(ChatMessage message) {
      switch (message.messageType) {
        case ChatMessage.TEXTE:
          return TextMessage(
            idcurrentMember: idcurrentMember,
            voisinnageChat: mgeComplet.positionMsge,
            message: message,
            messageAsk: mgeComplet.msgeRepondu,
          );

        case ChatMessage.IMAGE:
          return ImageMessage(
            idcurrentMember: idcurrentMember,
            voisinnageChat: mgeComplet.positionMsge,
            message: message,
            messageAsk: mgeComplet.msgeRepondu,
          );
        default:
          return TextMessage(
            idcurrentMember: idcurrentMember,
            voisinnageChat: mgeComplet.positionMsge,
            message: message,
            messageAsk: mgeComplet.msgeRepondu,
          );
      }
    }

    Widget hourChat() {
      return Center(
        heightFactor: 3,
        child: Text(
          mgeComplet.chatMessage.chatTime,
        ),
      );
    }

    /* Widget derniersLecteurs( ){

      return   Consumer<ExerciceProvider>(
          builder: (context, provider, child){
            List<Adherent> adhs = provider.adherents.where((adh) => (Adherent.courrant(context).id != adh.id ) && mgeComplet.chatMessage.lastLecteurs!.cast<String>().contains(adh.id)).toList();

            return Visibility(
                visible: adhs.isNotEmpty ,

                child: manyAvatars(adhs, context, 11));
          });
    }*/

    return Column(
      children: [
        Visibility(visible: mgeComplet.displayHour, child: hourChat()),
        Padding(
          //margin: EdgeInsets.all(10),
          padding: EdgeInsets.only(
              right: SizeConfig.safeBlockHorizontal * 5.7,
              left: SizeConfig.safeBlockHorizontal * 2.85),

          child: isSender
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    messageContaint(mgeComplet.chatMessage),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    messageContaint(mgeComplet.chatMessage),
                  ],
                ),
        ),

        /*derniersLecteurs()*/
      ],
    );
  }
}
