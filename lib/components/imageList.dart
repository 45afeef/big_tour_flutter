import 'package:flutter/material.dart';

class ImageList extends StatefulWidget {
  const ImageList({
    Key? key,
  }) : super(key: key);

  @override
  State<ImageList> createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  int _selected = 0;

  void _setSelected(int i) {
    setState(() {
      _selected = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        4,
        (i) => GestureDetector(
          onTap: (() => _setSelected(i)),
          child: Card(
            margin: const EdgeInsets.all(0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 3,
            color: i == _selected ? Colors.white : const Color(0x77ffffff),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: Image.network(
                  "https://images.unsplash.com/photo-1664575197229-3bbebc281874?q=40&w=60",
                  width: i == _selected ? 70 : 60,
                  height: i == _selected ? 70 : 60,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
