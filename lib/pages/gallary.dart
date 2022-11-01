import 'package:big_tour/components/imageList.dart';
import "package:flutter/material.dart";

class Gallary extends StatelessWidget {
  const Gallary({
    this.bottomPosition = 0,
    this.onTap,
    super.key,
  });

  final double bottomPosition;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          child: AspectRatio(
            aspectRatio: 1,
            child: GestureDetector(
              onTap: onTap,
              child: Image.network(
                "https://images.unsplash.com/photo-1664575197229-3bbebc281874?q=40&w=576",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: bottomPosition,
          child: const ImageList(),
        )
      ],
    );
  }
}
