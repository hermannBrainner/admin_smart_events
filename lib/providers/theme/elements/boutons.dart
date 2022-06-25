import 'package:flutter/material.dart';

import 'main.dart';

class BoutonsOfTheme extends ThemeElements {
  final VoidCallback? onPressed;
  final BuildContext context;

  String? textPagination;

  Color? couleur;

  BoutonsOfTheme({
    this.textPagination,
    this.couleur,
    this.onPressed,
    required this.context,
  }) : super(context: context);

  Widget get pagination {
    return Center(
      child: CircleAvatar(
          backgroundColor: ThemeElements(context: context).whichBlue,
          child: Text(textPagination ?? "1")),
    );
  }

  Widget get edit {
    return Center(
      child: CircleAvatar(
        backgroundColor: ThemeElements(context: context).whichBlue,
        child: IconButton(
            onPressed: onPressed,
            icon: Icon(
              Icons.edit,
              color: couleur ?? this.themeColor,
            )),
      ),
    );
  }
}
