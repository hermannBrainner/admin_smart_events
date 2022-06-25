import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/mode_Compte/_controllers/user.dart';
import '/mode_Compte/_models/user_app.dart';

class UserAppProvider with ChangeNotifier {
  UserApp? userApp;

  Future<bool> load(BuildContext context) async {
    String idUserApp = (Provider.of<UserPhone>(context, listen: false)).id;
    userApp = await UserAppController.getUserApp(idUserApp);

    if (userApp != null) {
      userApp = (userApp!.isAdmin) ? userApp : null;
    }

    notifyListeners();

    return (userApp != null);
  }

  Future<bool> initFromPasserelle(UserPhone utilisateur) async {
    UserApp? userAppTemp = await UserAppController.getUserApp(utilisateur.id);

    if (userAppTemp != null) {
      userApp = userAppTemp;
    }
    notifyListeners();
    return true;
  }

  refresh(UserApp? inUserApp) {
    userApp = inUserApp;

    notifyListeners();
  }
}
