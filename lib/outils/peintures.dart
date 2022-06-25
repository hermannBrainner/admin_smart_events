import 'package:flutter/material.dart';

class toileBas extends CustomPainter {
  final BuildContext context;

  toileBas({required this.context});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Theme.of(context).colorScheme.primary; // Colors.green[800]!;

    paint.style = PaintingStyle.fill;

    var pathBas = Path();

    pathBas.moveTo(0, size.height * 0.9167);
    pathBas.quadraticBezierTo(size.width * 0.25, size.height * 0.875,
        size.width * 0.5, size.height * 0.9167);
    pathBas.quadraticBezierTo(size.width * 0.75, size.height * 0.9584,
        size.width * 1.0, size.height * 0.9167);
    pathBas.lineTo(size.width, size.height);
    pathBas.lineTo(0, size.height);

    canvas.drawPath(pathBas, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class toileHaut extends CustomPainter {
  final BuildContext context;

  toileHaut(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Theme.of(context).colorScheme.primary; // Colors.green[800];
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * 0.12);
    path.quadraticBezierTo(
        size.width / 2, size.height * 0.24, size.width, size.height * 0.12);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class toileHautetBas extends CustomPainter {
  final BuildContext context;

  toileHautetBas(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Theme.of(context).colorScheme.primary; // Colors.green[800];
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height * 0.12);
    path.quadraticBezierTo(
        size.width / 2, size.height * 0.24, size.width, size.height * 0.12);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);

    var pathBas = Path();

    pathBas.moveTo(0, size.height * 0.9167);
    pathBas.quadraticBezierTo(size.width * 0.25, size.height * 0.875,
        size.width * 0.5, size.height * 0.9167);
    pathBas.quadraticBezierTo(size.width * 0.75, size.height * 0.9584,
        size.width * 1.0, size.height * 0.9167);
    pathBas.lineTo(size.width, size.height);
    pathBas.lineTo(0, size.height);

    canvas.drawPath(pathBas, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
