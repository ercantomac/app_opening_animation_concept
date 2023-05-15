import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

class SpringyCurve extends Curve {
  factory SpringyCurve([double damping = 20]) => SpringyCurve.custom(damping: damping);

  /// Provides an **under damped** spring, which wobbles loosely at the end.
  static final SpringyCurve underDamped = SpringyCurve(12);

  /// Provides a **critically damped** spring, which overshoots once very slightly.
  static final SpringyCurve criticallyDamped = SpringyCurve(20);

  /// Provides an **over damped** spring, which smoothly glides into place.
  static final SpringyCurve overDamped = SpringyCurve(28);

  /// Provides a critically damped spring by default, with an easily overrideable damping, stiffness,
  /// mass, and initial velocity value.
  SpringyCurve.custom({
    double damping = 20,
    double stiffness = 180,
    double mass = 1.0,
    double velocity = 0.0,
  }) {
    _sim = SpringSimulation(
      SpringDescription(
        damping: damping,
        mass: mass,
        stiffness: stiffness,
      ),
      0.0,
      1.0,
      velocity,
    );

    _val = (1 - _sim.x(1.0));
  }

  /// The underlying physics simulation.
  late final SpringSimulation _sim;
  late final double _val;

  /// Returns the position from the simulator and corrects the final output `x(1.0)` for tight tolerances.
  @override
  double transform(double t) => _sim.x(t) + t * _val;
}
