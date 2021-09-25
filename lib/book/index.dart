import 'package:book_sample/book/landscape.dart';
import 'package:book_sample/book/portrait.dart';
import 'package:flutter/material.dart';

class BookView extends StatelessWidget {
  const BookView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.landscape) {
            return BookLandscapeView();
          }

          return const BookPortraitView();
        },
      ),
    );
  }
}
