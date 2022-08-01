import 'package:flutter/material.dart';

class Constants {
  /*static Curve sizeCurve = Curves.linearToEaseOut,
      sizeReverseCurve = Curves. /*linearToEaseOut*/ easeOutQuad,
      alignmentCurve = Curves.easeOutQuint,
      alignmentReverseCurve = Curves. /*easeInOutSine*/ easeInOutQuad;*/

  /*static Curve sizeCurve = const Cubic(0.25, 0.46, 0.15, 0.86),
      sizeReverseCurve = Curves.easeOutQuad,
      alignmentCurve = Curves.easeOutQuint,
      alignmentReverseCurve = Curves.easeInOutQuad;*/

  static Curve sizeCurve = const Cubic(0.25, 0.46, 0.15, 0.86),
      sizeReverseCurve = Curves.linearToEaseOut,
      alignmentCurve = Curves.easeOutQuint,
      alignmentReverseCurve = const Cubic(0.25, 0.46, 0.15, 0.86);
}
