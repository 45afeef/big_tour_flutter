import 'package:big_tour/components/imageList.dart';
import "package:flutter/material.dart";

class Gallary extends StatelessWidget {
  const Gallary({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Image.network(
            "https://images.unsplash.com/photo-1664575197229-3bbebc281874?q=40&w=576",
            fit: BoxFit.cover,
          ),
        ),
        const Positioned(
          bottom: 0,
          child: ImageList(),
        )
      ],
    );
  }
}
