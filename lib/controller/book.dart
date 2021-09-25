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

  late Offset _dragRightPageOffset;
  late Offset _dragLeftPageOffset;

  late double leftPageWidthRatio;
  late double rightPageWidthRatio;

  late Size _viewportSize;

  late final AnimationController _animationController;

  BookController() {
    _initialize(page: 0);
  }

  void _initialize({required int page}) {
    _page = page;

    _dragRightPageOffset = Offset.zero;
    _dragLeftPageOffset = Offset.zero;

    frontRightPageMatrix4 = Matrix4.identity();
    behindLeftPageMatrix4 = Matrix4.identity();

    leftPageWidthRatio = 1;
    rightPageWidthRatio = 1;
  }

  void attachTickerProvider(TickerProvider tickerProvider) {
    _animationController = AnimationController(
      vsync: tickerProvider,
      duration: const Duration(milliseconds: 500),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_dragRightPageOffset.dx < 0.0) {
          _initialize(page: _page + 2);
          notify();
        }
        if (_dragLeftPageOffset.dx > 0.0) {
          _initialize(page: _page - 2);
          notify();
        }
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
    _animationController.stop();

    _dragLeftPageOffset += details.delta;

    _updateLeftPageMatrix4();
  }

  void onLeftPageDragEnd(DragEndDetails details) {
    if (1 - _dragLeftPageOffset.dx.abs() / _viewportSize.width < 0.7) {
      _turnLeftPage();
    } else {
      _leaveLeftPage();
    }
  }

  void _turnLeftPage() {
    final curvedController = CurvedAnimation(
      parent: _animationController,
      curve: Curves.ease,
    );

    final tweenAnimation = Tween<Offset>(
      begin: _dragLeftPageOffset,
      end: Offset(_viewportSize.width, 0.0),
    ).animate(curvedController);

    tweenAnimationListener() {
      _dragLeftPageOffset = tweenAnimation.value;
      _updateLeftPageMatrix4();
    }

    _addListenerOnAnimation(
      animation: tweenAnimation,
      listener: tweenAnimationListener,
    );

    _animationController.forward(from: 0.0);
  }

  void _leaveLeftPage() {
    final curvedController = CurvedAnimation(
      parent: _animationController,
      curve: Curves.ease,
    );

    final tweenAnimation = Tween<Offset>(
      begin: _dragLeftPageOffset,
      end: Offset.zero,
    ).animate(curvedController);

    tweenAnimationListener() {
      _dragLeftPageOffset = tweenAnimation.value;
      _updateLeftPageMatrix4();
    }

    _addListenerOnAnimation(
      animation: tweenAnimation,
      listener: tweenAnimationListener,
    );

    _animationController.forward(from: 0.0);
  }

  void onRightPageDragUpdate(DragUpdateDetails details) {
    _animationController.stop();

    _dragRightPageOffset += details.delta;

    if (_dragRightPageOffset.dx > 0) {
      _dragRightPageOffset = Offset.zero;
      return;
    }

    _updateRightPageMatrix4();
  }

  void onRightPageDragEnd(DragEndDetails details) {
    if (1 - _dragRightPageOffset.dx.abs() / _viewportSize.width < 0.7) {
      _turnRightPage();
    } else {
      _leaveRightPage();
    }
  }

  void _turnRightPage() {
    final curvedController = CurvedAnimation(
      parent: _animationController,
      curve: Curves.ease,
    );

    final tweenAnimation = Tween<Offset>(
      begin: _dragRightPageOffset,
      end: Offset(-1.0 * _viewportSize.width, 0.0),
    ).animate(curvedController);

    tweenAnimationListener() {
      _dragRightPageOffset = tweenAnimation.value;
      _updateRightPageMatrix4();
    }

    _addListenerOnAnimation(
      animation: tweenAnimation,
      listener: tweenAnimationListener,
    );

    _animationController.forward(from: 0.0);
  }

  void _leaveRightPage() {
    final curvedController = CurvedAnimation(
      parent: _animationController,
      curve: Curves.ease,
    );

    final tweenAnimation = Tween<Offset>(
      begin: _dragRightPageOffset,
      end: Offset.zero,
    ).animate(curvedController);

    tweenAnimationListener() {
      _dragRightPageOffset = tweenAnimation.value;
      _updateRightPageMatrix4();
    }

    _addListenerOnAnimation(
      animation: tweenAnimation,
      listener: tweenAnimationListener,
    );

    _animationController.forward(from: 0.0);
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

    notify();
  }
}
