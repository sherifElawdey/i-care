import 'package:get/get.dart';
import 'package:icare/helper/general_methods.dart';
import 'package:icare/helper/styles/colors.dart';
import 'package:icare/helper/styles/size.dart';
import 'package:icare/modules/tile_item_model.dart';
import 'package:icare/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends GestureDetector {
  CustomButton({
    Key? key,
    required String text,
    required BuildContext context,
    VoidCallback? onTap,
    VoidCallback? onLongTap,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? width,
    double? height,
    double? textSize,
    BorderRadius? radius,
    Color? color,
    IconData? leading,
  }) : super(
            key: key,
            onTap: onTap,
            onLongPress: onLongTap,
            child: Container(
              width: width,
              height: height,
              padding: padding ?? const EdgeInsets.symmetric(vertical: 8,horizontal: 20),
              margin: margin ?? Sizes.marginTextFields(context),
              decoration: BoxDecoration(
                  color: color ?? appColor,
                  borderRadius:radius ?? Sizes.borderRadius(context)['r3']
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: text,
                    textAlign: TextAlign.center,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    size: textSize ?? Sizes.textSize(context)['h4']),
                  if (leading != null) SizedBox(width: Sizes.sizedBox(context)['w1']),
                  if (leading != null) Icon(leading,color: Colors.white,),
                ],
              ),
            ));
}

class CustomBackButton extends IconButton {
  CustomBackButton(BuildContext context,{
    Key? key,
    Color? color,
    double? iconSize,
  })
      : super(key: key,
          icon: const Icon(CupertinoIcons.back),
          onPressed: (){Get.back();},
          color: color,
          iconSize: iconSize ?? 30,
        );
}

class CustomTextButton extends TextButton{
  CustomTextButton({
    Key? key,
    required String text,
    required VoidCallback onTap,
    TextDecoration? textDecoration,
    Color? color,
    double? size,

}) : super(
    key: key,
    onPressed: onTap,
    child: CustomText(
      text: text,
      textDecoration: textDecoration,
      color: color,
      size: size,
    ),
  );
}


Widget iconItem(BuildContext context,TileItemModel item) {
  return InkWell(
    onTap: item.onTap,
    child: Column(
      children: [
        Container(
          width: 55,
          height: 55,
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).cardColor,
            boxShadow: [customShadow()],
          ),
          child: Icon(
            item.leadingIcon,
            size: 35,
            color: appColor,
          ),
        ),
        CustomText(text: '${item.title}', fontWeight: FontWeight.w500),
      ],
    ),
  );
}
