import 'package:book_sample/controller/base.dart';
import 'package:book_sample/model/book.dart';
import 'package:book_sample/model/page.dart';
import 'package:book_sample/repository/book.dart';
import 'package:flutter/material.dart';

class BookController extends BaseController {
  late int _page;

  BookModel? _book;

  late Offset _dragOffset;

  late Matrix4 frontLeftPageMatrix4;
  late Matrix4 frontRightPageMatrix4;
  late Matrix4 behindLeftPageMatrix4;
  late Matrix4 behindRightPageMatrix4;

  late double leftPageWidthRatio;
  late double rightPageWidthRatio;

  late Size _viewportSize;

  late final AnimationController _animationController;

  BookController() {
    _initialize(page: 0);
  }

  void _initialize({required int page}) {
    _page = page;

    _dragOffset = Offset.zero;

    frontLeftPageMatrix4 = Matrix4.identity();
    frontRightPageMatrix4 = Matrix4.identity();
    behindLeftPageMatrix4 = Matrix4.identity();
    behindRightPageMatrix4 = Matrix4.identity();

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
        if (_dragOffset.dx < 0) {
          _initialize(page: _page + 2);
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

  void onLeftPageDragStart(DragStartDetails details) {}

  void onLeftPageDragUpdate(DragUpdateDetails details) {
    _animationController.stop();

    _dragOffset += details.delta;
  }

  void onLeftPageDragEnd(DragEndDetails details) {
    _dragOffset = Offset.zero;
  }

  void onRightPageDragStart(DragStartDetails details) {}

  void onRightPageDragUpdate(DragUpdateDetails details) {
    _animationController.stop();

    _dragOffset += details.delta;

    if (_dragOffset.dx > 0) {
      _dragOffset = Offset.zero;
      return;
    }

    _updateFrontRightPageMatrix4();
  }

  void onRightPageDragEnd(DragEndDetails details) {
    if (1 - _dragOffset.dx.abs() / _viewportSize.width < 0.7) {
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
      begin: _dragOffset,
      end: Offset(-1.0 * _viewportSize.width, 0.0),
    ).animate(curvedController);

    tweenAnimation.addListener(() {
      _dragOffset = tweenAnimation.value;
      _updateFrontRightPageMatrix4();
    });

    _animationController.forward(from: 0.0);
  }

  void _leaveRightPage() {
    final curvedController = CurvedAnimation(
      parent: _animationController,
      curve: Curves.ease,
    );

    final tweenAnimation = Tween<Offset>(
      begin: _dragOffset,
      end: Offset.zero,
    ).animate(curvedController);

    tweenAnimation.addListener(() {
      _dragOffset = tweenAnimation.value;
      _updateFrontRightPageMatrix4();
    });

    _animationController.forward(from: 0.0);
  }

  void _updateFrontRightPageMatrix4() {
    final translateY = _dragOffset.dx;

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
