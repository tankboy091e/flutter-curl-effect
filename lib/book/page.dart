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
    return SizedBox(
      height: double.infinity,
      child: Image(
        image: NetworkImage(imageUrl),
        fit: BoxFit.cover,
      ),
    );
  }
}
