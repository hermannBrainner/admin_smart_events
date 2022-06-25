import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '/mode_Compte/_models/chat.dart';
import '/outils/size_configs.dart';
import '../common_widgets/components.dart';
import '../photo_display/fullPhoto.dart';

class ImageMessage extends StatelessWidget {
  const ImageMessage(
      {Key? key,
      required this.message,
      this.messageAsk,
      required this.voisinnageChat,
      required this.idcurrentMember})
      : super(key: key);
  final String idcurrentMember;
  final ChatMessage message;
  final ChatMessage? messageAsk;
  final NEIGHBORHOOD voisinnageChat;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    bool isSender = message.idSender == idcurrentMember;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        /* if(messageAsk!= null)
        Visibility(
          visible:
              voisinnageChat == NEIGHBORHOOD.DEBUT ||
              voisinnageChat == NEIGHBORHOOD.UNIQUE,
          child: chapeauMessage(message, messageAsk!, context, idcurrentMember),
        ),*/

        Stack(
          children: [
            FutureBuilder<String>(
                future: message.getUrl(),
                builder: (context, url) {
                  if (!url.hasData) {
                    return Image.asset(
                      'assets/no_image.png',
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.cover,
                    );
                  } else {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    FullPhoto(url: url.data!)));
                      },
                      child: Container(
                        // color: Colors.red,
                        margin: EdgeInsets.only(
                            bottom: SizeConfig.safeBlockVertical *
                                (/*ChatController().areEmotionsPresent(message)  ? 2.5 : */ 0.1)),
                        padding: EdgeInsets.symmetric(
                            //horizontal: SizeConfig.safeBlockHorizontal * 3,
                            //    vertical: SizeConfig.safeBlockVertical * 1,
                            ),
                        child: Material(
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                                //  decoration: quelleDecoration(isSender, voisinnageChat, message.isREponse),
                                // child: CircularProgressIndicator( valueColor: AlwaysStoppedAnimation<Color>(Color(0xfff5a623)), ),
                                ),
                            errorWidget: (context, url, error) => Material(
                              child: Image.asset(
                                'assets/no_image.png',
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              clipBehavior: Clip.hardEdge,
                            ),
                            imageUrl: url.data!,
                            width: SizeConfig.safeBlockHorizontal * 70,
                            height: SizeConfig.safeBlockHorizontal * 70 -
                                SizeConfig.safeBlockVertical *
                                    (/*ChatController().areEmotionsPresent(message)  ? 2.5 :*/ 0.1),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: quelleDecoration(
                            isSender,
                            voisinnageChat,
                          ).borderRadius, //BorderRadius.all(Radius.circular(8.0)),
                          clipBehavior: Clip.hardEdge,
                        ),
                      ),
                    );
                  }
                }),

            /* Positioned(
                bottom: SizeConfig.safeBlockVertical * 0,
                right: 0,
                child:emotionView(message,
                    context,SizeConfig.safeBlockHorizontal, idcurrentMember)),*/
          ],
        ),
      ],
    );
  }
}
