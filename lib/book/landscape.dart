import 'package:book_sample/book/page.dart';
import 'package:book_sample/controller/book.dart';
import 'package:book_sample/interfaces/view.dart';
import 'package:flutter/material.dart';

class BookLandscapeView extends StatefulWidget {
  const BookLandscapeView({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<BookLandscapeView> createState() => _BookLandscapeViewState();
}

class _BookLandscapeViewState extends ViewState<BookLandscapeView>
    with SingleTickerProviderStateMixin {
  late final BookController _controller = BookController();

  @override
  void initState() {
    _controller.attachTickerProvider(this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.detach(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.attach(this);
    _controller.attachContext(context);
    return FutureBuilder(
      future: _controller.loadData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Stack(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _controller.backgroundLeftPage != null
                        ? BookPage(
                            paragraph:
                                _controller.backgroundLeftPage!.paragraph,
                            imageUrl: _controller.backgroundLeftPage!.image,
                          )
                        : Container(),
                  ),
                  Expanded(
                    child: _controller.backgroundRightPage != null
                        ? BookPage(
                            paragraph:
                                _controller.backgroundRightPage!.paragraph,
                            imageUrl: _controller.backgroundRightPage!.image,
                          )
                        : Container(),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _controller.behindRightPage != null
                        ? ClipRect(
                            clipper:
                                BehindRightPageClipper(controller: _controller),
                            child: BookPage(
                              paragraph: _controller.behindRightPage!.paragraph,
                              imageUrl: _controller.behindRightPage!.image,
                            ),
                          )
                        : Container(),
                  ),
                  const Spacer(flex: 1)
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _controller.frontLeftPage != null
                        ? ClipRect(
                            clipper:
                                FrontLeftPageClipper(controller: _controller),
                            child: BookPage(
                              paragraph: _controller.frontLeftPage!.paragraph,
                              imageUrl: _controller.frontLeftPage!.image,
                            ),
                          )
                        : Container(),
                  ),
                  Expanded(
                    child: _controller.frontRightPage != null
                        ? Transform(
                            transform: _controller.frontRightPageMatrix4,
                            origin: const Offset(0.0, 0.5),
                            child: ClipRect(
                              clipper: FrontRightPageClipper(
                                  controller: _controller),
                              child: BookPage(
                                paragraph:
                                    _controller.frontRightPage!.paragraph,
                                imageUrl: _controller.frontRightPage!.image,
                              ),
                            ),
                          )
                        : Container(),
                  )
                ],
              ),
              Row(
                children: [
                  const Spacer(flex: 1),
                  Expanded(
                    child: _controller.behindLeftPage != null
                        ? Transform(
                            transform: _controller.behindLeftPageMatrix4,
                            child: ClipRect(
                              clipper: BehindLeftPageClipper(
                                  controller: _controller),
                              child: BookPage(
                                paragraph:
                                    _controller.behindLeftPage!.paragraph,
                                imageUrl: _controller.behindLeftPage!.image,
                              ),
                            ),
                          )
                        : Container(),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _controller.behindLeftPage != null
                        ? GestureDetector(
                            onHorizontalDragUpdate:
                                _controller.onLeftPageDragUpdate,
                            onHorizontalDragEnd: _controller.onLeftPageDragEnd,
                            child: Container(
                              color: Colors.red.withOpacity(0.0),
                            ),
                          )
                        : Container(),
                  ),
                  const Spacer(flex: 1),
                  Expanded(
                    flex: 2,
                    child: _controller.behindRightPage != null
                        ? GestureDetector(
                            onHorizontalDragUpdate:
                                _controller.onRightPageDragUpdate,
                            onHorizontalDragEnd: _controller.onRightPageDragEnd,
                            child: Container(
                              color: Colors.blue.withOpacity(0.0),
                            ),
                          )
                        : Container(),
                  )
                ],
              ),
            ],
          );
        }

        return const CircularProgressIndicator();
      },
    );
  }
}

class BehindLeftPageClipper extends CustomClipper<Rect> {
  final BookController controller;

  BehindLeftPageClipper({required this.controller});

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(
      size.width * controller.leftPageWidthRatio,
      0.0,
      size.width,
      size.height,
    );
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return true;
  }
}

class BehindRightPageClipper extends CustomClipper<Rect> {
  final BookController controller;

  BehindRightPageClipper({required this.controller});

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(
      size.width * (1 - controller.leftPageWidthRatio),
      0.0,
      size.width,
      size.height,
    );
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return true;
  }
}

class FrontLeftPageClipper extends CustomClipper<Rect> {
  final BookController controller;

  FrontLeftPageClipper({required this.controller});

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(
      size.width * (1 - controller.leftPageWidthRatio),
      0.0,
      size.width * controller.rightPageWidthRatio,
      size.height,
    );
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return true;
  }
}

class FrontRightPageClipper extends CustomClipper<Rect> {
  final BookController controller;

  FrontRightPageClipper({required this.controller});

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(
      size.width * (1 - controller.rightPageWidthRatio),
      0.0,
      size.width,
      size.height,
    );
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return true;
  }
}
