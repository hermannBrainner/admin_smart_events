import 'package:flutter/material.dart';

import '/outils/size_configs.dart';
import '../_models/chat.dart';
import 'chat_views_by_type/image_message.dart';
import 'chat_views_by_type/text_message.dart';

class MessageView extends StatelessWidget {
  final MessageComplet mgeComplet;
  final String idSender;
  MessageView(
      {Key? key, required this.mgeComplet, required this.idSender})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSender = mgeComplet.chatMessage.idSender == idSender;


    SizeConfig().init(context);
    Widget messageContaint(ChatMessage message) {
      switch (message.messageType) {
        case ChatMessage.TEXTE:
          return TextMessage(
            idSender: idSender,
            voisinnageChat: mgeComplet.positionMsge,
            message: message,
            messageAsk: mgeComplet.msgeRepondu,
          );

        case ChatMessage.IMAGE:
          return ImageMessage(
            idSender: idSender,
            voisinnageChat: mgeComplet.positionMsge,
            message: message,
            messageAsk: mgeComplet.msgeRepondu,
          );
        default:
          return TextMessage(
            idSender: idSender,
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


    return Column(
      children: [
        Visibility(visible: mgeComplet.displayHour, child: hourChat()),
        Padding(
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

      ],
    );
  }
}
