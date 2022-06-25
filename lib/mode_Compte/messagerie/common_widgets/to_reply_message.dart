import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '/mode_Compte/_models/chat.dart';
import '/outils/constantes/numbers.dart';
import '../photo_display/fullPhoto.dart';

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

toReplyMessage(
    {required ChatMessage messageAsk,
    required double safeBlockHorizontal,
    required double safeBlockVertical}) {
  if (messageAsk != null) {
    switch (messageAsk.messageType) {
      case ChatMessage.SUPPRIME:
        return Container(
          constraints: BoxConstraints(
              minWidth: safeBlockHorizontal * 50,
              maxWidth: safeBlockHorizontal * 70),
          margin: EdgeInsets.only(
              bottom: safeBlockVertical *
                  (/*ChatController().areEmotionsPresent(messageAsk)  ? 2.5  :*/ 0.1)), //EdgeInsets.all(10),
          padding: EdgeInsets.symmetric(
            horizontal: safeBlockHorizontal * 3,
            vertical: safeBlockVertical * 1,
          ),
          decoration: BoxDecoration(
              borderRadius: decoMsgeQuestion().borderRadius,
              border: Border.all(
                  color: Color.fromRGBO(186, 194, 188, 1),
                  width: safeBlockVertical * 0.09)),

          child: Text("Message supprimé",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: safeBlockVertical * 1.8,
                color: Color.fromRGBO(186, 194, 188, 0.5),
              )),
        );

      case ChatMessage.TEXTE:
        return Container(
          constraints: BoxConstraints(
              minWidth: safeBlockHorizontal * 40,
              maxWidth: safeBlockHorizontal * 50),
          padding: EdgeInsets.symmetric(
            horizontal: safeBlockHorizontal * 3,
            vertical: safeBlockVertical * 1,
          ),
          decoration: decoMsgeQuestion(),
          child: Text(
            messageAsk != null ? messageAsk.text.replaceAll('\n', '\n\n') : "",
            style: TextStyle(
              fontSize: safeBlockVertical * 1.6,
              color: Color.fromRGBO(135, 137, 140, 1),
            ),
          ),
        );

        break;

      case ChatMessage.IMAGE:
        return FutureBuilder<String>(
            future: messageAsk.getUrl(),
            builder: (context, url) {
              if (!url.hasData) {
                return Image.asset(
                  'assets/no_image.png',
                  width: safeBlockHorizontal * 50,
                  height: safeBlockHorizontal * 50,
                  fit: BoxFit.cover,
                );
              } else {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FullPhoto(url: url.data!)));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      /*horizontal: safeBlockHorizontal * 3, */ vertical:
                          safeBlockVertical * 1,
                    ),
                    child: Material(
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xfff5a623)),
                          ),
                        ),
                        errorWidget: (context, url, error) => Material(
                          child: Image.asset(
                            'assets/no_image.png',
                            width: safeBlockHorizontal * 50,
                            height: safeBlockHorizontal * 50,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: decoMsgeQuestion().borderRadius,
                          clipBehavior: Clip.hardEdge,
                        ),
                        imageUrl: url.data!,
                        width: safeBlockHorizontal * 50,
                        height: safeBlockHorizontal * 50,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: decoMsgeQuestion()
                          .borderRadius, //BorderRadius.all(Radius.circular(8.0)),
                      clipBehavior: Clip.hardEdge,
                    ),
                  ),
                );
              }
            });
        break;
    }
  } else {
    return Center();
  }
}
