import 'package:flutter/widgets.dart';

import 'countries.dart';
import 'country.dart';

class CountryUtils {
  static Country getCountryByIsoCode(String isoCode) {
    try {
      return countryList.firstWhere(
        (country) => country.isoCode!.toLowerCase() == isoCode.toLowerCase(),
      );
    } catch (error) {
      throw Exception("The initialValue provided is not a supported iso code!");
    }
  }

  static String getFlagImageAssetPath(String isoCode) {
    return "assets/${isoCode.toLowerCase()}.png";
  }

  static Widget getDefaultFlagImage(Country country) {
    return Image.asset(
      CountryUtils.getFlagImageAssetPath(country.isoCode!),
      height: 32.0,
      width: 32.0,
      fit: BoxFit.fill,
      package: "country_currency_pickers",
    );
  }

  static Country getCountryByPhoneCode(String phoneCode) {
    try {
      return countryList.firstWhere(
        (country) =>
            country.phoneCode!.toLowerCase() == phoneCode.toLowerCase(),
      );
    } catch (error) {
      throw Exception(
          "The initialValue provided is not a supported phone code!");
    }
  }

  static Country getCountryByCurrencyCode(String currencyCode) {
    try {
      return countryList.firstWhere(
        (country) =>
            country.currencyCode!.toLowerCase() == currencyCode.toLowerCase(),
      );
    } catch (error) {
      throw Exception(
          "The initialValue provided is not a supported currency code!");
    }
  }
}
