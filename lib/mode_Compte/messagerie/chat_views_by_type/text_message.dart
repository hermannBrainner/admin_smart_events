import 'package:flutter/material.dart';
import 'package:linkwell/linkwell.dart';

import '/mode_Compte/_models/chat.dart';
import '/outils/size_configs.dart';
import '../common_widgets/components.dart';

class TextMessage extends StatelessWidget {
  const TextMessage(
      {Key? key,
      required this.message,
      this.messageAsk,
      required this.voisinnageChat,
      required this.idSender})
      : super(key: key);
  final String idSender;
  final ChatMessage message;
  final ChatMessage? messageAsk;
  final NEIGHBORHOOD voisinnageChat;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    bool isSender = message.idSender == idSender;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              constraints: BoxConstraints(
                  minWidth: SizeConfig.safeBlockHorizontal * 50,
                  maxWidth: SizeConfig.safeBlockHorizontal * 70),
              margin: EdgeInsets.only(
                  bottom: SizeConfig.safeBlockVertical *
                      (/*ChatController().areEmotionsPresent(message)  ? 2.5  :*/ 0.1)), //EdgeInsets.all(10),
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.safeBlockHorizontal * 3,
                vertical: SizeConfig.safeBlockVertical * 1,
              ),
              decoration: quelleDecoration(
                isSender,
                voisinnageChat,
              ),
              child: LinkWell(
                message.text,
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockVertical * 2.2,
                  color: isSender ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
