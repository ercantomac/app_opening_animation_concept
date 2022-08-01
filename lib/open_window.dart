import 'package:app_opening_animation_concept/constants.dart';
import 'package:flutter/material.dart';

class OpenWindow extends StatelessWidget {
  const OpenWindow({Key? key, required this.heroTag}) : super(key: key);
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      createRectTween: (Rect? begin, Rect? end) {
        return CustomRectTween(begin: begin!, end: end!);
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(30.0)),
        child: Scaffold(
          appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0.0),
        ),
      ),
    );
  }
}

class CustomRectTween extends RectTween {
  CustomRectTween({
    Rect? begin,
    Rect? end,
  }) : super(begin: begin, end: end);

  bool _dirty = true;

  void _initialize() {
    assert(begin != null);
    assert(end != null);
    _centerArc = CustomArcTween(
      begin: begin!.center,
      end: end!.center,
    );
    _dirty = false;
  }

  CustomArcTween? get centerArc {
    if (begin == null || end == null) {
      return null;
    }
    if (_dirty) {
      _initialize();
    }
    return _centerArc;
  }

  late CustomArcTween _centerArc;

  @override
  Rect lerp(double t) {
    if (_dirty) {
      _initialize();
    }
    final double myCurve = Constants.sizeCurve.transform(t);

    final Offset center = _centerArc.lerp(t);
    final double width = lerpDouble(begin!.width, end!.width, myCurve);
    final double height = lerpDouble(begin!.height, end!.height, myCurve);
    return Rect.fromLTWH(center.dx - width / 2.0, center.dy - height / 2.0, width, height);
  }

  double lerpDouble(num a, num b, double myCurve) {
    return a + ((b - a) * myCurve);
  }
}

class CustomArcTween extends Tween<Offset> {
  CustomArcTween({
    Offset? begin,
    Offset? end,
  }) : super(begin: begin, end: end);

  @override
  Offset lerp(double t) {
    final double myCurve = Constants.alignmentCurve.transform(t);

    return Offset(
      (begin!.dx + ((end!.dx - begin!.dx) * myCurve)),
      (begin!.dy + ((end!.dy - begin!.dy) * myCurve)),
    );
  }
}
