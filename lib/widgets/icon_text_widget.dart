import 'package:flutter/material.dart';
import '../utils/dimension.dart';
import 'app_icon.dart';
import 'big_text.dart';

class IconTextWidget extends StatelessWidget {

  ApplIcon applIcon;
  BigText bigText;
  Color borderColor;

  IconTextWidget({
    super.key,
    required this.applIcon,
    required this.bigText,
    this.borderColor = Colors.grey
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: Dimensions.width20,top: Dimensions.height10,bottom: Dimensions.height10,right: Dimensions.width20),
      child: Row(
        children: [
          applIcon,
          SizedBox(width: Dimensions.width20,),
          Flexible(child: bigText)
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(Dimensions.radius30)),
          border: Border.all(color: borderColor),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                offset: Offset(0,0),
                color: Colors.grey.withOpacity(0.1)
            )
          ]
      ),
    );
  }
}
