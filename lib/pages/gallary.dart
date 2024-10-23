import 'package:big_tour/general/global_variable.dart';
import 'package:big_tour/widgets/cached_image.dart';
import 'package:big_tour/widgets/image_list.dart';
import "package:flutter/material.dart";

class Gallary extends StatefulWidget {
  const Gallary(
    this.images, {
    this.bottomPosition = 0,
    this.onTap,
    this.isSquare = false,
    this.onLongPress,
    this.addNewImage,
    super.key,
  });

  final List<String> images;
  final double bottomPosition;
  final Function()? onTap;
  final Function(String selectedImageIndex)? onLongPress;
  final Function()? addNewImage;
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
      onTap: widget.onTap ?? () => Navigator.pop(context),
      onLongPress: isAdmin ? () => widget.onLongPress!(currentImage) : null,
      child: CachedImage(
        imageUrl: currentImage,
      ),
    );

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Hero(
          tag: 'image-${widget.images.first}',
          child: widget.isSquare
              ? ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: imageView,
                  ))
              : imageView,
        ),
        Positioned(
            width: MediaQuery.of(context).size.width,
            bottom: widget.bottomPosition,
            child: Hero(
              tag: 'imageList',
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ImageList(
                  widget.images,
                  onSelect: (selectedIndex) => {
                    setState(() => currentImage = widget.images[selectedIndex])
                  },
                  addNewImage: widget.addNewImage,
                ),
              ),
            ))
      ],
    );
  }
}
