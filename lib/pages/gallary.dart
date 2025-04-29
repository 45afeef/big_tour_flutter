import 'package:big_tour/general/global_variable.dart';
import "package:flutter/material.dart";

import '../widgets/cached_image.dart';
import '../widgets/image_list.dart';

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
  final PageController _controller = PageController();

  int currentIndex = 0;
  BoxFit imageFit = BoxFit.cover;

  void _onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget imageView = GestureDetector(
      onTap: widget.onTap ??
          () => setState(() {
                if (imageFit == BoxFit.cover) {
                  imageFit = BoxFit.contain;
                } else {
                  imageFit = BoxFit.cover;
                }
              }),
      onLongPress: isAdmin
          ? () => widget.onLongPress!(widget.images[currentIndex])
          : null,
      child: PageView.builder(
        controller: _controller,
        itemCount: widget.images.length,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          return CachedImage(
            imageUrl: widget.images[index],
            fit: imageFit,
          );
        },
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
                onSelect: (i) => _controller.jumpToPage(i),
                addNewImage: widget.addNewImage,
              ),
            ),
          ),
        )
      ],
    );
  }
}
