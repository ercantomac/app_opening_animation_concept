import 'dart:math';
import 'dart:ui';

import 'package:app_launch_animation/open_window.dart';
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
  runApp(MyApp(blurEnabled: true));
}

Route _createRoute(Widget child, bool blur, [bool blurToggle = false]) {
  return PageRouteBuilder(
    transitionDuration: Duration(milliseconds: blurToggle ? 0 : 1000),
    reverseTransitionDuration: Duration(milliseconds: blurToggle ? 0 : 1100),
    //fullscreenDialog: true,
    opaque: false,
    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
      return blur
          ? ScaleTransition(
              scale: Tween(begin: 1.0, end: 0.92).animate(CurvedAnimation(
                parent: secondaryAnimation,
                curve: const Cubic(0.25, 0.1, 0.25, 1.0),
                reverseCurve: const Cubic(0.25, 0.1, 0.25, 1.0).flipped,
              )),
              child: AnimatedBuilder(
                animation: secondaryAnimation,
                builder: (BuildContext context, Widget? child2) {
                  return ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: (CurvedAnimation(
                                parent: secondaryAnimation,
                                curve: Curves.decelerate,
                                reverseCurve: Curves.decelerate.flipped,
                              ).value *
                              6) +
                          0.001,
                      sigmaY: (CurvedAnimation(
                                parent: secondaryAnimation,
                                curve: Curves.decelerate,
                                reverseCurve: Curves.decelerate.flipped,
                              ).value *
                              6) +
                          0.001,
                    ),
                    child: child2,
                  );
                },
                child: child,
              ),
            )
          : child;
    },
    transitionsBuilder:
        (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child2) {
      return child2;
    },
  );
}

class MyApp extends StatefulWidget {
  MyApp({Key? key, required this.blurEnabled}) : super(key: key);
  late bool blurEnabled = true;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Launch Animation Concept',
      navigatorKey: _navKey,
      darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      onGenerateRoute: (RouteSettings settings) {
        return _createRoute(
            SafeArea(
              child: Scaffold(
                extendBody: true,
                extendBodyBehindAppBar: true,
                backgroundColor: Colors.transparent,
                body: Stack(
                  children: <Widget>[
                    MyHomePage(blur: widget.blurEnabled),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SwitchListTile.adaptive(
                        tileColor: Colors.grey.shade900,
                        activeColor: const Color.fromRGBO(243, 230, 0, 1.0),
                        value: widget.blurEnabled,
                        onChanged: (bool a) {
                          setState(() {
                            widget.blurEnabled = !widget.blurEnabled;
                          });
                          _navKey.currentState!
                              .pushReplacement(_createRoute(MyApp(blurEnabled: widget.blurEnabled), widget.blurEnabled, true));
                        },
                        title: const Text(
                          'Enable Blur',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color.fromRGBO(243, 230, 0, 1.0), fontWeight: FontWeight.w600),
                        ),
                        subtitle: const Text(
                          '(Can cause low performance)',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color.fromRGBO(243, 230, 0, 1.0)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            widget.blurEnabled);
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.blur}) : super(key: key);
  final bool blur;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final List<Alignment> _dragAlignment = <Alignment>[
    /*const Alignment((-4 / 4) + 0.1, -0.9),
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
    const Alignment((2 / 4) + 0.4, (2 / 4) + 0.1),*/
    const Alignment(-0.87, -0.87),
    const Alignment(-0.29, -0.87),
    const Alignment(0.29, -0.87),
    const Alignment(0.87, -0.87),
    const Alignment(-0.87, -0.33),
    const Alignment(-0.29, -0.33),
    const Alignment(0.29, -0.33),
    const Alignment(0.87, -0.33),
    const Alignment(-0.87, 0.21),
    const Alignment(-0.29, 0.21),
    const Alignment(0.29, 0.21),
    const Alignment(0.87, 0.21),
    const Alignment(-0.87, 0.75),
    const Alignment(-0.29, 0.75),
    const Alignment(0.29, 0.75),
    const Alignment(0.87, 0.75),
  ];

  final List<String> _icons = <String>[
    'assets/Discord.png',
    'assets/Instagram.png',
    'assets/Reddit.png',
    'assets/Spotify.png',
    'assets/YouTube.png',
    'assets/Discord.png',
    'assets/Instagram.png',
    'assets/Reddit.png',
    'assets/Spotify.png',
    'assets/YouTube.png',
    'assets/Discord.png',
    'assets/Instagram.png',
    'assets/Reddit.png',
    'assets/Spotify.png',
    'assets/YouTube.png',
    'assets/Discord.png',
  ];

  final int _numberOfIcons = 16;
  late double _squareDimension = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      setState(() {
        //_squareDimension = (((sqrt(MediaQuery.of(context).size.width) * sqrt(MediaQuery.of(context).size.height)).floor()) / 8);
        if (MediaQuery.of(context).size.aspectRatio > 1) {
          _squareDimension = 1.33 *
              sqrt(sqrt(MediaQuery.of(context).size.width * MediaQuery.of(context).size.height)) *
              MediaQuery.of(context).size.aspectRatio;
        } else {
          _squareDimension = 1.33 *
              sqrt(sqrt(MediaQuery.of(context).size.width * MediaQuery.of(context).size.height)) /
              MediaQuery.of(context).size.aspectRatio;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        RepaintBoundary(
          key: const Key('BackgroundStack'),
          child: Stack(
            children: <Widget>[
              Center(
                child: OverflowBox(
                  maxWidth: window.physicalSize.width * 2,
                  maxHeight: window.physicalSize.height * 2,
                  child: const Image(
                    image: AssetImage('assets/Wallpaper.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Stack(
                children: <RepaintBoundary>[
                  for (int i = 0; i < _numberOfIcons; i++)
                    RepaintBoundary(
                      key: Key('$i _ $i'),
                      child: GestureDetector(
                        onTap: () async {
                          Navigator.of(context).push(
                            _createRoute(OpenWindow(heroTag: '$i _ $i _ hero', squareDimension: _squareDimension), widget.blur),
                          );
                        },
                        child: Align(
                          key: Key('child_$i'),
                          alignment: _dragAlignment[i],
                          child: Hero(
                            tag: '$i _ $i _ hero',
                            createRectTween: (Rect? begin, Rect? end) {
                              return CustomRectTween(begin: begin!, end: end!);
                            },
                            flightShuttleBuilder: (BuildContext context, Animation<double> animation,
                                HeroFlightDirection direction, BuildContext fromContext, BuildContext toContext) {
                              final Hero toHero = toContext.widget as Hero, fromHero = fromContext.widget as Hero;

                              /*final MediaQueryData? toMediaQueryData = MediaQuery.maybeOf(toContext);
                              final MediaQueryData? fromMediaQueryData = MediaQuery.maybeOf(fromContext);

                              if (toMediaQueryData == null || fromMediaQueryData == null) {
                                return toHero.child;
                              }*/

                              return Stack(
                                fit: StackFit.expand,
                                children: <Widget>[
                                  /*Positioned.fill(
                                    child: direction == HeroFlightDirection.push ? toHero.child : fromHero.child,
                                  ),
                                  Positioned.fill(
                                    child: FadeTransition(
                                      opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOutQuad)
                                          .drive(Tween<double>(begin: 1.0, end: 0.0)),
                                      child: direction == HeroFlightDirection.push ? fromHero.child : toHero.child,
                                    ),
                                  ),*/
                                  direction == HeroFlightDirection.push ? toHero.child : fromHero.child,
                                  FadeTransition(
                                    opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOutQuad)
                                        .drive(Tween<double>(begin: 1.0, end: 0.0)),
                                    child: FittedBox(
                                      child: direction == HeroFlightDirection.push ? fromHero.child : toHero.child,
                                    ),
                                  ),
                                ],
                              );
                            },
                            child: Container(
                              width: _squareDimension,
                              height: _squareDimension,
                              padding: const EdgeInsets.all(8.0),
                              decoration: ShapeDecoration(
                                  color: Theme.of(context).colorScheme.background,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular((_squareDimension / 3))))),
                              child: Image(image: AssetImage(_icons[i]) /*, width: 384*/),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
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
    final double myCurve = Constants.sizeReverseCurve.transform(t);

    /*return Rect.fromLTRB(
      lerpDouble(begin!.left, end!.left, myCurve),
      lerpDouble(begin!.top, end!.top, myCurve),
      lerpDouble(begin!.right, end!.right, myCurve),
      lerpDouble(begin!.bottom, end!.bottom, myCurve),
    );*/

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
    final double myCurve = Constants.alignmentReverseCurve.transform(t);

    return Offset(
      (begin!.dx + ((end!.dx - begin!.dx) * myCurve)),
      (begin!.dy + ((end!.dy - begin!.dy) * myCurve)),
    );
  }
}
