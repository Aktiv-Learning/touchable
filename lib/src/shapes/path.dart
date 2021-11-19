import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:touchable/src/shapes/shape.dart';
import 'package:touchable/src/types/types.dart';

class PathShape extends Shape {
  final Path path;

  PathShape(this.path,
      {required Map<GestureType, Function> gestureMap,
      required Paint paint,
      HitTestBehavior? hitTestBehavior,
      PaintingStyle? paintStyleForTouch})
      : super(
            hitTestBehavior: hitTestBehavior,
            paint: paint,
            gestureCallbackMap: gestureMap);

  @override
  bool isInside(Offset p) {
    if (paint.style == PaintingStyle.stroke) {
      PathMetrics pathMetrics = path.computeMetrics();
      double touchRange = paint.strokeWidth / 2;
      // Check if p is within [touchRange] of any point along
      // any of the paths
      for (PathMetric metric in pathMetrics) {
        for (int i = 0; i < metric.length; i++) {
          Tangent? tangent = metric.getTangentForOffset(i.toDouble());
          if (tangent == null) continue;
          Offset pointOnPath = tangent.position;
          bool isPathTouched = (p - pointOnPath).distance <= touchRange;
          if (isPathTouched) return true;
        }
      }
      return false;
    } else {
      return path.contains(p);
    }
  }
}
