import 'package:flutter/material.dart';

class BaseController {
  State viewState;

  BaseController({required this.viewState});

  void notify() {
    // ignore: invalid_use_of_protected_member
    viewState.setState(() {});
  }
}
