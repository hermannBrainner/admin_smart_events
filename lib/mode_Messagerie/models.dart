import '/mode_Compte/_models/chat.dart';
import '/mode_Compte/_models/user_app.dart';
import '/outils/fonctions/fonctions.dart';

class ChatsOfUser {
  UserApp userApp;
  List<ChatMessage> chats;

  ChatsOfUser({required this.userApp, required this.chats});

  getMessages() async {
    this.chats =
        await ChatMessage.getByUser(this.userApp.id, bWantInitMsges: false);


  }

  static Future<List<ChatsOfUser>> build(List<UserApp> users) async {
    List<ChatsOfUser> chatsOfUsers = [];

    for (UserApp user in users) {
      ChatsOfUser chatsOfUser = ChatsOfUser(userApp: user, chats: []);
      await chatsOfUser.getMessages();
      chatsOfUsers.add(chatsOfUser);
    }

    return chatsOfUsers;
  }
}
