/*

import 'package:flutter/material.dart';
import '/outils/strings.dart';  import '../../../providers/theme/primary_box_decoration.dart';  import '../../../providers/theme/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '/outils/extensions/string.dart'; import '/outils/validation.dart';


class NotificationHandler{

  static final flutterLocalNotificationPlugin =
      FlutterLocalNotificationsPlugin();
  static BuildContext myContext;

  static void  initNotification(BuildContext context){

    myContext = context;
    var initAndroid = AndroidInitializationSettings("@drawable/ic_stat_colombes");
    var initIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification
    );
    var initSetting = InitializationSettings(android: initAndroid, iOS: initIOS);

    flutterLocalNotificationPlugin.initialize(initSetting,
    onSelectNotification: onSelectNotification );

  }

  static Future onSelectNotification(String payload){

    if(payload != null) write( payload , "GET Payload" );

  }

  static Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async{

    showDialog( context: myContext , builder: (context) => CupertinoAlertDialog(
      title: Text(title), content: Text(body),
      actions: [
        CupertinoDialogAction(child: Text('OK'),isDefaultAction:  true,
        onPressed: () => Navigator.of(context, rootNavigator: true).pop(),)
      ],
    ) );

  }




}*/
