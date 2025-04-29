import 'package:flutter/material.dart';

class ImagedButton extends StatelessWidget {
  const ImagedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.url,
  }) : super(key: key);

  final String text;
  final String url;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: InkWell(
          onTap: onPressed,
          child: Column(
            children: [
              SizedBox(width: 42, child: Image.network(url)),
              Text(text),
            ],
          ),
        ));
  }
}
