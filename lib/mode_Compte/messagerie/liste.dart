import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/outils/constantes/colors.dart';
import '/outils/size_configs.dart';
import '/outils/widgets/main.dart';
import '/providers/user_app.dart';
import '../_controllers/chat.dart';
import '../_models/chat.dart';
import 'chat_view.dart';
import 'send_views/chat_input_field.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool displayAscenseur = false;
  bool dejaRefresh = false;

  final ScrollController scroll = new ScrollController();
  int indexScroll = 0;
  final RoundedLoadingButtonController ctrlAscenseur =
      RoundedLoadingButtonController();

  void listenScrolling() {
    if (scroll.position.pixels >= 500) {
      setState(() {
        displayAscenseur = true;
      });
    } else {
      setState(() {
        displayAscenseur = false;
      });
    }
  }

  void scrollUp() {
    final double start = 0;

    scroll.jumpTo(start);
  }

  void scrollDown(RoundedLoadingButtonController ctrl) {
    final double end = scroll.position.minScrollExtent;

    scroll.jumpTo(end);
    scroll.jumpTo(end);
    ctrl.success();
    ctrl.stop();
  }

  @override
  void initState() {
    super.initState();
    scroll.addListener(listenScrolling);
    displayAscenseur = false;
    dejaRefresh = false;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Consumer<UserAppProvider>(builder: (context, provider, child) {
      return FutureBuilder<List<ChatMessage>>(
          future: ChatMessage.getByUser(provider.userApp?.id ?? ""),
          builder: (context, qs) {
            if (!qs.hasData) {
              return getLoadingWidget(context);
            } else {
              List<ChatMessage> allMessages = qs.data!;
              List<MessageComplet> allComplets =
                  Chats.transformChats(allMessages);



              if (!dejaRefresh && allMessages.isNotEmpty) {
                Chats.majLus(allMessages, provider.userApp?.id ?? "");
                dejaRefresh = true;
              }
              return Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.safeBlockHorizontal * 0.2),
                          child: ListView.builder(
                            controller: scroll,
                            reverse: true,
                            itemCount: allComplets.length,
                            itemBuilder: (context, index) => MessageView(
                              mgeComplet: allComplets[index],
                              idSender: provider.userApp?.id ?? "",
                            ),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 50.0, top: 5),
                            child: ChatInputField(
                              idSender: provider.userApp?.id ?? "",
                              allChats: allComplets,
                              idReceiver: ChatMessage.idAMIN,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Visibility(
                    visible: displayAscenseur,
                    child: Positioned(
                      bottom: SizeConfig.blockSizeVertical * 10,
                      right: SizeConfig.blockSizeHorizontal * 40,
                      child: RoundedLoadingButton(
                          elevation: 3,
                          width: SizeConfig.safeBlockHorizontal * 10,
                          height: SizeConfig.safeBlockHorizontal * 10,
                          borderRadius: 2 * SizeConfig.safeBlockHorizontal * 5,
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: Icon(
                            Icons.arrow_downward,
                            size: SizeConfig.safeBlockHorizontal * 7,
                            color: couleurSendChat,
                          ),
                          controller: ctrlAscenseur,
                          valueColor: couleurSendChat,
                          onPressed: () async {
                            scrollDown(ctrlAscenseur);
                          }),
                    ),
                  )
                ],
              );
            }
          });
    });
  }
}
