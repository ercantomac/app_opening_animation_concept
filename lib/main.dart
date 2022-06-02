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
  final List<Image> _icons = <Image>[
    Image(image: AssetImage('assets/Discord.png'), width: 384),
    Image(image: AssetImage('assets/Instagram.png'), width: 384),
    Image(image: AssetImage('assets/Reddit.png'), width: 384),
    Image(image: AssetImage('assets/Spotify.png'), width: 384),
    Image(image: AssetImage('assets/YouTube.png'), width: 384),
    Image(image: AssetImage('assets/Discord.png'), width: 384),
    Image(image: AssetImage('assets/Instagram.png'), width: 384),
    Image(image: AssetImage('assets/Reddit.png'), width: 384),
    Image(image: AssetImage('assets/Spotify.png'), width: 384),
    Image(image: AssetImage('assets/YouTube.png'), width: 384),
    Image(image: AssetImage('assets/Discord.png'), width: 384),
    Image(image: AssetImage('assets/Instagram.png'), width: 384),
    Image(image: AssetImage('assets/Reddit.png'), width: 384),
    Image(image: AssetImage('assets/Spotify.png'), width: 384),
    Image(image: AssetImage('assets/YouTube.png'), width: 384),
    Image(image: AssetImage('assets/Discord.png'), width: 384)
  ];
  late Size _size = Size.zero;
  final int _numberOfIcons = 16;
  late bool _blur = false;
  late double _squareDimension = 0.0;

  @override
  void initState() {
    super.initState();
    _gridScaleController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _controller = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _alignController = AnimationController(duration: const Duration(milliseconds: 400), reverseDuration: const Duration(milliseconds: 600), vsync: this);
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
    _icons.add(_icons.removeAt(index));
    _dragAlignment.add(_dragAlignment.removeAt(index));
    _randomColors.add(_randomColors.removeAt(index));
    _alignmentAnimation = CurvedAnimation(
      parent: _alignController,
      curve: Curves.fastLinearToSlowEaseIn,
      reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
    ).drive(AlignmentTween(begin: _dragAlignment.last, end: Alignment.center));
    _widthAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubicEmphasized,
      reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
    ).drive(Tween<double>(begin: _squareDimension, end: (MediaQuery.of(context).size.width)));
    _heightAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubicEmphasized,
      reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
    ).drive(Tween<double>(begin: _squareDimension, end: (MediaQuery.of(context).size.height)));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_size == Size.zero) {
      setState(() {
        _size = MediaQuery.of(context).size;
        _squareDimension = (((sqrt(MediaQuery.of(context).size.width) * sqrt(MediaQuery.of(context).size.height)).floor()) / 8);
        _widthValue = _squareDimension;
        _heightValue = _squareDimension;
        _alignmentAnimation = CurvedAnimation(
          parent: _alignController,
          curve: Curves.fastLinearToSlowEaseIn,
          reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
        ).drive(AlignmentTween(begin: _dragAlignment.last, end: Alignment.center));
        _widthAnimation = CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOutCubicEmphasized,
          reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
        ).drive(Tween<double>(begin: _squareDimension, end: (MediaQuery.of(context).size.width)));
        _heightAnimation = CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOutCubicEmphasized,
          reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
        ).drive(Tween<double>(begin: _squareDimension, end: (MediaQuery.of(context).size.height)));
        _gridAnimation = CurvedAnimation(
          parent: _gridScaleController,
          curve: Curves.linearToEaseOut,
          reverseCurve: Curves.easeInToLinear,
        ).drive(Tween<double>(begin: 1.0, end: 0.85));
      });
    }
    return WillPopScope(
      onWillPop: () async {
        if (_controller.isCompleted) {
          _alignmentAnimation = CurvedAnimation(
            parent: _alignController,
            curve: Curves.fastLinearToSlowEaseIn,
            reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
          ).drive(AlignmentTween(begin: _dragAlignment.last, end: Alignment.topCenter));
          _controller.reverse();
          _alignController.reverse();
          _gridScaleController.reverse();
        }
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          body: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              ScaleTransition(
                scale: _gridAnimation,
                child: (_blur)
                    ? AnimatedBuilder(
                        animation: _controller,
                        builder: (BuildContext context, Widget? child2) {
                          return ImageFiltered(
                              imageFilter: ImageFilter.blur(
                                  sigmaX: CurvedAnimation(
                                    parent: _gridScaleController,
                                    curve: Curves.easeInOut,
                                    reverseCurve: Curves.easeInOut.flipped,
                                  ).drive(Tween<double>(begin: 0.0, end: 6.0)).value,
                                  sigmaY: CurvedAnimation(
                                    parent: _gridScaleController,
                                    curve: Curves.easeInOut,
                                    reverseCurve: Curves.easeInOut.flipped,
                                  ).drive(Tween<double>(begin: 0.0, end: 6.0)).value),
                              child: child2);
                        },
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
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: ShapeDecoration(
                                              //color: _randomColors[i],
                                              color: Colors.grey.shade900,
                                              shape: ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular((_squareDimension / 1.5))))),
                                          child: _icons[i],
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Stack(
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
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: ShapeDecoration(
                                            //color: _randomColors[i],
                                            color: Colors.grey.shade900,
                                            shape: ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular((_squareDimension / 1.5))))),
                                        child: _icons[i],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
              ),
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
                          padding: const EdgeInsets.all(8.0),
                          decoration: ShapeDecoration(
                              //color: _randomColors.last,
                              color: Colors.grey.shade900,
                              shape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(CurvedAnimation(
                                parent: _gridScaleController,
                                curve: Curves.linearToEaseOut,
                                reverseCurve: Curves.easeInToLinear,
                              ).drive(Tween<double>(begin: (_squareDimension / 1.5), end: 0.0)).value)))),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            switchInCurve: Curves.easeInOut,
                            switchOutCurve: Curves.easeInOut,
                            child: (!_controller.isDismissed && !(_controller.status == AnimationStatus.reverse))
                                ? Stack(
                                    children: <Align>[
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: IconButton(
                                          onPressed: () {
                                            if (_controller.isCompleted) {
                                              _alignmentAnimation = CurvedAnimation(
                                                parent: _alignController,
                                                curve: Curves.fastLinearToSlowEaseIn,
                                                reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
                                              ).drive(AlignmentTween(begin: _dragAlignment.last, end: Alignment.topCenter));
                                              _controller.reverse();
                                              _alignController.reverse();
                                              _gridScaleController.reverse();
                                            }
                                          },
                                          padding: const EdgeInsets.all(16.0),
                                          icon: const Icon(Icons.clear_rounded),
                                          iconSize: 32.0,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: GestureDetector(
                                          onPanUpdate: (DragUpdateDetails details) {
                                            if (details.delta.dy < 0) {
                                              if (_alignmentValue.x > (-1) &&
                                                  _alignmentValue.y > (-1) &&
                                                  _widthValue > _squareDimension &&
                                                  _heightValue > _squareDimension) {
                                                setState(() {
                                                  _widthValue += (details.delta.dy);
                                                  //_heightValue += (details.delta.dy);
                                                  _heightValue -= 1;
                                                  _alignmentValue += Alignment((details.delta.dx / _size.width), (details.delta.dy / _size.height));
                                                });
                                              }
                                            } else {
                                              if (_alignmentValue.x < 1 && _alignmentValue.y < 1 && _widthValue < _size.width && _heightValue < _size.height) {
                                                setState(() {
                                                  _widthValue += (details.delta.dy);
                                                  //_heightValue += (details.delta.dy);
                                                  _heightValue += 1;
                                                  _alignmentValue += Alignment((details.delta.dx / _size.width), (details.delta.dy / _size.height));
                                                });
                                              }
                                            }
                                          },
                                          onPanEnd: (DragEndDetails details) {
                                            if (details.velocity.pixelsPerSecond.dy < (-200) || _controller.value < 0.65) {
                                              _alignmentAnimation = CurvedAnimation(
                                                parent: _alignController,
                                                curve: Curves.fastLinearToSlowEaseIn,
                                                reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
                                              ).drive(AlignmentTween(begin: _dragAlignment.last, end: _alignmentValue));
                                              _widthAnimation = CurvedAnimation(
                                                parent: _controller,
                                                curve: Curves.easeInOutCubicEmphasized,
                                                reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
                                              ).drive(Tween<double>(begin: _squareDimension, end: _widthValue));
                                              _heightAnimation = CurvedAnimation(
                                                parent: _controller,
                                                curve: Curves.easeInOutCubicEmphasized,
                                                reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
                                              ).drive(Tween<double>(begin: _squareDimension, end: _heightValue));
                                              _controller.reverse();
                                              _alignController.reverse();
                                              _gridScaleController.reverse();
                                            } else {
                                              _alignmentAnimation = CurvedAnimation(
                                                parent: _alignController,
                                                curve: Curves.fastLinearToSlowEaseIn,
                                                reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
                                              ).drive(AlignmentTween(begin: _alignmentValue, end: Alignment.center));
                                              _widthAnimation = CurvedAnimation(
                                                parent: _controller,
                                                curve: Curves.easeInOutCubicEmphasized,
                                                reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
                                              ).drive(Tween<double>(begin: _widthValue, end: (MediaQuery.of(context).size.width)));
                                              _heightAnimation = CurvedAnimation(
                                                parent: _controller,
                                                curve: Curves.easeInOutCubicEmphasized,
                                                reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
                                              ).drive(Tween<double>(begin: _heightValue, end: (MediaQuery.of(context).size.height)));
                                              _controller.forward(from: 0.0);
                                              _alignController.forward(from: 0.0);
                                            }
                                          },
                                          child: child,
                                        ),
                                      ),
                                    ],
                                  )
                                : _icons.last,
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
        ),
      ),
    );
  }
}
