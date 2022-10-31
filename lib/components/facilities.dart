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
            5,
            (index) => SizedBox(
                  width: size,
                  child: const Card(
                    elevation: 6,
                    child: Icon(
                      size: 16,
                      Icons.accessible_forward_sharp,
                      color: Colors.amber,
                    ),
                  ),
                )),
      ),
    );
  }
}
