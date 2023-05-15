import 'package:app_launch_animation/springy_curve.dart';
import 'package:flutter/material.dart';

class Constants {
  //final Curve m3EmphasizedDecelerate = const Cubic(0.05, 0.7, 0.1, 1.0);
  //Cubic(0.18, 1.0, 0.15, 0.86) => FASTER ON START => MORE DRAMATIC DECELERATION
  //Cubic(0.35, 0.91, 0.15, 0.86) => SLOWER ON START => MORE NATURAL DECELERATION
  //Cubic(0.25, 0.46, 0.15, 0.86) => EVEN SLOWER ON START => VERY NATURAL DECELERATION
  /*static Curve sizeCurve = const Cubic(0.25, 0.46, 0.15, 0.86),
      sizeReverseCurve = const Cubic(0.25, 0.46, 0.15, 0.86),
      alignmentCurve = const Cubic(0.18, 1.0, 0.15, 0.86),
      alignmentReverseCurve = const Cubic(0.25, 0.46, 0.15, 0.86);*/

/*  static const Curve sizeCurve = Cubic(0.25, 0.1, 0.25, 1.0),
      sizeReverseCurve = Curves.easeOutCubic,
      alignmentCurve = Curves.easeOutCubic,
      alignmentReverseCurve = Cubic(0.25, 0.1, 0.25, 1.0);*/

  /*static const Curve sizeCurve = /*Curves.easeOutCubic*/ Curves.easeOutQuart,
      sizeReverseCurve = Cubic(0.05, 0.7, 0.1, 1.0),
      alignmentCurve = Cubic(0.05, 0.7, 0.1, 1.0),
      alignmentReverseCurve = /*Curves.easeOutCubic*/ Curves.easeOutQuart;*/

  static Curve sizeCurve = SpringyCurve.custom(
        mass: 3.0,
        stiffness: 10.0,
        damping: 5.0,
        velocity: 0.0,
      ),
      sizeReverseCurve = Curves.fastEaseInToSlowEaseOut,
      alignmentCurve = Curves.fastEaseInToSlowEaseOut,
      alignmentReverseCurve = SpringyCurve.custom(
        mass: 3.0,
        stiffness: 10.0,
        damping: 5.0,
        velocity: 0.0,
      );

/*static Curve sizeCurve = SpringyCurve.custom(
        mass: 3.0,
        stiffness: 10.0,
        damping: 5.0,
        velocity: 0.0,
      ),
      sizeReverseCurve = SpringyCurve.custom(
        mass: 3.0,
        stiffness: 10.0,
        damping: 5.0,
        velocity: 0.0,
      ),
      alignmentCurve = SpringyCurve.custom(
        mass: 3.0,
        stiffness: 10.0,
        damping: 5.0,
        velocity: 0.0,
      ),
      alignmentReverseCurve = SpringyCurve.custom(
        mass: 3.0,
        stiffness: 10.0,
        damping: 5.0,
        velocity: 0.0,
      );*/
}
