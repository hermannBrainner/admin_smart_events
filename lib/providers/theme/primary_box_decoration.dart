import 'package:flutter/material.dart';

BoxDecorationBlue(BuildContext context,
    {required double topRigth,
    required double topLeft,
    required double bottomRigth,
    required double bottomLeft}) {
  return BoxDecoration(
      color: Theme.of(context).colorScheme.primary,
      borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(bottomRigth),
          bottomLeft: Radius.circular(bottomLeft),
          topRight: Radius.circular(topRigth),
          topLeft: Radius.circular(topLeft)));
}

BoxDecorationPrimary(BuildContext context,
    {required double topRigth,
    required double topLeft,
    required double bottomRigth,
    required double bottomLeft}) {
  return BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(bottomRigth),
          bottomLeft: Radius.circular(bottomLeft),
          topRight: Radius.circular(topRigth),
          topLeft: Radius.circular(topLeft)));
}
