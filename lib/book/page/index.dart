import 'package:flutter/material.dart';

class BookPage extends StatelessWidget {
  final String paragraph;
  final String imageUrl;

  const BookPage({
    Key? key,
    required this.paragraph,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        paper,
        text,
      ],
    );
  }

  Widget get paper {
    return Container(
      height: double.infinity,
      color: Colors.white,
    );
  }

  Widget get text {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Text(
          paragraph,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}
