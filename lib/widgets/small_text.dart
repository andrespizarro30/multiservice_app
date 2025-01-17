import 'package:flutter/cupertino.dart';

class SmallText extends StatelessWidget {

  final Color? color;
  final String text;
  double size;
  double height;
  TextOverflow overflow;
  int maxLines;

  SmallText({super.key,
    required this.text,
    this.color = const Color(0xFFccc7c5),
    this.size = 12,
    this.height = 1.2,
    this.overflow = TextOverflow.visible,
    this.maxLines = 2
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: color,
          fontFamily: 'Roboto',
          fontSize: size,
          height: height,
          overflow: overflow
      ),
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}