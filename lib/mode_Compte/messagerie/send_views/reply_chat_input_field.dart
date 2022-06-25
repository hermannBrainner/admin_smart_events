import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/mode_Compte/_models/chat.dart';
import '/outils/size_configs.dart';
import '/providers/user_app.dart';

class ReplyInputField extends StatelessWidget {
  final ChatMessage? msgeToReply;
  final Function removePanel;

  ReplyInputField(
      {Key? key, required this.msgeToReply, required this.removePanel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    Widget prenomAsker() {
      if (msgeToReply == null) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Réponse à ",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        );
      } else if (msgeToReply!.idSender == "TOTO") {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Réponse à vous même",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        );
      } else {
        return Consumer<UserAppProvider>(builder: (context, provider, child) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Réponse à " + (provider.userApp?.prenom ?? "Hermann"),
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          );
        });
      }
    }

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              prenomAsker(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  msgeToReply!.text,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
        Center(
          child: IconButton(
            icon: Icon(Icons.highlight_remove_rounded),
            onPressed: () {
              removePanel();
            },
          ),
        )
      ],
    );
  }
}
