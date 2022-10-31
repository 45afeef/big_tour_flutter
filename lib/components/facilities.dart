import 'dart:math';

import 'package:flutter/material.dart';

class Facilities extends StatelessWidget {
  const Facilities({Key? key, required this.size}) : super(key: key);

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(
            15,
            (index) => SizedBox(
                  width: size,
                  child: Card(
                    elevation: 6,
                    child: Icon(
                      size: min(size * 16 / 30, 24),
                      Icons.accessible_forward_sharp,
                      color: Colors.amber,
                    ),
                  ),
                )),
      ),
    );
  }
}
