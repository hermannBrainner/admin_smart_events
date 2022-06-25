import 'package:flutter/material.dart';

import '/mode_Compte/_models/billet.dart';
import '/mode_Compte/stats/datas/billet.dart';

class IndicatorsWidget extends StatelessWidget {
  List<Billet> billets;

  IndicatorsWidget({required this.billets});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: DataInvites.fromBillets(billets)
            .map(
              (data) => Container(
                  padding: EdgeInsets.symmetric(vertical: 2),
                  child: buildIndicator(
                    color: data.color,
                    text: data.name,
                    // isSquare: true,
                  )),
            )
            .toList(),
      );

  Widget buildIndicator({
    required Color color,
    required String text,
    bool isSquare = false,
    double size = 16,
    Color textColor = const Color(0xff505050),
  }) =>
      Row(
        children: <Widget>[
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          )
        ],
      );
}
