import 'package:country_currency_pickers/countries.dart';

import '/outils/constantes/rates.dart';

class Pricing {
  static const int prixEuros = 50;
  static const int prixXAF = 30000;

  Map<String, int> get prices {
    Map<String, int> prix = Map<String, int>();

    for (String devise in devises) {
      prix[devise] = devisePrice(rates: ratesJson, devise: devise);
    }

    return prix;
  }

  int devisePrice({required Map<String, dynamic> rates, String? devise}) {
    int prixEuros = 50;
    double rateEuro = rates["EUR"]["value"];

    double prixUS = prixEuros / rateEuro;

    if (rates.containsKey(devise)) {
      return {"XAF", "XOF"}.contains(devise)
          ? prixXAF
          : (prixUS * rates[devise ??= "USD"]["value"]).ceil();
    } else {
      return 100000;
    }
  }

  List<String> get devises {
    return countryList
        .map((c) => c.currencyCode ?? "USD")
        .toList()
        .toSet()
        .toList();
  }

  List<String> get prefsNames {
    return devises.map((devise) => "PRIX_$devise").toList().toSet().toList();
  }
}
