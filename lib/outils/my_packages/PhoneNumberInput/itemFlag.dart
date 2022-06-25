import 'package:flutter/material.dart';

import './utils/country.dart';
import '../../../providers/theme/elements/main.dart';
import 'utils/main.dart';

class ItemFlag extends StatelessWidget {
  final Country country;
  const ItemFlag({Key? key, required this.country}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String phoneCode = (country.phoneCode ?? '');
    phoneCode = phoneCode.padRight(5, "   ");

    return Container(
      child: Row(
        textDirection: TextDirection.ltr,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(width: 12),
          flag(country),
          SizedBox(width: 12.0),
          Text(
            '$phoneCode',
            textDirection: TextDirection.ltr,
            style: ThemeElements(
              context: context,
            ).styleText(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

Widget flag(Country country) {
  return Container(
    width: 32,
    height: 32,
    child: Transform.scale(
      scaleX: 1,
      scaleY: 1,
      child: CountryUtils.getDefaultFlagImage(country),
    ),
  );
}
