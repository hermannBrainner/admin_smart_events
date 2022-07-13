import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '/outils/constantes/collections.dart';
import '/outils/constantes/strings.dart';
import '/outils/fonctions/fonctions.dart';

enum MessageStatus { not_sent, not_view, viewed }
enum NEIGHBORHOOD { UNIQUE, DEBUT, FIN, MILIEU }

class ChatMessage {
  String id;
  String idSender;
  String? idReceiver;
  String text;
  final Timestamp date;
  String messageType;
  bool chatLu;
  final MessageStatus? messageStatus;

  static const c_idSender = 'idSender';
  static const c_idReceiver = 'idReceiver';
  static const c_chatLu = 'chatLu';


  static const idAMIN = "ADMIN";

  // Les types de Chat
  static const String TEXTE = "TEXTE";
  static const String IMAGE = "IMAGE";
  static const String SUPPRIME = "SUPPRIME";
  static const List<String> listeVide = [];

  ChatMessage(
      {required this.id,
        required this.idSender,
        this. chatLu = false,
        this.text = '',
        this.messageType = TEXTE,
        this.messageStatus,
        this.idReceiver = null,
        required this.date});

  static CollectionReference collection =
  FirebaseFirestore.instance.collection(nomCollectionMessages);

  static Comparator<ChatMessage> comparator2 =
      (s1, s2) => s2.date.toDate().compareTo(s1.date.toDate());

  static Comparator<ChatMessage> comparator =
      (s1, s2) => s1.date.toDate().compareTo(s2.date.toDate());

  static Future<List<ChatMessage>> getByUser(String idAppUser,
      {bool bWantInitMsges = true}) async {
    List<ChatMessage> chatMessages = [];

    await collection.where(c_idSender, isEqualTo: idAppUser).get().then((snap) {
      snap.docs.forEach((doc) {
        chatMessages
            .add(ChatMessage.fromJson(doc.data() as Map<String, dynamic>));
      });
    }).catchError((e) {});
    await collection
        .where(c_idReceiver, isEqualTo: idAppUser)
        .get()
        .then((snap) {
      snap.docs.forEach((doc) {
        chatMessages
            .add(ChatMessage.fromJson(doc.data() as Map<String, dynamic>));
      });
    }).catchError((e) {});

    if (chatMessages.isEmpty && bWantInitMsges) {
      ChatMessage c1 = ChatMessage(
          id: (await getNewID(nomCollectionMessages)),
          idReceiver: idAppUser,
          idSender: idAMIN,
          text: "Bonjour, je suis Laura, conseillere pour Smart Events" +
              newLine +
              "Ensemble, on peut trouver une reponse a votre demande",
          date: Timestamp.fromDate(DateTime.now()));

      await c1.save();
      chatMessages.add(c1);

      ChatMessage c2 = ChatMessage(
          id: (await getNewID(nomCollectionMessages)),
          idReceiver: idAppUser,
          idSender: idAMIN,
          text: "Quel est le sujet de votre demande?",
          date: Timestamp.fromDate(DateTime.now()));

      await c2.save();
      chatMessages.add(c2);
    }

    chatMessages.sort(comparator);
    return chatMessages;
  }
  static List<ChatMessage> qsToList(QuerySnapshot data, {int idx = 1}) {
    List<ChatMessage> all = [];
    data.docs.forEach((element) {
      all.add(ChatMessage.fromJson(element.data() as Map<String, dynamic>));
    });
    if (idx == 1) {
      all.sort(comparator);
    } else {
      all.sort(comparator2);
    }
    return all;
  }



  ChatMessage.fromJson(Map<String, dynamic> item)
      : this.id = item['id'],
        this.idSender = item['idSender'] ?? idAMIN,
        this.idReceiver = item['idReceiver'] ?? idAMIN,
        this.chatLu = item[c_chatLu]??false,
        this.text = item['text'],
        this.messageType = item['messageType'] ?? TEXTE,
        this.messageStatus = item['messageStatus'],
        this.date = item['date'];

  Map<String, dynamic> toMap() {
    var data = Map<String, dynamic>();
    data['id'] = id;
    data['idSender'] = idSender;
    data['idReceiver'] = idReceiver;
    data['text'] = text;
    data[c_chatLu] = chatLu;
    data['messageType'] = messageType;
    data['messageStatus'] = messageStatus;
    data['date'] = date;

    return data;
  }

  Future<String> getUrl() async {
    String chemin = mediaStorePath_Chats + cleanId(id);

    Reference fichier = FirebaseStorage.instance.ref().child(chemin);
    String urlFichier = (await fichier.getDownloadURL()).toString();

    return urlFichier;
  }

  String get chatTime {
    DateTime momentMessage = date.toDate();
    initializeDateFormatting("fr");
    Intl.defaultLocale = "fr_FR";
    Duration difference = DateTime.now().difference(momentMessage);

    // si meme année
    if (momentMessage.year == DateTime.now().year) {
      if (difference.inDays < 1) {
        if (difference.inHours > DateTime.now().hour) {
          return ("hier À " + DateFormat('HH:mm').format(momentMessage))
              .toUpperCase();
        } else {
          return DateFormat('HH:mm').format(momentMessage).toUpperCase();
        }
      } else {
        return DateFormat('dd MMM À HH:mm').format(momentMessage).toUpperCase();
      }
    } else {
      return DateFormat('dd MMM yyyy À HH:mm')
          .format(momentMessage)
          .toUpperCase();
    }
  }

  save() async {
    return await collection.doc(id).set(toMap());
  }

  deleteImagechat() async {
    String url = await getUrl();
    FirebaseStorage.instance.refFromURL(url).delete();
  }
}

class MessageComplet {
  ChatMessage chatMessage;
  bool displayHour;
  NEIGHBORHOOD positionMsge;
  ChatMessage? msgeRepondu;

  MessageComplet(
      {required this.chatMessage,
      required this.displayHour,
      required this.positionMsge,
      this.msgeRepondu});
}
