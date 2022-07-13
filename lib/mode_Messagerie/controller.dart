import 'package:cloud_firestore/cloud_firestore.dart';

import '../mode_Compte/_models/billet.dart';
import '../outils/fonctions/fonctions.dart';
import '/mode_Compte/_models/chat.dart';
import 'models.dart';

List<ChatsOfUser> filter(
    {  dynamic query, required List<ChatsOfUser> usersChats}) {
  List<ChatsOfUser> listFiltree = [];
  
  if (isNullOrEmpty(query)) {
    listFiltree = usersChats;
  } else {
    listFiltree = List<ChatsOfUser>.from(usersChats.where(
            (uC) => uC.userApp.nomPrenom.toLowerCase().contains(query.toLowerCase())))
        .toList();
  }

  return listFiltree;
}

List<ChatMessage> qsToList(QuerySnapshot data, {int idx = 1}) {
  List<ChatMessage> all = [];
  data.docs.forEach((element) {
    all.add(ChatMessage.fromJson(element.data() as Map<String, dynamic>));
  });
  all.sort(comparator);
  return all;
}

Comparator<ChatMessage> comparator =
    (s1, s2) => s1.date.toDate().compareTo(s2.date.toDate());
