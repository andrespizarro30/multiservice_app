import 'package:flutter/cupertino.dart';

class SmallText extends StatelessWidget {

  final Color? color;
  final String text;
  double size;
  double height;
  TextOverflow overflow;

  SmallText({super.key,
    required this.text,
    this.color = const Color(0xFFccc7c5),
    this.size = 12,
    this.height = 1.2,
    this.overflow = TextOverflow.visible
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: color,
          fontFamily: 'Roboto',
          fontSize: size,
          height: height
      ),
      overflow: overflow,
    );
  }
}