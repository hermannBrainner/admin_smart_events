import 'package:flutter/material.dart';

import '/mode_Compte/_models/ceremonie.dart';
import '/outils/extensions/time.dart';
import '/outils/shimmer_widgets/ceremonie.dart';
import 'ceremonie_tile/main.dart';
import 'ceremonie_tile/values.dart';

Widget listing(List<Ceremonie> ceremonies, ScrollController scrollController,
    BuildContext context,
    {required bool isBefore}) {
  List<Ceremonie> filteredCeremonies = isBefore
      ? ceremonies
          .where((ceremonie) => ceremonie.dateCeremonie.isBeforeToday())
          .toList()
      : ceremonies
          .where((ceremonie) => !ceremonie.dateCeremonie.isBeforeToday())
          .toList();

  return Container(
      padding: EdgeInsets.all(20.0),
      child: ListView.builder(
          itemCount: filteredCeremonies.length,
          controller: scrollController,
          itemBuilder: (context, id) {
            return FutureBuilder<Map<String, dynamic>>(
                future: getValues(filteredCeremonies[id]),
                builder: (context, qs) {
                  if (!qs.hasData) {
                    return ceremonieShimmer(context);
                  } else {
                    return ceremonieTile(
                        context, filteredCeremonies[id], qs.data!);
                  }
                });
          }));
}
