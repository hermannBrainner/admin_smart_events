/*
import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import '/outils/strings.dart';  import '../../../providers/theme/primary_box_decoration.dart';  import '../../../providers/theme/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '/outils/extensions/string.dart'; import '/outils/validation.dart';
import 'notification_handler.dart';

class FirebaseNotifications{
  FirebaseMessaging _messaging;
  BuildContext myContext;

  void setupFirebase(BuildContext context){
    _messaging = FirebaseMessaging.instance;
    NotificationHandler.initNotification(context);
    firebaseCloudMessageListener(context);
    myContext = context ;
  }

  void firebaseCloudMessageListener(BuildContext context)async{
    NotificationSettings  settings = await _messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true

    );






    write('${settings.authorizationStatus} ', " NOTIF : SETTING");

    _messaging.getToken().then((token) => write('$token' , " NOTIF : My TOKEN"));

    _messaging.subscribeToTopic("messages").whenComplete( ()=> write('Subscribe OK', " NOTIF "));


    FirebaseMessaging.onMessage.listen((remoteMessage) {

      write('$remoteMessage', " NOTIF : RECEIVE");
      write( remoteMessage.data['topic'], " NOTIF : topic");
      write(remoteMessage.data['body']  , " NOTIF : BODY");


      if(Platform.isAndroid)
        showNotification(  (remoteMessage.data['title']  ) , remoteMessage.data['body']);
      else if(Platform.isIOS)
        showNotification(   (remoteMessage.notification.title)  , remoteMessage.notification.body);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      write('$remoteMessage', " NOTIF :  Receive open app : ");
      if(Platform.isIOS)
        showDialog( context: myContext , builder: (context) => CupertinoAlertDialog(
          title: Text( (remoteMessage.notification.title)  ), content: Text(remoteMessage.notification.body),
          actions: [
            CupertinoDialogAction(child: Text('OK'),isDefaultAction:  true,
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),)
          ],
        ) );

    });


  }

  static void showNotification(title, body) async {
    var androidChannel =
    AndroidNotificationDetails(
        'com.brainpower.meltine',
        'My Channel',
        autoCancel:  true,
        ongoing: true,
      importance: Importance.max,
      priority: Priority.high
    );

    var ios = IOSNotificationDetails();
    var platform = NotificationDetails(
      android: androidChannel , iOS: ios
    );

    await NotificationHandler.flutterLocalNotificationPlugin.show(Random().nextInt(1000), title, body, platform, payload: 'My Payload');

  }



}
*/
