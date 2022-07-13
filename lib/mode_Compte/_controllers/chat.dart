import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../_models/chat.dart';
import '/outils/constantes/collections.dart';
import '/outils/constantes/numbers.dart';
import '/outils/constantes/strings.dart';
import '/outils/fonctions/fonctions.dart';

class Chats {
 static bool deltaMaxAtteint(DateTime courant, DateTime autre) {
    return courant.difference(autre) > deltaMinMsge;
  }

  List<ChatMessage> reverseChats(List<MessageComplet> allComplets) {
    List<ChatMessage> allChats = [];
    for (MessageComplet complet in allComplets) {
      allChats.add(complet.chatMessage);
    }
    return allChats;
  }

 static List<MessageComplet> transformChats(List<ChatMessage> allChats) {
    List<MessageComplet> allComplets = [];

    for (ChatMessage msg in allChats) {
      MessageComplet complet = MessageComplet(
        chatMessage: msg,
        positionMsge: quelPosition(allChats, allChats.indexOf(msg)),
        displayHour: wantDisplayHour(allChats.indexOf(msg), allChats),
      );

      allComplets.add(complet);
    }

    return new List.from(allComplets.reversed);
  }

 static bool wantDisplayHour(int idx, List<ChatMessage> chats) {
    DateTime precedentTemps;

    if (chats.length > 1 && idx > 0) {
      precedentTemps = chats[idx - 1].date.toDate();
      if (precedentTemps.add(deltaMinMsge).compareTo(chats[idx].date.toDate()) <
          1) {
        // Alors il y a une difference d'au moins 5 minutes entre les 2
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  Stream<QuerySnapshot> listMessages() {
    return ChatMessage.collection.limit(5000).snapshots();
  }


  static  majLus(List<ChatMessage>chats, String idUser, {bool bForReceiver = true } )async{

    bool bForSender = !bForReceiver;

    for(ChatMessage chatMessage in chats.where((element) => !element.chatLu).toList()){

      if(bForReceiver && chatMessage.idReceiver==idUser ){
        chatMessage.chatLu = true;
        await chatMessage.save();
      }

      if(bForSender && chatMessage.idSender==idUser){
        chatMessage.chatLu = true;
        await chatMessage.save();
      }

    }

  }


  static  int nonLus(List<ChatMessage>chats, String idUser, {bool bForReceiver = true } ) {

    bool bForSender = !bForReceiver;

    if(bForReceiver){
      return chats.where((chatMessage) => (chatMessage.idReceiver==idUser)&& (!chatMessage.chatLu)  ).toList().length;
    }

    if(bForSender){
      return chats.where((chatMessage) => (chatMessage.idSender==idUser)&& (!chatMessage.chatLu)  ).toList().length;
    }

    return 0;

  }

 static NEIGHBORHOOD quelPosition(
      List<ChatMessage> allMsgs,
      int idx,
      ) {
    ChatMessage currentC = allMsgs[idx];
    ChatMessage avantC;
    ChatMessage nextC;

    NEIGHBORHOOD pos;
    //  write(currentC.idSender, "currentC.idSender");
//    write(currentC.idReceiver, "currentC.idReceiver");

    if (allMsgs.length > 1) {
      if (idx == 0) {
        nextC = allMsgs[idx + 1];
        if (currentC.idSender == nextC.idSender) {
          pos = NEIGHBORHOOD.DEBUT;
        } else {
          pos = NEIGHBORHOOD.UNIQUE;
        }
      } else if (idx == allMsgs.length - 1) {
        // Fin forcement ou unique
        avantC = allMsgs[idx - 1];
        if (currentC.idSender == avantC.idSender) {
          pos = NEIGHBORHOOD.FIN;
        } else {
          pos = NEIGHBORHOOD.UNIQUE;
        }
      } else {
        avantC = allMsgs[idx - 1];
        nextC = allMsgs[idx + 1];

        if (avantC.idSender != currentC.idSender) {
          //Debut ou Unique
          if (currentC.idSender == nextC.idSender) {
            pos = NEIGHBORHOOD.DEBUT;
          } else {
            pos = NEIGHBORHOOD.UNIQUE;
          }
        } else {
          //Milieu ou fin
          if (currentC.idSender == nextC.idSender) {
            pos = NEIGHBORHOOD.MILIEU;
          } else {
            pos = NEIGHBORHOOD.FIN;
          }
        }
      }
    } else {
      pos = NEIGHBORHOOD.UNIQUE;
    }

    if (pos == NEIGHBORHOOD.MILIEU) {
      bool suivantLointain = deltaMaxAtteint(
          allMsgs[idx + 1].date.toDate(), allMsgs[idx].date.toDate());
      bool precedentLointain = deltaMaxAtteint(
          allMsgs[idx].date.toDate(), allMsgs[idx - 1].date.toDate());

      if (precedentLointain && suivantLointain) {
        pos = NEIGHBORHOOD.UNIQUE;
      } else if (suivantLointain) {
        pos = NEIGHBORHOOD.FIN;
      } else if (precedentLointain) {
        pos = NEIGHBORHOOD.DEBUT;
      }
    } else if (pos == NEIGHBORHOOD.FIN) {
      bool precedentLointain = deltaMaxAtteint(
          allMsgs[idx].date.toDate(), allMsgs[idx - 1].date.toDate());

      pos = precedentLointain ? NEIGHBORHOOD.UNIQUE : pos;
    }

    if (pos == NEIGHBORHOOD.DEBUT) {
      bool suivantLointain = deltaMaxAtteint(
          allMsgs[idx + 1].date.toDate(), allMsgs[idx].date.toDate());
      if (suivantLointain) {
        pos = NEIGHBORHOOD.UNIQUE;
      }
    }

    if (pos == NEIGHBORHOOD.MILIEU) {
      /*bool precedentReponse = allMsgs[idx - 1].isREponse;
      bool suivantIsReponse = allMsgs[idx + 1].isREponse;*/
      /* if (precedentReponse) {
        pos = NEIGHBORHOOD.DEBUT;
      } else if (suivantIsReponse) {
        pos = NEIGHBORHOOD.FIN;
      }*/
    } else if (pos == NEIGHBORHOOD.FIN) {
      /* bool precedentReponse = allMsgs[idx - 1].isREponse;
      if (precedentReponse) {
        pos = NEIGHBORHOOD.UNIQUE;
      }*/
    } else if (pos == NEIGHBORHOOD.DEBUT) {
      /* bool suivantIsReponse = allMsgs[idx + 1].isREponse;
      if (suivantIsReponse) {
        pos = NEIGHBORHOOD.UNIQUE;
      }*/
    }

    return pos;
  }



  saveChatWithImage(
      {required String idcurrentMember,
        required File file,
        required BuildContext context}) async {
    String idChat = await getNewID(nomCollectionMessages);

    String chemin = mediaStorePath_Chats + cleanId(idChat);

    Reference fichier = FirebaseStorage.instance.ref().child(chemin);
    UploadTask uploadTask = fichier.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask.snapshotEvents.first;

    taskSnapshot.ref.getDownloadURL().then((url) async {});

    ChatMessage c = ChatMessage(
        messageType: ChatMessage.IMAGE,
        id: idChat,
        idSender: idcurrentMember,
        text: "",
        date: Timestamp.fromDate(DateTime.now()));

    await c.save();
  }
}
