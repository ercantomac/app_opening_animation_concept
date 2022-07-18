import 'dart:math';
import 'dart:ui';
import 'package:app_opening_animation_concept/open_window.dart';
import 'package:flutter/cupertino.dart';
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
      darkTheme: ThemeData(brightness: Brightness.dark),
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
  late Size _size = Size.zero;
  final int _numberOfIcons = 16;
  late bool _blur = false;
  late double _squareDimension = 0.0;

  @override
  void initState() {
    super.initState();
    _gridScaleController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
  }

  @override
  void dispose() {
    _gridScaleController.dispose();
    super.dispose();
  }

  Future<bool> swapOrder(int index) {
    _icons.add(_icons.removeAt(index));
    _dragAlignment.add(_dragAlignment.removeAt(index));
    setState(() {});
    return Future<bool>.value(true);
  }

  @override
  Widget build(BuildContext context) {
    if (_size == Size.zero) {
      setState(() {
        _size = MediaQuery.of(context).size;
        _squareDimension = (((sqrt(MediaQuery.of(context).size.width) * sqrt(MediaQuery.of(context).size.height)).floor()) / 8);
      });
    }
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        body: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            RepaintBoundary(
              key: const Key('BackgroundStack'),
              child: ConditionalBlur(
                  _blur,
                  Stack(
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
                                  if (_blur) {
                                    _gridScaleController.forward();
                                    Navigator.of(context)
                                        .push(MyRoute(builder: (BuildContext context) => OpenWindow(heroTag: '$i _ $i _ hero')))
                                        .then((value) {
                                      _gridScaleController.reverse();
                                    });
                                  } else {
                                    Navigator.of(context).push(
                                        MyRoute(builder: (BuildContext context) => OpenWindow(heroTag: '$i _ $i _ hero')));
                                  }
                                },
                                child: Align(
                                  key: Key('child_$i'),
                                  alignment: _dragAlignment[i],
                                  child: Hero(
                                    tag: '$i _ $i _ hero',
                                    createRectTween: (Rect? begin, Rect? end) {
                                      return CustomRectTween(begin: begin!, end: end!);
                                    },
                                    flightShuttleBuilder: (BuildContext flightContext,
                                        Animation<double> animation,
                                        HeroFlightDirection direction,
                                        BuildContext fromHeroContext,
                                        BuildContext toHeroContext) {
                                      return (direction == HeroFlightDirection.push)
                                          ? Stack(
                                              children: <Widget>[
                                                Center(child: toHeroContext.widget),
                                                Center(
                                                  child: FadeTransition(
                                                    opacity: animation.drive(Tween<double>(begin: 1.0, end: 0.0)),
                                                    child: ScaleTransition(
                                                        scale: CurvedAnimation(parent: animation, curve: Constants.sizeCurve)
                                                            .drive(Tween<double>(begin: 1.0, end: 3.0)),
                                                        child: fromHeroContext.widget),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : toHeroContext.widget;
                                    },
                                    child: Container(
                                      width: _squareDimension,
                                      height: _squareDimension,
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: ShapeDecoration(
                                          color: Colors.grey.shade900,
                                          shape: ContinuousRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular((_squareDimension / 1.5))))),
                                      child: Image(image: AssetImage(_icons[i]), width: 384),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  )),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SwitchListTile.adaptive(
                tileColor: Colors.grey.shade900,
                activeColor: const Color.fromRGBO(243, 230, 0, 1.0),
                value: _blur,
                onChanged: (bool a) {
                  setState(() {
                    _blur = !_blur;
                  });
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
    );
  }

  Widget ConditionalBlur(bool shouldWrap, Widget child) {
    return shouldWrap
        ? AnimatedBuilder(
            animation: _gridScaleController,
            builder: (BuildContext context, Widget? child2) {
              return ImageFiltered(
                  imageFilter: ImageFilter.blur(
                    sigmaX: (CurvedAnimation(
                              parent: _gridScaleController,
                              curve: Curves.easeOutQuad,
                              reverseCurve: Curves.easeInOut,
                            ).value * /*4*/ 6) +
                        0.001,
                    sigmaY: (CurvedAnimation(
                              parent: _gridScaleController,
                              curve: Curves.easeOutQuad,
                              reverseCurve: Curves.easeInOut,
                            ).value * /*4*/ 6) +
                        0.001,
                  ),
                  child: child2);
            },
            child: child,
          )
        : child;
  }
}

class MyRoute<T> extends CupertinoPageRoute<T> {
  MyRoute({dynamic builder}) : super(builder: builder);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 800);
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
