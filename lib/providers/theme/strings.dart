import '/outils/constantes/strings.dart';

class Strings {
// Default Local
  static const String localFr = "fr_FR";

  static const String statut = "STATUT";
  static const String total = "TOTAL";
  static const String na = "N/A";
  static const String jeConfirme = "Je confirme";

// Repertoires Firebase
  static const String dossierTemplates = "Templates/";
  static const String dossierCouvertures = "images/couvertures/";
  static const String dossierBillets = "Billets/";

// assets
  static const String pathAssetGoudy =
      'assets/Sorts_Mill_Goudy/SortsMillGoudy-Regular.ttf';
  static const String pathAssetRebecca = 'assets/Rebecca/rebecca_samuels.ttf';

  static const String pathAssetAphrodite = 'assets/Aphrodite/aphrodite.ttf';

// Templates
  static const String templateCsv = "csv_template.csv";
  static const String templateExcel = "xlsx_template.xlsx";

// Titres des pages
  static const String pageDispositions = "Dispositions";
  static const String pageVerification = "Scanner un billet";
  static const String pageInstallation = "Invités non installés";
  static const String pageListeInvites = "Liste invités";
  static const String pageStats = "Statistiques";
  static const String pageParmtrs = "Configurations";

  //static const String pageGestionBillets = 'Import des Billets';

// Menu
  static const String menuImport = "Importer une liste d'invités";
  static const String menuExport = 'Imprimer des Billets';
  static const String menuDispos = 'Dispositions de la salle';
  static const String menuAccueil = 'Accueil';
  static const String menuStats = 'Statistiques';
  static const String menuInstalls = "Invités non installés";
  static const String menuListeInv = 'Liste invités';
  static const String menuVerif = "Scanner un billet";

// billet d'accès

  static const String scanMe = "scannez-moi";

// Exports des Billets

  static const String exportAllQrCode = "Imprimer tous les Qrcodes";

  static const String exportAllBillets = "Imprimer tous Billets";

  static const String exportUploadDetails =
      "Si vous avez des premières pages (au format PDF) de votre Billet, vous pouvez le charger et il sera associé au Billet d'accès ";
  static const String exportDeleteBillet = "Suppimer le billet chargé";
  static const String exportUploadBillet = "Importer le billet";
  static const String exportBilletExistant = "Vous avez déjà un billet chargé";

// Imports des Billets

  static const String importDownloadTemplate = "Télécharger un template";
  static const String importTitre = "Importer une liste d'invites";
  static const String importNew = "Nouveaux billets";
  static const String importNewDetails =
      "Ecraser tous les billets déjà existants";
  static const String importDowloadDetails =
      "Le Template vous permet de savoir comment disposer les infos dans le fichier avant de l'importer dans l'application";

  static const String importBadTitre = "Aucun billet à importer";
  static const String importBadRecoTitre =
      "Pour importer les billets, essayez les étapes suivantes :";
  static const String importBadRecoItem1 = "Télécharger un template";
  static const String importBadRecoItem2 = "Remplir les lignes et colonnes";
  static const String importBadRecoItem3 =
      "Respecter le format de chaque donnée";

// Parametres
  static const String paramsDetails = "Détails de la Cérémonie";
  static const String paramsConnexion = "Identifiants de connexion";
  static const String paramsDispositions = "Disposition dans la salle";
  static const String paramsQrCodes = "Qr codes / Billets";
  static const String paramsReinit = "Réinitialisation des billets";
  static const String paramsDelete = "Suppression de la cérémonie";

// InfosBulles
  static const String infoBulleDetails =
      "Ce sont les informations principales de votre Cérémonie.";
  static const String infoBulleConnexion =
      "D'autres utilisateurs peuvent se connecter à cette Cérémonie (sans pouvoir en changer les paramètres ou les dispositions). ";
  static const String infoBulleDispositions =
      "Suivant que vous désirez disposer votre salle de cérémonie par Zones et/ou Tables. Ce qui permettra d'avoir plus de facilité, autant dans l'accueil des convives que dans vos statistiques.";
  static const String infoBulleQrCodes =
      "Un url, peut être celui du site web de votre évènement. Ce qui permettra à vos convives, en flachant le Qr Code présent sur le billet, d'être dirigé vers votre site web.";
  static const String infoBulleModifs =
      "Modifiez les seules infos qui vous interessent.";
  static const String infoJeConfirme = "Ecrivez : '" + jeConfirme + "'";

// Dispositions des salles
  static const String dispoMax = 'SALLE > ZONES > TABLES > INVITÉS';
  static const String dispoMoyen = 'SALLE > TABLES > INVITÉS';
  static const String dispoMin = 'SALLE > INVITÉS';

  static const String dispoZones = 'Zones';
  static const String dispoTables = 'Tables';
  static const String dispoBillets = 'Billets';

// Generic strings
  static const String ok = 'OK';
  static const String voir = "VOIR";
  static const String initialisation = "Initialisation ...";
  static const String finalisation = "Finalisation...";
  static const String chargement = "Chargement ...";
  static const String supprimer = "Supprimer";
  static const String cancel = 'Annuler';
  static const String valider = "Valider";
  static const String confirm = "Confirmer";
  static const String modifier = "Modifier";

// Gestion des Billets (Import
  static const String importBillets = "Import liste d'invités";
  static const String exportBillets = 'Exports billets';

// page connexion
  static const String signIn = "Connexion";

// Extensions

  static const String extensionPdf = ".pdf";
  static const String extensionJpg = ".jpg";
  static const String extensionCsv = "csv";
  static const String extensionXls = "xlsx";

// Page inscription
  static const String signUp = "Inscription";
  static const String exampleMail = "moi@exemple.com";

// Page Connexion
  static const String firebaseProjectURL =
      'https://eventscanner.page.link/63fF';

// Page New Event
  static const String exempleUrl = "http://my_wedding.com";

// Exception

  static const String formatException = "FORMATEXCEPTION";
  static const String pwdException = "wrong-password";

// Sharing
  static const String corpsMsge = "Bonjour" +
      newLine +
      'Trouvez votre document, en pièce jointe' +
      newLine +
      newLine +
      "Cordialement" +
      newLine +
      newLine +
      newLine +
      "La direction";

  static const String urlAppIos = "https://testflight.apple.com/join/SyDs3LpC";
  static const String urlAppAndroid =
      "https://play.google.com/store/apps/details?id=com.brainpower.smart_events";

  static const String corpsMsgeParrainage =
      "Decouvrez Smart Events : je l'utilise pour organiser mes evenements (Mariage, Anniversaire, Conferences, soirees et autres )" +
          newLine +
          newLine +
          "En utilisant un de ces liens, recevrez 5€ de prime de bienvenue" +
          newLine +
          urlAppIos +
          newLine +
          newLine +
          urlAppAndroid;
}
