import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '/mode_Compte/_controllers/chat.dart';
import '/mode_Compte/_models/chat.dart';
import '/outils/constantes/collections.dart';
import '/outils/constantes/colors.dart';
import '/outils/fonctions/fonctions.dart';
import '/outils/size_configs.dart';
import '/providers/theme/elements/main.dart';

class ChatInputField extends StatefulWidget {

  final String idSender;
  final String idReceiver;
  List<MessageComplet> allChats;
  ChatInputField(
      {Key? key,
      required this.idSender,
      required this.allChats, required this.idReceiver, })
      : super(key: key);
  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  bool boutonVisible = false;
  String? textMessage;
  File? imageFile;
//  String imageUrl;
  bool isLoading = false;
  final FocusNode focusNode = FocusNode();
  final chatCtrl = TextEditingController();
  final RoundedLoadingButtonController btnCtrl =
      RoundedLoadingButtonController();

  Future<bool> onBackPress() {
    Navigator.pop(context);

    return Future.value(false);
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile? pickedFile;

    pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) imageFile = File(pickedFile.path);

    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });

      await Chats().saveChatWithImage(
        context: context,
        idcurrentMember: widget.idSender,
        file: imageFile!,
      );
    }
  }

  buildInput() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.safeBlockHorizontal,
        vertical: SizeConfig.safeBlockHorizontal / 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,

      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(width: SizeConfig.safeBlockHorizontal * 2),
            Expanded(
              child: Container(
                width: SizeConfig.safeBlockHorizontal * 70,
                // height: 50,
                // alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.safeBlockHorizontal * 0.75,
                ),
                decoration: BoxDecoration(
                  color: ThemeElements(context: context).themeColorSecondary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: focusNode,
                        controller: chatCtrl,
                        onChanged: (value) {
                          textMessage = value;

                          setState(() {
                            if (!(value == null || value.isEmpty))
                              boutonVisible = !(value == null || value.isEmpty);
                          });
                        },
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: ThemeElements(context: context)
                            .styleText(fontSize: 17),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(20.0),
                          hintText: "Saisissez votre message...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: chatCtrl.text.isEmpty ,
              child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.image,
                    size: 50,
                    color: ThemeElements(context: context).whichBlue,
                  ),
                  onPressed: () {
                    getImage();
                  } // getImage,
                  // color: primaryColor,
                  ),
            ),
            Visibility(
              visible: !chatCtrl.text.isEmpty,
              child: RoundedLoadingButton(
                  elevation: 0,
                  width: 50,
                  borderRadius: 10,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Icon(
                    Icons.send_rounded,
                    size: SizeConfig.safeBlockHorizontal * 10,
                    color: couleurSendChat,
                  ),
                  controller: btnCtrl,
                  valueColor: couleurSendChat,
                  onPressed: () async {
                    String idChat = await getNewID(nomCollectionMessages);

                    ChatMessage c = ChatMessage(
                        id: idChat,
                        idSender: widget.idSender,
                        idReceiver: widget.idReceiver,
                        text: textMessage ?? "",
                        date: Timestamp.fromDate(DateTime.now()));

                    await c.save();
                    btnCtrl.success();
                    clearTextInput();
                    setState(() {
                      textMessage = null;
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                    });
                  }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    //   focusNode.addListener(onFocusChange);
    boutonVisible = false;
    textMessage = null;
  }

  clearTextInput() {
    boutonVisible = false;
    chatCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              buildInput(),
            ],
          ),
        ],
      ),
      onWillPop: onBackPress,
    );
    ;
  }
}
