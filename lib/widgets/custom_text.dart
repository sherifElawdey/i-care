import 'package:icare/helper/general_methods.dart';
import 'package:icare/helper/styles/colors.dart';
import 'package:flutter/material.dart';


class CustomText extends Text{
  CustomText({super.key,
    required String text,
    double? size,
    Color? color,
    int? maxLines,
    TextDirection? textDirection,
    TextDecoration? textDecoration,
    TextAlign? textAlign,
    FontWeight? fontWeight,
  }) :super(text,
        style: customTextStyle(
          size: size,
          color: color,
          fontWeight: fontWeight,
          textDecoration: textDecoration,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines:maxLines ?? 1,
        textAlign: textAlign,
      );

}

class CustomTextIcon extends Row {

  CustomTextIcon({
    super.key,
    required BuildContext context,
    required IconData icon,
    double? iconSize,
    double? textSize,
    double? widthBetween,
    Color?  textColor,
    int? maxLines,
    required String text,
    Color? iconColor ,
  }): super(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  mainAxisSize: MainAxisSize.min,
  children:[
      Icon(icon, color: iconColor ?? appColor,size: iconSize,),
      SizedBox(width: widthBetween),
      Flexible(
        child: CustomText(
          text: text,
          size: textSize,
          maxLines:maxLines ?? 9,
          color:  textColor,
        ),
      ),
    ],
  );
}