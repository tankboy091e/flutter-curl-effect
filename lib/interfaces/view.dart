import 'package:flutter/material.dart';

abstract class ViewState<T extends StatefulWidget> extends State<T> {
  void update() {
    setState(() {});
  }
}
