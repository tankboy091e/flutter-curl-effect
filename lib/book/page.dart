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
        SizedBox(
          height: double.infinity,
          child: Image(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              paragraph,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ),
        )
      ],
    );
  }
}
