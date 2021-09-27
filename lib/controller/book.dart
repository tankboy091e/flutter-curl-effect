import 'dart:math';

import 'package:book_sample/controller/base.dart';
import 'package:book_sample/model/book.dart';
import 'package:book_sample/model/page.dart';
import 'package:book_sample/repository/book.dart';
import 'package:flutter/material.dart';

class BookController extends BaseController {
  late int _page;

  BookModel? _book;

  late Matrix4 frontRightPageMatrix4;
  late Matrix4 behindLeftPageMatrix4;

  late Matrix4 frontRightPageShadowMatrix4;
  late Matrix4 frontLeftPageShadowMatrix4;
  late Matrix4 behindLeftPageShadowMatrix4;
  late Matrix4 nextFloatingShadowMatrix4;
  late Matrix4 prevFloatingShadowMatrix4;

  late Offset _dragRightPageOffset;
  late Offset _dragLeftPageOffset;

  late double leftPageWidthRatio;
  late double rightPageWidthRatio;

  Alignment get frontLeftPageShadowBegin =>
      Alignment(-1 + 1.8 * pow(rightPageWidthRatio, 0.5), 0.5);

  Alignment get frontLeftPageShadowEnd => const Alignment(1.0, 0.5);

  Alignment get nextFloatingShadowBeign => const Alignment(-1.0, 0.5);

  Alignment get nextfloatingShadowEnd =>
      Alignment(2.0 * pow(1 - nextFloatingShadowMatrix4[0], 3) - 1.0, 0.5);

  Alignment get prevFloatingShadowBegin =>
      Alignment(-1.0 + 1.8 * pow(1 - leftPageWidthRatio, 0.5), 0.5);

  Alignment get prevFloatingShadowEnd => const Alignment(1.0, 0.5);

  double get primaryShadowOpacity => 0.2;

  double get deepShadowOpacity => 0.35;

  double get nextfloatingShadowOpacity =>
      deepShadowOpacity *
      4.0 *
      (1 - nextFloatingShadowMatrix4[0]) *
      (nextFloatingShadowMatrix4[0]);

  double get prevfloatingShadowOpacity =>
      deepShadowOpacity * (-1 * prevFloatingShadowMatrix4[0] + 1);

  late Size _viewportSize;

  late final AnimationController _rightPageAnimationController;
  late final AnimationController _leftPageAnimationController;

  late bool _isLeftPageTurning;
  late bool _isRightPageTurning;

  BookController() {
    _initialize(page: 0);

    _isLeftPageTurning = false;
    _isRightPageTurning = false;
  }

  void _initialize({required int page}) {
    _page = page;

    _dragRightPageOffset = Offset.zero;
    _dragLeftPageOffset = Offset.zero;

    frontRightPageMatrix4 = Matrix4.identity();
    behindLeftPageMatrix4 = Matrix4.identity();

    frontRightPageShadowMatrix4 = Matrix4.identity();
    frontLeftPageShadowMatrix4 = Matrix4.identity();

    behindLeftPageShadowMatrix4 = Matrix4(
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
    );

    nextFloatingShadowMatrix4 = Matrix4(
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
    );

    prevFloatingShadowMatrix4 = Matrix4(
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
    );

    leftPageWidthRatio = 1;
    rightPageWidthRatio = 1;
  }

  void attachTickerProvider(TickerProvider tickerProvider) {
    _rightPageAnimationController = AnimationController(
      vsync: tickerProvider,
      duration: const Duration(milliseconds: 500),
    );

    _rightPageAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_dragRightPageOffset.dx < 0.0) {
          _initialize(page: _page + 2);

          notify();
        }

        _isRightPageTurning = false;
      }
    });

    _leftPageAnimationController = AnimationController(
      vsync: tickerProvider,
      duration: const Duration(milliseconds: 500),
    );

    _leftPageAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_dragLeftPageOffset.dx > 0.0) {
          _initialize(page: _page - 2);

          notify();
        }

        _isLeftPageTurning = false;
      }
    });
  }

  void attachContext(BuildContext context) {
    _viewportSize = MediaQuery.of(context).size;
  }

  PageModel? get frontLeftPage {
    try {
      return _book?.pages[_page];
    } on RangeError {
      return null;
    }
  }

  PageModel? get frontRightPage {
    try {
      return _book?.pages[_page + 1];
    } on RangeError {
      return null;
    }
  }

  PageModel? get behindLeftPage {
    try {
      return _book?.pages[_page - 1];
    } on RangeError {
      return null;
    }
  }

  PageModel? get behindRightPage {
    try {
      return _book?.pages[_page + 2];
    } on RangeError {
      return null;
    }
  }

  PageModel? get backgroundLeftPage {
    try {
      return _book?.pages[_page - 2];
    } on RangeError {
      return null;
    }
  }

  PageModel? get backgroundRightPage {
    try {
      return _book?.pages[_page + 3];
    } on RangeError {
      return null;
    }
  }

  Future<BookModel> loadData() async {
    final data = await BookRepository().retrieveAll();

    _book = data[0];

    return _book!;
  }

  void onLeftPageDragUpdate(DragUpdateDetails details) {
    if (_isRightPageTurning) {
      return;
    }

    _leftPageAnimationController.stop();

    _dragLeftPageOffset += details.delta;

    if (_dragLeftPageOffset.dx < 0.0) {
      _dragLeftPageOffset = Offset(0.0, _dragLeftPageOffset.dy);
    }

    if (_dragLeftPageOffset.dx > _viewportSize.width) {
      _dragLeftPageOffset = Offset(_viewportSize.width, _dragLeftPageOffset.dy);
    }

    _updateLeftPageMatrix4();
  }

  void onLeftPageDragEnd(DragEndDetails details) {
    if (_isRightPageTurning) {
      return;
    }

    _isLeftPageTurning = true;

    if (1 - _dragLeftPageOffset.dx.abs() / _viewportSize.width < 0.7) {
      _turnLeftPage();
    } else {
      _leaveLeftPage();
    }
  }

  void _turnLeftPage() {
    final curvedController = CurvedAnimation(
      parent: _leftPageAnimationController,
      curve: Curves.ease,
    );

    final tweenAnimation = Tween<Offset>(
      begin: _dragLeftPageOffset,
      end: Offset(_viewportSize.width, _dragLeftPageOffset.dy),
    ).animate(curvedController);

    tweenAnimationListener() {
      _dragLeftPageOffset = tweenAnimation.value;
      _updateLeftPageMatrix4();
    }

    _addListenerOnAnimation(
      animation: tweenAnimation,
      listener: tweenAnimationListener,
    );

    _leftPageAnimationController.forward(from: 0.0);
  }

  void _leaveLeftPage() {
    final curvedController = CurvedAnimation(
      parent: _leftPageAnimationController,
      curve: Curves.ease,
    );

    final tweenAnimation = Tween<Offset>(
      begin: _dragLeftPageOffset,
      end: Offset(0.0, _dragLeftPageOffset.dy),
    ).animate(curvedController);

    tweenAnimationListener() {
      _dragLeftPageOffset = tweenAnimation.value;
      _updateLeftPageMatrix4();
    }

    _addListenerOnAnimation(
      animation: tweenAnimation,
      listener: tweenAnimationListener,
    );

    _leftPageAnimationController.forward(from: 0.0);
  }

  void onRightPageDragUpdate(DragUpdateDetails details) {
    if (_isLeftPageTurning) {
      return;
    }

    _rightPageAnimationController.stop();

    _dragRightPageOffset += details.delta;

    if (_dragRightPageOffset.dx > 0.0) {
      _dragRightPageOffset = Offset(0.0, _dragRightPageOffset.dy);
    }

    if (_dragRightPageOffset.dx < -1 * _viewportSize.width) {
      _dragRightPageOffset =
          Offset(-1 * _viewportSize.width, _dragRightPageOffset.dy);
    }

    _updateRightPageMatrix4();
  }

  void onRightPageDragEnd(DragEndDetails details) {
    if (_isLeftPageTurning) {
      return;
    }

    _isRightPageTurning = true;

    if (1 - _dragRightPageOffset.dx.abs() / _viewportSize.width < 0.7) {
      _turnRightPage();
    } else {
      _leaveRightPage();
    }
  }

  void _turnRightPage() {
    final curvedController = CurvedAnimation(
      parent: _rightPageAnimationController,
      curve: Curves.ease,
    );

    final tweenAnimation = Tween<Offset>(
      begin: _dragRightPageOffset,
      end: Offset(-1.0 * _viewportSize.width, _dragRightPageOffset.dy),
    ).animate(curvedController);

    tweenAnimationListener() {
      _dragRightPageOffset = tweenAnimation.value;
      _updateRightPageMatrix4();
    }

    _addListenerOnAnimation(
      animation: tweenAnimation,
      listener: tweenAnimationListener,
    );

    _rightPageAnimationController.forward(from: 0.0);
  }

  void _leaveRightPage() {
    final curvedController = CurvedAnimation(
      parent: _rightPageAnimationController,
      curve: Curves.ease,
    );

    final tweenAnimation = Tween<Offset>(
      begin: _dragRightPageOffset,
      end: Offset(0.0, _dragRightPageOffset.dy),
    ).animate(curvedController);

    tweenAnimationListener() {
      _dragRightPageOffset = tweenAnimation.value;
      _updateRightPageMatrix4();
    }

    _addListenerOnAnimation(
      animation: tweenAnimation,
      listener: tweenAnimationListener,
    );

    _rightPageAnimationController.forward(from: 0.0);
  }

  void _addListenerOnAnimation({
    required Animation animation,
    required void Function() listener,
  }) {
    animation.addListener(listener);

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animation.removeListener(listener);
      }
    });
  }

  void _updateLeftPageMatrix4() {
    final translateY = _dragLeftPageOffset.dx;
    behindLeftPageMatrix4 = Matrix4(
      1,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
      0,
      -1 * _viewportSize.width + translateY,
      0,
      0,
      1,
    );

    leftPageWidthRatio = 1 - (translateY.abs() / _viewportSize.width);

    behindLeftPageShadowMatrix4 = Matrix4(
      1 - leftPageWidthRatio,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
    );

    nextFloatingShadowMatrix4 = Matrix4(
      leftPageWidthRatio,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
    );

    prevFloatingShadowMatrix4 = Matrix4(
      1 - leftPageWidthRatio,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
    );

    notify();
  }

  void _updateRightPageMatrix4() {
    final translateY = _dragRightPageOffset.dx;

    frontRightPageMatrix4 = Matrix4(
      1,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
      0,
      translateY,
      0,
      0,
      1,
    );

    rightPageWidthRatio = 1 - (translateY.abs() / _viewportSize.width);

    frontRightPageShadowMatrix4 = Matrix4(
      rightPageWidthRatio,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
    );

    frontLeftPageShadowMatrix4 = Matrix4(
      rightPageWidthRatio,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
    );

    nextFloatingShadowMatrix4 = Matrix4(
      (1 - rightPageWidthRatio).clamp(0.0, 1.0),
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      1,
    );

    notify();
  }
}
