import 'package:book_sample/controller/base.dart';
import 'package:book_sample/model/book.dart';
import 'package:book_sample/model/page.dart';
import 'package:book_sample/repository/book.dart';
import 'package:flutter/material.dart';

class BookController extends BaseController {
  late int page;

  BookController({required State viewState}) : super(viewState: viewState) {
    page = 0;
  }

  late BookModel _book;

  PageModel? get frontLeftPage {
    try {
      return _book.pages[page];
    } on RangeError {
      return null;
    }
  }

  PageModel? get frontRightPage {
    try {
      return _book.pages[page + 1];
    } on RangeError {
      return null;
    }
  }

  PageModel? get behindLeftPage {
    try {
      return _book.pages[page - 1];
    } on RangeError {
      return null;
    }
  }

  PageModel? get behindRightPage {
    try {
      return _book.pages[page + 2];
    } on RangeError {
      return null;
    }
  }

  Future<BookModel> fetchData() async {
    final data = await BookRepository().retrieveAll();

    _book = data[0];

    return _book;
  }
}
