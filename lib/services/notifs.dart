import 'package:firebase_messaging/firebase_messaging.dart';

import '/outils/fonctions/fonctions.dart';

class NotifsService {
  static void initialize() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen((event) {
      write("Un new OnMessage event a été publié!!",
          "NotifsService -initialize() ");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      write("Un new onMessageOpenedApp event a été publié!!",
          "NotifsService -initialize() ");
    });
  }

  static Future<String?> getToken() async {
    return FirebaseMessaging.instance.getToken();
  }
}
