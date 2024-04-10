import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/dimension.dart';


class AppTextField extends StatelessWidget {

  final TextEditingController textEditingController;
  final String textHint;
  final IconData icon;
  final TextInputType textInputType;
  final bool isPassword;

  AppTextField({
    super.key,
    required this.textEditingController,
    required this.textHint,
    required this.icon,
    required this.textInputType,
    this.isPassword = false
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(left: Dimensions.width20,right: Dimensions.width20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimensions.radius30),
          boxShadow: [
            BoxShadow(
                blurRadius: Dimensions.radius20/2,
                spreadRadius: Dimensions.radius15/2,
                offset: Offset(1,10),
                color: Colors.grey.withOpacity(0.2)
            )
          ]
      ),
      child: TextField(
        keyboardType: textInputType,
        controller: textEditingController,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: textHint,
          prefixIcon: Icon(icon, color: AppColors.mainColor,),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular((Dimensions.radius15)),
            borderSide: BorderSide(
                width: 1.0,
                color: Colors.transparent
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular((Dimensions.radius15)),
            borderSide: BorderSide(
                width: 1.0,
                color: Colors.transparent
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular((Dimensions.radius15)),
            borderSide: BorderSide(
                width: 1.0,
                color: Colors.transparent
            ),
          ),
        ),
      ),
    );
  }
}
