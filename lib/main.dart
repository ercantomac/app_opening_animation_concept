import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Opening Animation Concept',
      color: Constants.primaryColor,
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Constants.primaryColor,
          secondary: Constants.primaryColor,
          tertiary: Constants.primaryColor,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Constants.primaryColor,
          secondary: Constants.primaryColor,
          tertiary: Constants.primaryColor,
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late AnimationController _gridScaleController;
  late AnimationController _controller, _alignController;
  late Animation<double> _widthAnimation, _heightAnimation, _gridAnimation;
  late Animation<Alignment> _alignmentAnimation;
  late Alignment _alignmentValue = const Alignment((2 / 4) + 0.4, (2 / 4) + 0.1);
  late double _widthValue, _heightValue;
  final List<Alignment> _dragAlignment = <Alignment>[
    const Alignment((-4 / 4) + 0.1, -0.9),
    const Alignment((-2 / 4) + 0.2, -0.9),
    const Alignment(0.3, -0.9),
    const Alignment((2 / 4) + 0.4, -0.9),
    const Alignment((-4 / 4) + 0.1, (-2 / 4) + 0.1),
    const Alignment((-2 / 4) + 0.2, (-2 / 4) + 0.1),
    const Alignment(0.3, (-2 / 4) + 0.1),
    const Alignment((2 / 4) + 0.4, (-2 / 4) + 0.1),
    const Alignment((-4 / 4) + 0.1, 0.1),
    const Alignment((-2 / 4) + 0.2, 0.1),
    const Alignment(0.3, 0.1),
    const Alignment((2 / 4) + 0.4, 0.1),
    const Alignment((-4 / 4) + 0.1, (2 / 4) + 0.1),
    const Alignment((-2 / 4) + 0.2, (2 / 4) + 0.1),
    const Alignment(0.3, (2 / 4) + 0.1),
    const Alignment((2 / 4) + 0.4, (2 / 4) + 0.1),
  ];
  final List<Color> _randomColors = <Color>[];
  late Size _size = Size.zero;
  final int _numberOfIcons = 16;
  late bool _blur = false;
  late double _squareDimension = 0.0;

  @override
  void initState() {
    super.initState();
    _gridScaleController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _controller = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _alignController = AnimationController(duration: const Duration(milliseconds: 600), reverseDuration: const Duration(milliseconds: 800), vsync: this);
    _controller.addListener(() {
      _widthValue = _widthAnimation.value;
      _heightValue = _heightAnimation.value;
    });
    _alignController.addListener(() {
      _alignmentValue = _alignmentAnimation.value;
    });
    for (int i = 0; i < _numberOfIcons; i++) {
      Color _tmp;
      while (true) {
        _tmp = Colors.primaries[Random().nextInt(Colors.primaries.length)];
        int cnt = 0;
        for (int j = 0; j < _randomColors.length; j++) {
          if (_randomColors[j] == _tmp) {
            cnt++;
            break;
          }
        }
        if (cnt == 0) {
          break;
        }
      }
      _randomColors.add(_tmp);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _gridScaleController.dispose();
    _alignController.dispose();
    super.dispose();
  }

  void swapOrder(int index) {
    _dragAlignment.add(_dragAlignment.removeAt(index));
    _randomColors.add(_randomColors.removeAt(index));
    _alignmentAnimation = CurvedAnimation(
      parent: _alignController,
      curve: /*Curves.linearToEaseOut*/ Curves.fastLinearToSlowEaseIn,
      reverseCurve: Curves.easeInToLinear,
    ).drive(AlignmentTween(begin: _dragAlignment.last, end: Alignment.center));
    _widthAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastLinearToSlowEaseIn /*Curves.easeOutExpo*/,
      reverseCurve: Curves.fastLinearToSlowEaseIn.flipped /*Curves.easeInToLinear*/,
    ).drive(Tween<double>(begin: _squareDimension, end: (MediaQuery.of(context).size.width)));
    _heightAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastLinearToSlowEaseIn /*Curves.easeOutExpo*/,
      reverseCurve: Curves.fastLinearToSlowEaseIn.flipped /*Curves.easeInToLinear*/,
    ).drive(Tween<double>(begin: _squareDimension, end: (MediaQuery.of(context).size.height)));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_size == Size.zero) {
      setState(() {
        _size = MediaQuery.of(context).size;
        _squareDimension = (((sqrt(MediaQuery.of(context).size.width) * sqrt(MediaQuery.of(context).size.height)).floor()) / 7);
        _widthValue = _squareDimension;
        _heightValue = _squareDimension;
        _alignmentAnimation = CurvedAnimation(
          parent: _alignController,
          curve: /*Curves.linearToEaseOut*/ Curves.fastLinearToSlowEaseIn,
          reverseCurve: Curves.easeInToLinear,
        ).drive(AlignmentTween(begin: _dragAlignment.last, end: Alignment.center));
        _widthAnimation = CurvedAnimation(
          parent: _controller,
          curve: Curves.fastLinearToSlowEaseIn /*Curves.easeOutExpo*/,
          reverseCurve: Curves.fastLinearToSlowEaseIn.flipped /*Curves.easeInToLinear*/,
        ).drive(Tween<double>(begin: _squareDimension, end: (MediaQuery.of(context).size.width)));
        _heightAnimation = CurvedAnimation(
          parent: _controller,
          curve: Curves.fastLinearToSlowEaseIn /*Curves.easeOutExpo*/,
          reverseCurve: Curves.fastLinearToSlowEaseIn.flipped /*Curves.easeInToLinear*/,
        ).drive(Tween<double>(begin: _squareDimension, end: (MediaQuery.of(context).size.height)));
        _gridAnimation = CurvedAnimation(
          parent: _gridScaleController,
          curve: Curves.linearToEaseOut,
          reverseCurve: Curves.easeInToLinear,
        ).drive(Tween<double>(begin: 1.0, end: 0.85));
      });
    }
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: SwitchListTile.adaptive(
              tileColor: Colors.grey.shade900,
              activeColor: Constants.primaryColor,
              value: _blur,
              onChanged: (bool a) {
                setState(() {
                  _blur = !_blur;
                });
              },
              title: const Text(
                'Enable Blur',
                textAlign: TextAlign.center,
                style: TextStyle(color: Constants.primaryColor, fontWeight: FontWeight.w600),
              ),
              subtitle: const Text(
                '(Can cause low performance)',
                textAlign: TextAlign.center,
                style: TextStyle(color: Constants.primaryColor),
              ),
            ),
          ),
          ScaleTransition(
            scale: _gridAnimation,
            child: (_blur)
                ? AnimatedBuilder(
                    animation: _controller,
                    builder: (BuildContext context, Widget? child2) {
                      return ImageFiltered(
                          imageFilter: ImageFilter.blur(
                              sigmaX: CurvedAnimation(
                                //parent: _controller,
                                parent: _gridScaleController,
                                curve: /*Curves.linearToEaseOut*/ Curves.easeInOut,
                                reverseCurve: /*Curves.easeInToLinear*/ Curves.easeInOut.flipped,
                              ).drive(Tween<double>(begin: 0.001, end: 6.0)).value,
                              sigmaY: CurvedAnimation(
                                //parent: _controller,
                                parent: _gridScaleController,
                                curve: /*Curves.linearToEaseOut*/ Curves.easeInOut,
                                reverseCurve: /*Curves.easeInToLinear*/ Curves.easeInOut.flipped,
                              ).drive(Tween<double>(begin: 0.001, end: 6.0)).value),
                          child: child2);
                    },
                    child: Stack(
                      children: <RepaintBoundary>[
                        for (int i = 0; i < _numberOfIcons - 1; i++)
                          RepaintBoundary(
                            key: Key('$i _ $i'),
                            child: GestureDetector(
                              onTap: () {
                                if (_controller.isDismissed) {
                                  swapOrder(i);
                                  _controller.forward();
                                  _alignController.forward();
                                  _gridScaleController.forward();
                                }
                              },
                              child: Align(
                                key: Key('child_$i'),
                                alignment: _dragAlignment[i],
                                child: Container(
                                  width: _squareDimension,
                                  height: _squareDimension,
                                  decoration: ShapeDecoration(
                                      color: _randomColors[i],
                                      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular((_squareDimension / 1.5))))),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
                : Stack(
                    children: <RepaintBoundary>[
                      for (int i = 0; i < _numberOfIcons - 1; i++)
                        RepaintBoundary(
                          key: Key('$i _ $i'),
                          child: GestureDetector(
                            onTap: () {
                              if (_controller.isDismissed) {
                                swapOrder(i);
                                _controller.forward();
                                _alignController.forward();
                                _gridScaleController.forward();
                              }
                            },
                            child: Align(
                              key: Key('child_$i'),
                              alignment: _dragAlignment[i],
                              child: Container(
                                width: _squareDimension,
                                height: _squareDimension,
                                decoration: ShapeDecoration(
                                    color: _randomColors[i],
                                    shape: ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular((_squareDimension / 1.5))))),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
          RepaintBoundary(
            key: Key('$_numberOfIcons _ $_numberOfIcons'),
            child: GestureDetector(
              onTap: () {
                if (_controller.isDismissed) {
                  swapOrder(_numberOfIcons - 1);
                  _controller.forward();
                  _alignController.forward();
                  _gridScaleController.forward();
                }
              },
              child: AnimatedBuilder(
                key: Key('drag_$_numberOfIcons'),
                animation: _controller,
                builder: (BuildContext context, Widget? child) {
                  return Align(
                    key: Key('child_$_numberOfIcons'),
                    alignment: _alignmentValue,
                    child: Container(
                      width: _widthValue,
                      height: _heightValue,
                      decoration: ShapeDecoration(
                          color: _randomColors.last,
                          shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(CurvedAnimation(
                            //parent: _controller,
                            parent: _gridScaleController,
                            curve: Curves.linearToEaseOut,
                            reverseCurve: Curves.easeInToLinear,
                          ).drive(Tween<double>(begin: (_squareDimension / 1.5), end: 0.0)).value)))),
                      child: Visibility(
                        visible: (!_controller.isDismissed && !(_controller.status == AnimationStatus.reverse)),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                            /*onVerticalDragDown: (DragDownDetails details) {
                              _controller.stop();
                            },*/
                            /*onVerticalDragUpdate: (DragUpdateDetails details) {
                              //print(details.delta.dy);
                              //if (((details.delta.dy == -1.0) && (_controller.value > 0.6)) || ((details.delta.dy == 1.0) && (_controller.value < 1.0))) {
                              setState(() {
                                _widthValue += (details.delta.dy);
                                _heightValue += (details.delta.dy);
                                _alignmentValue += Alignment(/*(details.delta.dx / _size.width)*/ 0, (details.delta.dy / _size.height));
                              });
                              //}
                            },*/
                            onPanUpdate: (DragUpdateDetails details) {
                              if (details.delta.dy < 0) {
                                if (_alignmentValue.x > (-1) && _alignmentValue.y > (-1) && _widthValue > _squareDimension && _heightValue > _squareDimension) {
                                  setState(() {
                                    _widthValue += (details.delta.dy);
                                    _heightValue += (details.delta.dy);
                                    _alignmentValue += Alignment((details.delta.dx / _size.width), (details.delta.dy / _size.height));
                                  });
                                }
                              } else {
                                if (_alignmentValue.x < 1 && _alignmentValue.y < 1 && _widthValue < _size.width && _heightValue < _size.height) {
                                  setState(() {
                                    _widthValue += (details.delta.dy);
                                    _heightValue += (details.delta.dy);
                                    _alignmentValue += Alignment((details.delta.dx / _size.width), (details.delta.dy / _size.height));
                                  });
                                }
                              }
                            },
                            /*onVerticalDragEnd*/ onPanEnd: (DragEndDetails details) {
                              if (details.velocity.pixelsPerSecond.dy < (-200) || _controller.value < 0.65) {
                                _alignmentAnimation = CurvedAnimation(
                                  parent: _alignController,
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  reverseCurve: Curves.easeInToLinear,
                                ).drive(AlignmentTween(begin: _dragAlignment.last, end: _alignmentValue));
                                _widthAnimation = CurvedAnimation(
                                  parent: _controller,
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  reverseCurve: Curves.fastLinearToSlowEaseIn.flipped,
                                ).drive(Tween<double>(begin: _squareDimension, end: _widthValue));
                                _heightAnimation = CurvedAnimation(
                                  parent: _controller,
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  reverseCurve: Curves.fastLinearToSlowEaseIn.flipped,
                                ).drive(Tween<double>(begin: _squareDimension, end: _heightValue));
                                _controller.reverse();
                                _alignController.reverse();
                                _gridScaleController.reverse();
                                /*_controller.animateBack(0.0);
                                _alignController.animateBack(0.0);
                                _gridScaleController.animateBack(0.0);*/
                              } else {
                                _alignmentAnimation = CurvedAnimation(
                                  parent: _alignController,
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  reverseCurve: Curves.easeInToLinear,
                                ).drive(AlignmentTween(begin: _alignmentValue, end: Alignment.center));
                                _widthAnimation = CurvedAnimation(
                                  parent: _controller,
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  reverseCurve: Curves.fastLinearToSlowEaseIn.flipped,
                                ).drive(Tween<double>(begin: _widthValue, end: (MediaQuery.of(context).size.width)));
                                _heightAnimation = CurvedAnimation(
                                  parent: _controller,
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  reverseCurve: Curves.fastLinearToSlowEaseIn.flipped,
                                ).drive(Tween<double>(begin: _heightValue, end: (MediaQuery.of(context).size.height)));
                                _controller.forward(from: 0.0);
                                _alignController.forward(from: 0.0);
                              }
                            },
                            child: child,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: const ShapeDecoration(shape: StadiumBorder()),
                  child: Container(
                    height: 6.0,
                    width: 96.0,
                    decoration: const ShapeDecoration(color: Colors.white, shape: StadiumBorder()),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
