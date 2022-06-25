import 'package:cloud_firestore/cloud_firestore.dart';

import '/mode_Compte/_models/user_app.dart';

class UserAppController {
  static Future<UserApp?> getUserApp(String idAdh) async {
    UserApp? userApp;
    await UserApp.collection
        .where(UserApp.u_id, isEqualTo: idAdh)
        .get()
        .then((user) {
      if (user.docs.isNotEmpty) {
        userApp =
            UserApp.fromJson(user.docs.first.data() as Map<String, dynamic>);
      }
    }).catchError((e) {
      return null;
    });

    return userApp;
  }

  Stream<QuerySnapshot> listUserApps() {
    return UserApp.collection.snapshots();
  }
}
