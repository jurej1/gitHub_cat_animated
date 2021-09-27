import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CatPainter extends CustomPainter {
  final double animatedValue;

  CatPainter(
    this.animatedValue,
  );

  @override
  void paint(Canvas canvas, Size size) {
    Path path = _drawCat(canvas, size);

    Path animatedPath = createAnimatedPath(path, (animatedValue / 0.92).clamp(0, 1));

    canvas.drawPath(
      animatedPath,
      Paint()
        ..color = Colors.green
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );

    Path animatedPathDelayed = createAnimatedPath(path, (animatedValue - 0.08) / 0.92);

    canvas.drawPath(
      animatedPathDelayed,
      Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  Path _drawCat(Canvas canvas, Size size) {
    Path path = Path()..moveTo(size.width * 0.69, size.height); //1

    //2
    path.lineTo(size.width * 0.69, size.height * 0.62);
    //3
    path.cubicTo(
      size.width, // play with this value
      size.height * 0.62, // play with this value
      size.width, // play with this value
      size.height * 0.17, // play with this value
      size.width * 0.79,
      size.height * 0.13,
    );

    //4
    path.lineTo(size.width * 0.81, 0);

    //5
    path.lineTo(size.width * 0.71, size.height * 0.11);

    //6
    path.quadraticBezierTo(
      size.width * 0.54,
      size.height * 0.08,
      size.width * 0.385,
      size.height * 0.11,
    );

    //7
    path.lineTo(
      size.width * 0.28,
      0,
    );

    //8
    path.lineTo(
      size.width * 0.305,
      size.height * 0.13,
    );

    //9
    path.cubicTo(
      size.width * 0.12,
      size.height * 0.16,
      size.width * 0.12,
      size.height * 0.62,
      size.width * 0.41,
      size.height * 0.62,
    );

    // 10
    path.lineTo(size.width * 0.41, size.height);

    //11
    path.moveTo(size.width * 0.41, size.height * 0.87);

    path.cubicTo(
      size.width * 0.1,
      size.height * 0.87,
      size.width * 0.3,
      size.height * 0.69,
      size.width * 0.075,
      size.height * 0.69,
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4,
    );

    return path;
  }

  Path createAnimatedPath(
    Path originalPath,
    double animationValue,
  ) {
    // the total lenght of the cat path
    final double totalLength = originalPath.computeMetrics().fold(0.0, (double prev, metric) => prev + metric.length);

    final currentLength = totalLength * animationValue; // current animated
    return extractPathUntilLength(originalPath, currentLength);
  }

  Path extractPathUntilLength(
    Path originalPath,
    double length,
  ) {
    var currentLength = 0.0;
    final path = Path();

    var metricsIterator = originalPath.computeMetrics().iterator;

    while (metricsIterator.moveNext()) {
      var metric = metricsIterator.current;
      var nextLength = currentLength + metric.length;
      final isLastSegment = nextLength > length;

      if (isLastSegment) {
        final remainingLength = length - currentLength;
        final pathSegment = metric.extractPath(0.0, remainingLength);

        path.addPath(pathSegment, Offset.zero);
        break;
      } else {
        final pathSegment = metric.extractPath(0.0, metric.length);
        path.addPath(pathSegment, Offset.zero);
      }
      currentLength = nextLength;
    }
    return path;
  }
}
