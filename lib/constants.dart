import 'package:flutter/material.dart';

class Constants {
  /*static Curve sizeCurve = Curves.linearToEaseOut,
      sizeReverseCurve = Curves. /*linearToEaseOut*/ easeOutQuad,
      alignmentCurve = Curves.easeOutQuint,
      alignmentReverseCurve = Curves. /*easeInOutSine*/ easeInOutQuad;*/

  static Curve sizeCurve = const Cubic(0.25, 0.46, 0.15, 0.86 /*0.165, 1.0*/),
      sizeReverseCurve = Curves. /*linearToEaseOut*/ easeOutQuad,
      alignmentCurve = Curves.easeOutQuint,
      alignmentReverseCurve = Curves. /*easeInOutSine*/ easeInOutQuad;
}
