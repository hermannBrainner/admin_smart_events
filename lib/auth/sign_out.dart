import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/auth/sign_in.dart';
import '/mode_Compte/_models/user_app.dart';
import '/providers/user_app.dart';
import 'splashscreen.dart';

signOut(BuildContext context, signOutComplete) async {
  final utilisateur = Provider.of<UserPhone>(context, listen: false);

  if (utilisateur.isAnonymous) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        Connexion.routeName, (Route<dynamic> route) => false);
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.delete();
      await FirebaseAuth.instance.signOut();
    }
  } else {
    if (signOutComplete) {
      context.read<UserAppProvider>().refresh(null);
      await FirebaseAuth.instance.signOut();
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SplashScreen(),
      ),
    );
  }
}
