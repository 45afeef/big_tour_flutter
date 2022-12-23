import 'package:big_tour/general/global_variable.dart';
import 'package:flutter/material.dart';

import 'cached_image.dart';

class ImageList extends StatefulWidget {
  const ImageList(
    this.images, {
    Key? key,
    required this.onSelect,
    this.addNewImage,
  }) : super(key: key);

  final List<String> images;
  final Function(int selectionIndex) onSelect;
  final Function()? addNewImage;

  @override
  State<ImageList> createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  int _selected = 0;

  void _setSelected(int i) {
    setState(() {
      _selected = i;
      widget.onSelect(_selected);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      ...widget.images
          .asMap()
          .map((i, imageUrl) => MapEntry(
              i,
              GestureDetector(
                onTap: (() => _setSelected(i)),
                child: Card(
                  margin: const EdgeInsets.all(0),
                  shape: RoundedRectangleBorder( 
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 3,
                  color:
                      i == _selected ? Colors.white : const Color(0x77ffffff),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      child: CachedImage(
                        imageUrl: imageUrl,
                        width: i == _selected ? 70 : 60,
                        height: i == _selected ? 70 : 60,
                      ),
                    ),
                  ),
                ),
              )))
          .values,
      isAdmin
          ? GestureDetector(
              onTap: widget.addNewImage,
              child: Card(
                margin: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 3,
                child: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    child: Icon(Icons.add),
                  ),
                ),
              ),
            )
          : const SizedBox(),
    ]);
  }
}
