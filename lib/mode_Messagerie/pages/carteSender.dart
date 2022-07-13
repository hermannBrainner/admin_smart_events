import '/outils/extensions/string.dart';
import '/outils/extensions/time.dart';
import '/outils/fonctions/fonctions.dart';

import '/providers/theme/elements/boutons.dart';
import '/providers/theme/elements/main.dart';

import '/mode_Compte/_controllers/chat.dart';
import 'package:flutter/material.dart';

import '/mode_Compte/_models/chat.dart';
import '/mode_Compte/_models/user_app.dart';
import '/outils/size_configs.dart';
import 'message_screen/main.dart';

class CarteSender extends StatelessWidget {
  final List<ChatMessage> messages;
  final UserApp userApp;

  static const double rayonPings = 15;

  const CarteSender({Key? key, required this.messages, required this.userApp})
      : super(key: key);

  bool get lastIsImage {
    if (lastChat != null) {
      return lastChat!.messageType == ChatMessage.IMAGE;
    } else {
      return false;
    }
  }

  bool get adminIsSender {
    if (lastChat != null) {
      return lastChat!.idReceiver == userApp.id;
    } else {
      return false;
    }
  }

  ChatMessage? get lastChat {
    if (messages.isEmpty) {
      return null;
    } else {
      messages.sort(ChatMessage.comparator);
      return messages.last;
    }
  }

  int get nbreUnReads{
    return Chats.nonLus(messages, userApp.id, bForReceiver: false);
  }

  Widget get unReads{



    if(nbreUnReads>0){
      return Text(nbreUnReads.toString());
    }

    return Center();

  }

 

  String get heure {
    if(lastChat!=null){
    return  lastChat!.date.toStringDMY() ;
    }
    return "";
  }

  bool get isLastRead {

    if (lastChat != null){
      return lastChat!.chatLu;
    }
    return false;
  }

  Widget get iconInLast {
    if (adminIsSender) {
      if (isLastRead) {
        return Icon(Icons.done_all);
      } else {
        return Icon(Icons.check);
      }
    }

    return Center();
  }

  Widget get photoOrTexte {
    if (lastChat != null) {
      if (lastIsImage) {
        return Container(
          width: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.image,
                size: 25,
              ),
              Text("Photo")
            ],
          ),
        );
      } else {
        return Text(lastChat!.text);
      }
    } else {
      return Center();
    }
  }

  Widget rowDetailsGauche() {
    return Row(
      children: [iconInLast, photoOrTexte],
    );
  }


  @override
  Widget build(BuildContext context) {
    Widget wHour(){

      if (lastChat != null){
        return Text(heure, style: TextStyle(
            fontWeight: nbreUnReads>0 ? FontWeight.bold : null ,
            color: nbreUnReads>0 ? ThemeElements(context: context).whichBlue : null ),);
      }
      return Center();

    }

    return GestureDetector(
      onTap: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ClientChatsScreen(messages: messages, userAppClient: userApp, )));
      },
      child: Container(
        width: SizeConfig.safeBlockHorizontal * 90,
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            userApp.avatar(context, radius: 25),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Center(
                            child: Text(
                              userApp. nomPrenom,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child:
                        Center(child: wHour()),


                      )
                    ],
                  ),
                  if (lastChat != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: rowDetailsGauche(),
                        ),

                        Visibility(
                          visible: nbreUnReads>0,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Center(child: BoutonsOfTheme(context: context, textPagination: nbreUnReads.toString() ).pagination ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    ) ;
  }
}
