import '../controller.dart';
import '/mode_Compte/_models/user_app.dart';
import 'package:flutter/material.dart';

import '../models.dart';
import 'carteSender.dart';
import 'chapeau.dart';
import 'message_screen/chapeau.dart';


enum TAG_CHATS_LISTE   { MESSAGERIE, AUTRES }


class UserChatsListe extends StatefulWidget {
    List<ChatsOfUser> usersWithChats;
  final TAG_CHATS_LISTE tag;
  final List<UserApp> clients;

    UserChatsListe({Key? key,   required this.usersWithChats , required this.tag, required this.clients})
      : super(key: key);

  @override
  State<UserChatsListe> createState() => _UserChatsListeState();
}

class _UserChatsListeState extends State<UserChatsListe> {
  var _searchview = new TextEditingController();
  List<ChatsOfUser> listFiltree = [];
  String _query = "";
  bool isRecherche = false;


  onSubmitSearch() {
    setState(() {
      listFiltree =  filter(
          usersChats: widget.usersWithChats, query: _query, );
    });
  }

  onClearSearch() {
    setState(() {
      listFiltree = List<ChatsOfUser>.from([]).toList();
      _query = "";
      _searchview.clear();
    });
  }


  @override
  void initState() {
   // data = widget.usersWithChats;
    super.initState();
  }

  void updateData()async{
    widget.usersWithChats = await ChatsOfUser.build(widget.clients);
    setState(() {

    });
  }
  List<ChatsOfUser> listDisplay() {
    if (!isRecherche) {
      listFiltree = filter(
        usersChats: widget.usersWithChats, query: _query, );
    }
    return listFiltree;
  }

  _UserChatsListeState() {
    _searchview.addListener(() {
      if (_searchview.text.isEmpty) {
        setState(() {
          isRecherche = false;
          _query = "";
        });
      } else if (_searchview.text == "") {
        isRecherche = false;
      } else {
        setState(() {
          isRecherche = true;
          _query = _searchview.text;
          listFiltree = filter(
            usersChats: widget.usersWithChats, query: _query, );
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        chapeauMessagerie(context, _searchview,
            fctOnSubmit: onSubmitSearch,
            fctOnClear: onClearSearch,
            totalBillet: listDisplay().length,
            nbreInvites: listDisplay().length),
        Expanded(
          child: RefreshIndicator (
            onRefresh: () async {
              updateData();
            },
            child: ListView.builder(
                shrinkWrap: false,
                scrollDirection: Axis.vertical,
                itemCount: listDisplay() .length,
                itemBuilder: (BuildContext context, int id) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8.0),
                    child: CarteSender(
                      userApp:listDisplay() [id].userApp,
                      messages: listDisplay() [id].chats,
                    ),
                  );
                }),
          ),
        )
      ],
    );
  }


}
