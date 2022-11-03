import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Facilities extends StatelessWidget {
  const Facilities({Key? key, required this.size}) : super(key: key);

  final double size;

  static List<String> s = [
    "bonefire.svg",
    "hiking.svg",
    "hot_air_ballon.svg",
    "kayak.svg",
    "swimming.svg",
    "tent.svg",
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ...s.map((svgUrl) => SizedBox(
                width: size,
                child: Card(
                    elevation: 6,
                    child: SvgPicture.asset(
                      'images/svg/$svgUrl',
                      width: size,
                      height: size,
                    )),
              ))
        ],
      ),
    );
  }
}
