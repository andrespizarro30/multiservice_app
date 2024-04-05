
import 'package:flutter/cupertino.dart';

import '../utils/dimension.dart';


class BigText extends StatelessWidget {

  final Color? color;
  final String text;
  double size;
  TextOverflow overflow;
  int linesNumber;

  BigText({super.key,
    required this.text,
    this.color = const Color(0xFF332d2b),
    this.size = 0,
    this.overflow = TextOverflow.ellipsis,
    this.linesNumber = 1
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: linesNumber,
      overflow: overflow,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
        fontSize: size ==0?Dimensions.font20:size
      ),
    );
  }
}
