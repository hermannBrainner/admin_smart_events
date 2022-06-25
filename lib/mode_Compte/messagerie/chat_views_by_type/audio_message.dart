import 'package:flutter/material.dart';

import '/mode_Compte/_models/chat.dart';
import '/outils/size_configs.dart';

class AudioMessage extends StatelessWidget {
  final ChatMessage message;

  const AudioMessage({Key? key, required this.message}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool isSender = true /*message.idSender==Adherent.courrant(context).id */;

    SizeConfig().init(context);
    return Container(
      width: MediaQuery.of(context).size.width * 0.55,
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.safeBlockHorizontal * 0.75,
        vertical: SizeConfig.safeBlockHorizontal / 2.5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Color(0xFF00BF6D).withOpacity(isSender ? 1 : 0.1),
      ),
      child: Row(
        children: [
          Icon(
            Icons.play_arrow,
            color: isSender ? Colors.white : Color(0xFF00BF6D),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.safeBlockHorizontal / 2),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 2,
                    color: isSender
                        ? Colors.white
                        : Color(0xFF00BF6D).withOpacity(0.4),
                  ),
                  Positioned(
                    left: 0,
                    child: Container(
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                        color: isSender ? Colors.white : Color(0xFF00BF6D),
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Text(
            "0.37",
            style:
                TextStyle(fontSize: 12, color: isSender ? Colors.white : null),
          ),
        ],
      ),
    );
  }
}
