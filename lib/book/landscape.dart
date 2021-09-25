import 'package:book_sample/book/page.dart';
import 'package:book_sample/controller/book.dart';
import 'package:flutter/material.dart';

class BookLandscapeView extends StatefulWidget {
  late final _BookLandscapeViewState _state;
  late final BookController controller;

  BookLandscapeView({Key? key}) : super(key: key) {
    _state = _BookLandscapeViewState();
    controller = BookController(viewState: _state);
  }

  @override
  // ignore: no_logic_in_create_state
  State<BookLandscapeView> createState() => _state;
}

class _BookLandscapeViewState extends State<BookLandscapeView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.controller.fetchData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Stack(
            children: [
              Row(
                children: [
                  Expanded(
                    child: widget.controller.frontLeftPage != null
                        ? BookPage(
                            paragraph:
                                widget.controller.frontLeftPage!.paragraph,
                            imageUrl: widget.controller.frontLeftPage!.image,
                          )
                        : Container(),
                  ),
                  Expanded(
                    child: widget.controller.frontRightPage != null
                        ? BookPage(
                            paragraph:
                                widget.controller.frontRightPage!.paragraph,
                            imageUrl: widget.controller.frontRightPage!.image,
                          )
                        : Container(),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: widget.controller.behindLeftPage != null
                        ? BookPage(
                            paragraph:
                                widget.controller.behindLeftPage!.paragraph,
                            imageUrl: widget.controller.behindLeftPage!.image,
                          )
                        : Container(),
                  ),
                  Expanded(
                    child: widget.controller.behindRightPage != null
                        ? BookPage(
                            paragraph:
                                widget.controller.behindRightPage!.paragraph,
                            imageUrl: widget.controller.behindRightPage!.image,
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
