import '/providers/theme/bouton_retour.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/mode_Compte/_models/user_app.dart';
import '/mode_Messagerie/pages/liste.dart';
import '/providers/theme/elements/main.dart';
import '../outils/widgets/main.dart';
import 'models.dart';

class AdminMessagerie extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BoutonRetour( press: () => Navigator.pop(context),),
        title: Text("Messagerie") ,
      ),
        body: StreamBuilder<QuerySnapshot>(
            stream: UserApp.collection.snapshots(),
            builder: (context, qs) {
              List<UserApp> allUsers = [];

              if (!qs.hasData) {
                return getLoadingWidget(context);
              } else {
                qs.data!.docs.forEach((element) {
                  allUsers.add(
                      UserApp.fromJson(element.data() as Map<String, dynamic>));
                });

                return FutureBuilder<List<ChatsOfUser>>(
                    future: ChatsOfUser.build(allUsers),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<ChatsOfUser> cu_forMsgerie = snapshot.data!
                            .where((chatsOfUser) =>
                        chatsOfUser
                            .chats.isNotEmpty)
                            .toList();

                        List<ChatsOfUser> cu_forAutres = snapshot.data!
                            .where((chatsOfUser) =>
                        chatsOfUser
                            .chats.isEmpty)
                            .toList();


                        return DefaultTabController(
                            length: 2,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 50,
                                  color:
                                  ThemeElements(context: context).whichBlue,
                                  child: TabBar(
                                      indicatorColor: Colors.blue[100],
                                      tabs: <Widget>[
                                        Tab(text: "Boite de  reception"),
                                        Tab(text: "Clients")
                                      ]),
                                ),
                                Expanded(
                                  child: Container(
                                    child: TabBarView(
                                      children: [
                                        UserChatsListe(
                                          clients: cu_forMsgerie.map((e) => e.userApp).toList(),
                                          usersWithChats: cu_forMsgerie,
                                          tag: TAG_CHATS_LISTE.MESSAGERIE,
                                        ),
                                        UserChatsListe(
                                          tag: TAG_CHATS_LISTE.AUTRES,
                                          usersWithChats: cu_forAutres,
                                          clients: cu_forAutres.map((e) => e.userApp).toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ));
                      } else {
                        return getLoadingWidget(context);
                      }
                    });
              }
            }) // Body(),
        );
  }
}
