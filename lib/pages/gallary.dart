import 'dart:math';

import 'package:big_tour/widgets/image_list.dart';
import "package:flutter/material.dart";

class Gallary extends StatefulWidget {
  const Gallary(
    this.images, {
    this.bottomPosition = 0,
    this.onTap,
    this.isSquare = false,
    super.key,
  });

  final List<String> images;
  final double bottomPosition;
  final Function()? onTap;
  final bool isSquare;

  @override
  State<Gallary> createState() => _GallaryState();
}

class _GallaryState extends State<Gallary> {
  String currentImage = "";
  @override
  initState() {
    super.initState();
    currentImage = widget.images.first;
  }

  @override
  Widget build(BuildContext context) {
    Widget imageView = GestureDetector(
      onTap: widget.onTap,
      child: Image.network(currentImage, fit: BoxFit.cover),
    );

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        widget.isSquare
            ? ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: imageView,
                ))
            : imageView,
        Positioned(
            bottom: widget.bottomPosition,
            child: ImageList(
              widget.images.sublist(0, min(5, widget.images.length)),
              onSelect: (selectedIndex) =>
                  {setState(() => currentImage = widget.images[selectedIndex])},
            ))
      ],
    );
  }
}
