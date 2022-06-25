import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const CustomWidget.rectangular(
      {this.width = double.infinity,
      this.shapeBorder = const RoundedRectangleBorder(),
      required this.height});

  const CustomWidget.circular(
      {this.width = double.infinity,
      required this.height,
      this.shapeBorder = const CircleBorder()});

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.primary,
        highlightColor: Theme.of(context).primaryColor,
        period: Duration(seconds: 2),
        child: Container(
          width: width,
          height: height,
          decoration: ShapeDecoration(
            color: Theme.of(context).cardColor,
            shape: shapeBorder,
          ),
        ),
      );
}
