
import 'package:flutter/material.dart';

import '../utils/dimension.dart';
import 'app_icon.dart';
import 'big_text.dart';


class AccountWidget extends StatelessWidget {

  ApplIcon applIcon;
  BigText bigText;

  AccountWidget({
    super.key,
    required this.applIcon,
    required this.bigText
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
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0,5),
            color: Colors.grey.withOpacity(0.1)
          )
        ]
      ),
    );
  }
}
