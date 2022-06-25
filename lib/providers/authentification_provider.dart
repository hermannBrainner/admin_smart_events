import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/outils/fonctions/fonctions.dart';
import './../mode_Compte/_models/user_app.dart';
import '../services/notifs.dart';

class AuthentificationProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  signUp(String email, String pwd) async {
    UserCredential resultat =
        await _auth.createUserWithEmailAndPassword(email: email, password: pwd);
    return resultat;
  }

  updatePassword(String password) async {
    await _auth.currentUser!.updatePassword(password);
  }

  updateMail(String newEmail) async {
    await _auth.currentUser!.updateEmail(newEmail);
  }

  //creation d'un obj utilisateur provenant de la classe firebaseUser

  void initUser(User? user) async {
    if (isNullOrEmpty(user)) return;

    NotifsService.getToken().then((token) {
      if (token != null) {
        UserApp.saveToken(user!.uid, token);
      }
    });
  }

  UserPhone? _utilisateurDeFirebaseUser(User? user) {
    initUser(user);
    if (!isNullOrEmpty(user)) {
      return UserPhone(id: user!.uid, isAnonymous: user.isAnonymous);
    } else {
      return null;
    }
  }

  //la difussion de l'auth de l'utilisateur

  Stream<UserPhone?> get utilisateur {
    return _auth.authStateChanges().map(_utilisateurDeFirebaseUser);
  }

  changePassword(String pswd, BuildContext context) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User currentUser = firebaseAuth.currentUser!;
    currentUser.updatePassword(pswd).then((_) async {}).catchError((err) {});
  }
}
