import 'package:flutter/material.dart';

class Constants {
  //Cubic(0.18, 1.0, 0.15, 0.86) => FASTER ON START => MORE DRAMATIC DECELERATION
  //Cubic(0.35, 0.91, 0.15, 0.86) => SLOWER ON START => MORE NATURAL DECELERATION
  static Curve sizeCurve = const Cubic(0.35, 0.91, 0.15, 0.86),
      sizeReverseCurve = const Cubic(0.35, 0.91, 0.15, 0.86),
      alignmentCurve = const Cubic(0.35, 0.91, 0.15, 0.86),
      alignmentReverseCurve = const Cubic(0.35, 0.91, 0.15, 0.86);

/*static Curve sizeCurve = const Cubic(0.25, 0.46, 0.15, 0.86),
      sizeReverseCurve = Curves.linearToEaseOut,
      alignmentCurve = Curves.easeOutQuint,
      alignmentReverseCurve = const Cubic(0.25, 0.46, 0.15, 0.86);*/

/*static Curve sizeCurve = const Cubic(0.25, 0.46, 0.15, 0.86),
      sizeReverseCurve = const Cubic(0.25, 0.46, 0.15, 0.86),
      alignmentCurve = Curves.easeOutQuint,
      alignmentReverseCurve = const Cubic(0.25, 0.46, 0.15, 0.86);*/
}
