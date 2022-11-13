import 'package:big_tour/widgets/image_list.dart';
import "package:flutter/material.dart";

class Gallary extends StatefulWidget {
  const Gallary(
    this.images, {
    this.bottomPosition = 0,
    this.onTap,
    super.key,
  });

  final List<String> images;
  final double bottomPosition;
  final Function()? onTap;

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
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          child: AspectRatio(
            aspectRatio: 1,
            child: GestureDetector(
              onTap: widget.onTap,
              child: Image.network(currentImage, fit: BoxFit.cover),
            ),
          ),
        ),
        Positioned(
          bottom: widget.bottomPosition,
          child: ImageList(
            widget.images,
            onSelect: (selectedIndex) =>
                {setState(() => currentImage = widget.images[selectedIndex])},
          ),
        )
      ],
    );
  }
}
