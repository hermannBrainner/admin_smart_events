import 'dart:ui';

import 'package:flutter/widgets.dart';

class CustomRectTween extends RectTween {
  final Rect begin;

  final Rect end;

  CustomRectTween({
    required this.begin,
    required this.end,
  }) : super(begin: begin, end: end);

  @override
  Rect lerp(double t) {
    final elasticCurveValue = Curves.easeOut.transform(t);
    return Rect.fromLTRB(
      lerpDouble(this.begin.left, end.left, elasticCurveValue) as double,
      lerpDouble(this.begin.top, end.top, elasticCurveValue) as double,
      lerpDouble(this.begin.right, end.right, elasticCurveValue) as double,
      lerpDouble(this.begin.bottom, end.bottom, elasticCurveValue) as double,
    );
  }
}
